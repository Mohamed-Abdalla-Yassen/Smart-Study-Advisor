import json
import os
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


# ─────────────────────────────────────────────
#  MAIN TIERED ENDPOINT
# ─────────────────────────────────────────────

@csrf_exempt
def get_recommendations_tiered(request):
    """
    POST body:
    {
        "dept":         "CSE",
        "difficulties": ["Easy", "Medium"],
        "prefs":        ["Programming", "AI", "Software"],
        "years":        ["2", "3", "4"],
        "prereqs":      ["Mathematics 1 (Calculus)", "Physics 1 (Mechanics)"]
    }

    Algorithm
    ─────────
    1. Ask Prolog for every course whose Department matches.
    2. Cross-reference each result with the Excel KB.
    3. Score each course on the 4 optional parameters
       (difficulty, preference, year, prerequisite).
       Department is the mandatory baseline — it is already enforced by
       the Prolog query and is not counted in the percentage.
    4. Sort descending by percentage; deduplicate.
    5. Attach tier label and full course details; return JSON.

    Matching rules per parameter
    ────────────────────────────
    • difficulty  – course difficulty is in user's selected difficulties list
    • preference  – course preference tag is in user's interests list
    • year        – course year_of_study matches one of the user's years
    • prerequisite– course prereq keyword appears inside a user prereq
                    string, OR the course has no prerequisite
    """
    if request.method != 'POST':
        return JsonResponse({"error": "POST only"}, status=405)

    try:
        data       = json.loads(request.body)
        dept       = data.get('dept', '').strip()
        prefs      = data.get('prefs', [])
        diffs      = data.get('difficulties', [])
        years      = [str(y) for y in data.get('years', [])]
        prereqs    = data.get('prereqs', [])

        if not dept:
            return JsonResponse({"error": "dept is required"}, status=400)

        # ── Step 1: Prolog fetches all courses for this department ──────
        candidate_names = _query_prolog_by_dept(dept)

        if not candidate_names:
            return JsonResponse({
                "status": "success",
                "dept": dept,
                "total_found": 0,
                "tiers": {"tier1": [], "tier2": [], "tier3": [], "tier4": []},
                "all_sorted": []
            })

        # ── Step 2 & 3: Score every candidate against the Excel KB ──────
        results = []
        seen    = set()

        for course_name in candidate_names:
            if course_name in seen:
                continue
            seen.add(course_name)

            kb_rows = df_kb[df_kb['course_name'] == course_name]
            if kb_rows.empty:
                continue

            row = kb_rows.iloc[0]

            diff_ok = row['difficulty'] in diffs
            pref_ok = row['preference'] in prefs
            year_ok = str(int(row['year_of_study'])) in years
            pre_ok  = _prereq_match(row['prerequisite'], prereqs)

            matched = sum([diff_ok, pref_ok, year_ok, pre_ok])

            result = _build_course_result(course_name, matched, 4, row)
            result["param_breakdown"] = {
                "difficulty_match":   diff_ok,
                "preference_match":   pref_ok,
                "year_match":         year_ok,
                "prerequisite_match": pre_ok,
            }
            results.append(result)

        # ── Step 4: Sort descending by match percentage ─────────────────
        results.sort(key=lambda x: x['match_percentage'], reverse=True)

        # ── Step 5: Group into tiers ────────────────────────────────────
        tiers = {"tier1": [], "tier2": [], "tier3": [], "tier4": []}
        for r in results:
            pct = r['match_percentage']
            if pct == 100:
                tiers["tier1"].append(r)
            elif pct >= 75:
                tiers["tier2"].append(r)
            elif pct >= 50:
                tiers["tier3"].append(r)
            else:
                tiers["tier4"].append(r)

        return JsonResponse({
            "status":      "success",
            "dept":        dept,
            "total_found": len(results),
            "tier_counts": {
                "tier1_perfect":  len(tiers["tier1"]),
                "tier2_strong":   len(tiers["tier2"]),
                "tier3_partial":  len(tiers["tier3"]),
                "tier4_low":      len(tiers["tier4"]),
            },
            "tiers":       tiers,
            "all_sorted":  results,
        })

    except Exception as e:
        return JsonResponse({"status": "error", "message": str(e)}, status=500)


# ─────────
# ENDPOINTS
# ─────────

@csrf_exempt
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
        if request.method == 'POST':
            data       = json.loads(request.body)
            difficulty = data.get('difficulty', 'Medium')
            prereq     = data.get('prereq', 'nan')
            user_pref  = data.get('pref', 'Programming')
            user_year  = data.get('year', '4')
            user_dept  = data.get('dept', 'CSE')

            prompt = (
                f"As an advisor, recommend a course for a Year {user_year} {user_dept} student "
                f"who likes {user_pref} and wants {difficulty} difficulty. "
                f"Give only the course name."
            )
            completion = client.chat.completions.create(
                model="groq/compound",
                messages=[{"role": "user", "content": prompt}],
                stream=False
            )
            recommended_course = completion.choices[0].message.content.strip() + " (AI Recommendation) FROM Django"

            return JsonResponse({
                "status":                 "success",
                "preference_requested":   user_pref,
                "department_requested":   user_dept,
                "recommendations":        [recommended_course],
                "year_requested":         user_year,
                "difficulty_requested":   difficulty,
                "prerequisite_requested": prereq
            })
    except Exception as e:
        return JsonResponse({"status": "error", "message": str(e)}, status=500)