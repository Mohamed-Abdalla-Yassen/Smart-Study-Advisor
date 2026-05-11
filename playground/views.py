import json
import os
import math
import pandas as pd
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from pyswip import Prolog
from groq import Groq
from dotenv import load_dotenv

# ─────────────────────────────────────────────
#  STARTUP: load KB and Prolog once
# ─────────────────────────────────────────────

EXCEL_PATH = os.path.join(settings.BASE_DIR, 'playground', 'prolog', 'knowledge_base_400.xlsx')
df_kb = pd.read_excel(EXCEL_PATH)

prolog = Prolog()
prolog_file_path = os.path.join(settings.BASE_DIR, 'playground', 'prolog', 'logic.pl')
prolog.consult(prolog_file_path.replace('\\', '/'))

# ─────────────────────────────────────────────
#  HELPERS
# ─────────────────────────────────────────────

def _decode(val):
    """Ensure PySwip bytes/atoms come back as plain Python strings."""
    if isinstance(val, bytes):
        return val.decode('utf-8')
    return str(val)


def _prereq_match(db_prereq, user_prereqs):
    """
    True when:
      - the course has no prerequisite (nan / none / empty), OR
      - the DB prereq keyword appears inside at least one user prereq string.
    Example: db='Calculus'  user=['Mathematics 1 (Calculus)']  → True
    """
    db = str(db_prereq).lower().strip()
    if db in ('nan', 'none', ''):
        return True
    return any(db in up.lower() for up in user_prereqs)


def _build_course_result(course_name, matched_params, total_params, kb_row):
    """
    Build the unified result dict that is returned to the frontend.
    matched_params  – how many of the 4 optional params matched (max 4)
    total_params    – always 4  (difficulty, preference, year, prereq)
                      dept is the baseline filter, not counted here
    """
    pct = round((matched_params / total_params) * 100)

    if pct == 100:
        tier = "Tier 1 – Perfect Match (100%)"
    elif pct >= 75:
        tier = "Tier 2 – Strong Match (75%)"
    elif pct >= 50:
        tier = "Tier 3 – Partial Match (50%)"
    else:
        tier = "Tier 4 – Low Match (25%)"

    return {
        "course_name": course_name,
        "match_percentage": pct,
        "match_tier": tier,
        "matched_params": matched_params,
        "details": {
            "department":    str(kb_row['department']),
            "difficulty":    str(kb_row['difficulty']),
            "preference":    str(kb_row['preference']),
            "year_of_study": int(kb_row['year_of_study']),
            "prerequisite":  str(kb_row['prerequisite']),
        }
    }


def _query_prolog_by_dept(dept: str) -> list[str]:
    """
    Pull every course for a department from Prolog.
    Everything else (difficulty, pref, year, prereq) is left as a free
    variable – filtering happens in Python against the Excel KB so we
    get exact, auditable match percentages.
    """
    q = f"course(Course, _, _, _, _, '{dept}')"
    names = []
    for res in prolog.query(q):
        name = _decode(res["Course"])
        if name not in names:
            names.append(name)
    return names

