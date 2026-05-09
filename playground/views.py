import json

from django.shortcuts import render

from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt

from pyswip import Prolog
import os
from django.conf import settings


from groq import Groq
from dotenv import load_dotenv

# Initialize Prolog once when the server starts
prolog = Prolog()

# Construct the absolute path to your logic.pl file
# Adjust this path based on exactly where you put the file!
prolog_file_path = os.path.join(settings.BASE_DIR, 'playground', 'prolog', 'logic.pl')

# Load the Prolog file into the PySwip engine
prolog.consult(prolog_file_path.replace('\\', '/')) 

def get_recommendations(request):
    """
    This API endpoint receives preferences and asks Prolog for courses.
    Example URL: /api/recommend?pref=Software&dept=CSE
    """
    # 1. Get user inputs from the URL parameters (or default to something)
    difficulty = request.GET.get('difficulty', 'Medium')
    prereq = request.GET.get('prereq', 'nan')
    user_pref = request.GET.get('pref', 'Programming')
    user_year = request.GET.get('year', '4')
    user_dept = request.GET.get('dept', 'CSE')

    # 2. Construct the Prolog query as a string
    # E.g., "recommend('Software', 'CSE', Course)"
    query = f"recommend('{difficulty}', '{prereq}', '{user_pref}', {user_year}, '{user_dept}', Course)"

    recommended_courses = []

    try:
        # 3. Query Prolog using PySwip
        # prolog.query returns a generator of dictionaries
        for result in prolog.query(query):
            #! print("Prolog result:", result)  # Debug: print the raw Prolog result
            # Extract the 'Course' variable from the Prolog result
            course_name = result["Course"]
            
            # If the course is returned as bytes (common in PySwip), decode it
            if isinstance(course_name, bytes):
                course_name = course_name.decode('utf-8')
                
            if course_name not in recommended_courses:
                recommended_courses.append(course_name)

        # 4. Return the results as JSON to your Mobile App
        return JsonResponse({
            "status": "success",
            "preference_requested": user_pref,
            "department_requested": user_dept,
            "recommendations": recommended_courses,
            "year_requested": user_year,
            "difficulty_requested": difficulty,
            "prerequisite_requested": prereq
        })

    except Exception as e:
        return JsonResponse({"status": "error", "message": str(e)}, status=500)
    
@csrf_exempt
def get_recommendations_post(request):
    """
    This API endpoint receives preferences via POST and asks Prolog for courses.
    Example POST body: {"pref": "Software", "dept": "CSE"}
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            difficulty = data.get('difficulty', 'Medium')
            prereq = data.get('prereq', 'nan')
            user_pref = data.get('pref', 'Programming')
            user_year = data.get('year', '4')
            user_dept = data.get('dept', 'CSE')

            query = f"recommend('{difficulty}', '{prereq}', '{user_pref}', {user_year}, '{user_dept}', Course)"
            recommended_courses = []

            for result in prolog.query(query):
                course_name = result["Course"]
                if isinstance(course_name, bytes):
                    course_name = course_name.decode('utf-8')
                if course_name not in recommended_courses:
                    recommended_courses.append(course_name)

            return JsonResponse({
                "status": "success",
                "preference_requested": user_pref,
                "department_requested": user_dept,
                "recommendations": recommended_courses,
                "year_requested": user_year,
                "difficulty_requested": difficulty,
                "prerequisite_requested": prereq
            })

        except Exception as e:
            return JsonResponse({"status": "error", "message": str(e)}, status=500)
    else:
        return JsonResponse({"status": "error", "message": "Only POST method allowed"}, status=405)
    

load_dotenv()
my_api_key = os.getenv("GROQ_API_KEY")
client = Groq(api_key=my_api_key)

# print("Groq API Key loaded:", "Yes" if my_api_key else "No")

@csrf_exempt
def get_AI_recommendations(request):
    try:
        if request.method == 'POST':
            data = json.loads(request.body)
            difficulty = data.get('difficulty', 'Medium')
            prereq = data.get('prereq', 'nan')
            user_pref = data.get('pref', 'Programming')
            user_year = data.get('year', '4')
            user_dept = data.get('dept', 'CSE')

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
                        "status": "success",
                        "preference_requested": user_pref,
                        "department_requested": user_dept,
                        "recommendations": [recommended_course],
                        "year_requested": user_year,
                        "difficulty_requested": difficulty,
                        "prerequisite_requested": prereq
                    })
    
    except Exception as e:
        return JsonResponse({"status": "error", "message": str(e)}, status=500)
    
