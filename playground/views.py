from django.shortcuts import render

from django.http import HttpResponse, JsonResponse

from pyswip import Prolog
import os
from django.conf import settings

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
    user_pref = request.GET.get('pref', 'Programming')
    user_dept = request.GET.get('dept', 'CSE')

    # 2. Construct the Prolog query as a string
    # E.g., "recommend('Software', 'CSE', Course)"
    query = f"recommend('{user_pref}', '{user_dept}', Course)"

    recommended_courses = []

    try:
        # 3. Query Prolog using PySwip
        # prolog.query returns a generator of dictionaries
        for result in prolog.query(query):
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
            "recommendations": recommended_courses
        })

    except Exception as e:
        return JsonResponse({"status": "error", "message": str(e)}, status=500)