# ── Helper: recursively replace float NaN → None ─────────────────────────────
def _sanitize(obj):
    if isinstance(obj, float) and math.isnan(obj):
        return None
    if isinstance(obj, dict):
        return {k: _sanitize(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [_sanitize(i) for i in obj]
    return obj
 
 
# ── Helper: parse a numbered / bulleted list from the model's reply ───────────
def _parse_course_list(text: str) -> list[str]:
    """
    Accepts lines like:
        1. Artificial Intelligence
        2) Object-Oriented Programming
        - Data Structures and Algorithms
        * Computer Networks
        Algorithms          ← plain line, no marker
    Returns a clean list of up to 10 non-empty course names.
    """
    import re
    courses = []
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line:
            continue
        # Strip leading markers: "1.", "1)", "-", "*", "•"
        line = re.sub(r'^[\d]+[.)]\s*', '', line)
        line = re.sub(r'^[-*•]\s*', '', line)
        line = line.strip()
        if line:
            courses.append(line)
        if len(courses) == 10:
            break
    return courses



# ENDPOINTS

@csrf_exempt #! to be removed
def get_recommendations_post(request):
    if request.method == 'POST':
        try:
            data       = json.loads(request.body)
            difficulty = data.get('difficulty', 'Medium')
            prereq     = data.get('prereq', 'nan')
            user_pref  = data.get('pref', 'Programming')
            user_year  = data.get('year', '4')
            user_dept  = data.get('dept', 'CSE')

            query = f"recommend('{difficulty}', '{prereq}', '{user_pref}', {user_year}, '{user_dept}', Course)"
            recommended_courses = []

            for result in prolog.query(query):
                course_name = _decode(result["Course"])
                if course_name not in recommended_courses:
                    recommended_courses.append(course_name)

            return JsonResponse({
                "status": "success",
                "preference_requested":  user_pref,
                "department_requested":  user_dept,
                "recommendations":       recommended_courses,
                "year_requested":        user_year,
                "difficulty_requested":  difficulty,
                "prerequisite_requested": prereq
            })
        except Exception as e:
            return JsonResponse({"status": "error", "message": str(e)}, status=500)
    return JsonResponse({"status": "error", "message": "Only POST method allowed"}, status=405)


@csrf_exempt
def get_recommendations_complex(request):
    if request.method != 'POST':
        return JsonResponse({"error": "POST only"}, status=405)
    try:
        data    = json.loads(request.body)
        dept    = data.get('dept')
        prefs   = data.get('prefs', [])
        diffs   = data.get('difficulties', [])
        years   = data.get('years', [])
        prereqs = data.get('prereqs', [])

        results      = []
        seen_courses = set()

        query = f"course(Course, Difficulty, Prereq, Preference, Year, '{dept}')"
        for res in prolog.query(query):
            c_name = _decode(res["Course"])
            if hasattr(c_name, 'value'):
                c_name = str(c_name.value)
            c_name = str(c_name)

            if c_name not in seen_courses:
                matching_rows = df_kb[df_kb['course_name'] == c_name]
                if not matching_rows.empty:
                    kb_row    = matching_rows.iloc[0]
                    diff_ok   = kb_row['difficulty'] in diffs
                    pref_ok   = kb_row['preference'] in prefs
                    year_ok   = str(int(kb_row['year_of_study'])) in [str(y) for y in years]
                    pre_ok    = _prereq_match(kb_row['prerequisite'], prereqs)
                    matched   = sum([diff_ok, pref_ok, year_ok, pre_ok])
                    match_pct = (matched / 4) * 100

                    results.append({
                        "course_name":      c_name,
                        "match_percentage": match_pct,
                        "match_tier": (
                            "Tier 1 (100%)" if match_pct == 100 else
                            "Tier 2 (75%)"  if match_pct >= 75  else
                            "Tier 3 (50%)"  if match_pct >= 50  else "Low Match"
                        ),
                        "details": kb_row.to_dict()
                    })
                    seen_courses.add(c_name)

        results = sorted(results, key=lambda x: x['match_percentage'], reverse=True)
        return JsonResponse({"status": "success", "total_found": len(results), "data": results})
    except Exception as e:
        return JsonResponse({"status": "error", "message": str(e)}, status=500)


load_dotenv()
my_api_key = os.getenv("GROQ_API_KEY")
client     = Groq(api_key=my_api_key)

@csrf_exempt
def get_AI_recommendations(request):
    try:
        if request.method != 'POST':
            return JsonResponse(
                {"status": "error", "message": "Only POST allowed"}, status=405
            )
 
        body = json.loads(request.body)
 
        # ── Accept both single-value (legacy) and multi-value (new) fields ──
        difficulties = body.get('difficulties') or [body.get('difficulty', 'Medium')]
        prefs        = body.get('prefs')        or [body.get('pref', 'Programming')]
        years        = body.get('years')        or [body.get('year', '4')]
        prereqs      = body.get('prereqs')      or [body.get('prereq', 'None')]
        dept         = body.get('dept', 'CSE')
 
        # Human-readable summaries for the prompt
        diff_str   = ', '.join(difficulties)
        pref_str   = ', '.join(prefs)
        year_str   = ', '.join(str(y) for y in years)
        prereq_str = ', '.join(prereqs) if prereqs else 'None'
 
        prompt = (
            f"You are a university course advisor.\n"
            f"Recommend exactly 10 courses for a Year {year_str} {dept} student "
            f"with the following profile:\n"
            f"  - Interests: {pref_str}\n"
            f"  - Preferred difficulty: {diff_str}\n"
            f"  - Courses already completed: {prereq_str}\n\n"
            f"Rules:\n"
            f"  1. Return ONLY a numbered list of 10 course names, one per line.\n"
            f"  2. Do NOT include descriptions, explanations, or extra text.\n"
            f"  3. Each line must be just the course name, e.g.:\n"
            f"     1. Artificial Intelligence\n"
            f"     2. Object-Oriented Programming\n"
            f"  4. Courses should be appropriate for the department and year.\n"
            f"  5. Avoid repeating courses the student already completed.\n"
        )
 
        completion = client.chat.completions.create(
            model="groq/compound",
            messages=[{"role": "user", "content": prompt}],
            stream=False,
        )
 
        raw_reply = completion.choices[0].message.content.strip()
        course_names = _parse_course_list(raw_reply)
 
        # ── Build response in the same shape as the logic endpoint ───────────
        # { status, total_found, data: [ { course_name, match_percentage,
        #   match_tier, details: { difficulty, prerequisite, preference,
        #                          year_of_study, department } } ] }
        #
        # For AI results we don't have a real match score, so we assign
        # a rank-based percentage: rank 1 → 100%, rank 2 → 90%, … rank 10 → 10%
        data_list = []
        for i, name in enumerate(course_names):
            rank        = i + 1
            match_pct   = round(100 - (rank - 1) * 10, 1)   # 100, 90, 80 … 10
            tier        = (
                "Tier 1 (100%)" if match_pct == 100 else
                "Tier 2 (75%)"  if match_pct >= 70  else
                "Tier 3 (50%)"  if match_pct >= 50  else
                "Low Match"
            )
            data_list.append({
                "course_name":      name,
                "match_percentage": match_pct,
                "match_tier":       tier,
                "details": {
                    "course_name":  name,
                    "difficulty":   difficulties[0] if difficulties else "Medium",
                    "prerequisite": None,          # AI doesn't know the exact prereq
                    "preference":   prefs[0] if prefs else "Programming",
                    "year_of_study": int(years[0]) if years else 4,
                    "department":   dept,
                },
            })
 
        response_body = _sanitize({
            "status":      "success",
            "total_found": len(data_list),
            "data":        data_list,
            # Legacy fields kept for any old consumers
            "preference_requested":   pref_str,
            "department_requested":   dept,
            "year_requested":         year_str,
            "difficulty_requested":   diff_str,
            "prerequisite_requested": prereq_str,
        })
 
        return JsonResponse(response_body)
 
    except Exception as e:
        return JsonResponse({"status": "error", "message": str(e)}, status=500)
