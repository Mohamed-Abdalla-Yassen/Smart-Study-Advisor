import json

from .base import BaseAdvisorService
import os
from google import genai
from dotenv import load_dotenv
import re

load_dotenv()


class GeminiAdvisorService(BaseAdvisorService):
    def __init__(self):
        api_key = os.getenv("GEMINI_API_KEY")
        if not api_key:
            raise ValueError("GEMINI_API_KEY not found in environment variables.")
        
        self.client = genai.Client(api_key=api_key)

    def _get_courses_for_department(self, department: str) -> str:
        """
        Reads the Prolog file and extracts available courses for a specific department.
        Demonstrates cross-paradigm data sharing!
        """
        courses = []
        try:
            current_dir = os.path.dirname(os.path.abspath(__file__))
            api_dir = os.path.dirname(current_dir)
            backend_dir = os.path.dirname(api_dir)
            root_dir = os.path.dirname(backend_dir)

            prolog_file = os.path.join(root_dir, "advice.pl")

            print(f"[DEBUG] Looking for Prolog file at: {prolog_file}")

            if not os.path.exists(prolog_file):
                print(f"[ERROR] Prolog file not found at: {prolog_file}")
                return ""

            with open(prolog_file, "r" , encoding="utf-8") as file:
                content = file.read()

                print(f"[DEBUG] Prolog file loaded, length: {len(content)} chars")
                
                #dormat : course name department , difficulty , year
                pattern = r"course\(\s*'([^']+)'\s*,\s*'([^']+)'\s*,\s*'([^']+)'\s*,\s*(\d+)\s*\)"
                matches = re.findall(pattern, content)
                print(f"[DEBUG] Found {len(matches)} course matches in Prolog file")

                for course_name, dept, difficulty, year in matches:
                    if dept.lower() == department.lower():
                        courses.append(f"'{course_name}' (Year: {year}, Difficulty: {difficulty})")

                print(f"[DEBUG] Filtered to {len(courses)} courses for department: {department}")
                
        except Exception as e:
            print(f"[ERROR] Error reading Prolog file: {type(e).__name__}: {e}")
        
        return " | ".join(courses)

    def get_recommendations(self, data: dict) -> list:
        try:
            department = data.get('dept', 'CSE')
            prefs = data.get('prefs', [])
            difficulties = data.get('difficulties', [])
            years = data.get('years', [])
            completed_courses = data.get('prereqs', [])

            #convert lists to readable strings

            prefs_str = ", ".join(prefs) if prefs else "Any"
            difficulties_str = ", ".join(difficulties) if difficulties else "Any"
            years_str = ", ".join(str(y) for y in years) if years else "Any"
            completed_str = ", ".join(completed_courses) if completed_courses else "None"

            print(f"[DEBUG] AI Request - Dept: {department}, Prefs: {prefs_str}, Diff: {difficulties_str}")
            valid_courses = self._get_courses_for_department(department)

            if not valid_courses:
                print(f"[WARNING] No courses found for department: {department}")
                return ["No courses available for this department"]

            prompt = f"""You are a genius AI Study Advisor. Evaluate courses based on this student profile:
--- STUDENT PROFILE ---
Department: {department}
Preferred Subjects: {prefs_str}
Allowed Difficulties: {difficulties_str}
Allowed Years of Study: {years_str}
Completed Courses (DO NOT RECOMMEND THESE): {completed_str}

--- AVAILABLE COURSES (WITH STATS) ---
[{valid_courses}]

--- RULES & TIERS ---
1. Pick exactly 1 course from the Available Courses list that best fits the profile.
2. DO NOT pick any course listed in Completed Courses.
3. Evaluate and classify the best course using these strict Tiers (Tier 1 is best):
   - Tier 1 (100.0%): Course Year is in Allowed Years AND Difficulty is in Allowed Difficulties AND Preference is in Preferred Subjects.
   - Tier 2 (70.0%): Course Year is in Allowed Years AND Difficulty is in Allowed Difficulties (Preferences don't match).
   - Tier 3 (50.0%): Course Year is in Allowed Years (Neither Difficulty nor Preferences match).
   - Tier 4 (20.0%): Course Year is NOT in Allowed Years AND Difficulty is NOT in Allowed Difficulties AND Subject Tag does NOT match Preferred Subjects
4. You MUST return your answer as a raw JSON array containing exactly one object. 
5. Do NOT use markdown formatting. Just output the raw JSON text.
6. The JSON object MUST strictly follow this schema, filling in the correct calculated Tier and Percentage:

[
  {{
    "course_name": "<Exact Course Name>",
    "match_percentage": <100.0, 70.0, 50.0, or 20.0 based on the matched Tier>,
    "match_tier": "<Tier 1 (100%), Tier 2 (70%), Tier 3 (50%), or Tier 4 (20%)>",
    "details": {{
      "course_name": "<Exact Course Name>",
      "difficulty": "<Course Difficulty>",
      "prerequisite": "NaN",
      "preference": "<The matched preference, or 'General' if Tier 2/3/4>",
      "year_of_study": <Course Year as an integer>,
      "department": "{department}"
    }}
  }}
]
"""
            print(f"[DEBUG] Sending prompt to Gemini API...")    
            response = self.client.models.generate_content(
                model="models/gemini-2.5-flash",
                contents=[{"text": prompt}],
            )

            print(f"[DEBUG] Received response from Gemini API")

            clean_json = response.text.strip()
            if clean_json.startswith("```json"):
                clean_json = clean_json[7:]
            if clean_json.endswith("```"):
                clean_json = clean_json[:-3]
            clean_json = clean_json.strip()

            print(f"[DEBUG] Raw response content: {response.text}")
            recommendations_list = json.loads(clean_json)

            return recommendations_list
        except Exception as e:
            print(f"[ERROR] AI error: {type(e).__name__}: {e}")
            import traceback
            traceback.print_exc()
            # Return an array of objects matching the frontend schema even on error to prevent crashes
            return [{
                "course_name": "Error fetching AI recommendations",
                "match_percentage": 0.0,
                "match_tier": "Error",
                "details": {
                    "course_name": "Error", "difficulty": "Unknown", "prerequisite": "NaN", 
                    "preference": "Unknown", "year_of_study": 0, "department": department
                }
            }]