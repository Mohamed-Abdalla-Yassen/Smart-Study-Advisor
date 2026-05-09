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
                
                # Regex to find: course('Course Name', 'Department', ...
                pattern = r"course\('([^']+)',\s*'([^']+)'"
                matches = re.findall(pattern, content)
                print(f"[DEBUG] Found {len(matches)} course matches in Prolog file")

                for course_name, dept in matches:
                    if dept.lower() == department.lower():
                        courses.append(course_name)

                print(f"[DEBUG] Filtered to {len(courses)} courses for department: {department}")
                
        except Exception as e:
            print(f"[ERROR] Error reading Prolog file: {type(e).__name__}: {e}")

            import traceback
            traceback.print_exc()

        return ", ".join(courses)


    def get_recommendations(self, data: dict) -> list:
        try:
            student_name = data.get("student_name", "Student")
            interest = data.get('interest', 'AI')
            department = data.get('department', 'CSE')

            print(f"[DEBUG] Processing recommendation for {student_name}, interest: {interest}, dept: {department}")

            valid_courses = self._get_courses_for_department(department)

            if not valid_courses:
                print(f"[WARNING] No courses found for department: {department}")
                return ["No courses available for this department"]

            prompt = (
           f"You are a genius Study Advisor. The student {student_name} is in the {department} department "
            f"and is interested in {interest}.\n\n"
            f"Here is the STRICT list of available courses for the {department} department:\n"
            f"[{valid_courses}]\n\n"
            "RULES:\n"
            "1. Suggest exactly 1 course that suit their interests.\n"
            "2. You MUST ONLY choose courses from the strict list provided above. Do NOT invent new courses.\n"
            "3. Provide ONLY a comma-separated list of the course names. Nothing else."
            )
            print(f"[DEBUG] Sending prompt to Gemini API...")    
            response = self.client.models.generate_content(
                model="models/gemini-2.5-flash",
                contents=[{"text": prompt}],
            )
            print(f"[DEBUG] Received response from Gemini API")
            print(f"[DEBUG] Raw response content: {response.text}")
            recommendations_list = [item.strip() for item in response.text.split(',')]

            return recommendations_list
        except Exception as e:
            print(f"[ERROR] AI error: {type(e).__name__}: {e}")
            import traceback
            traceback.print_exc()
            return ["error fetching AI recommendations"]

