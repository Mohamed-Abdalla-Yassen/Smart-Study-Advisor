from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json
from .services import get_prolog_recommendation
from .Services.advisor_prolog import PrologAdvisorService
from .Services.advisor_ai import GeminiAdvisorService

# Create your views here.
from django.http import JsonResponse

def hello(request):
    return JsonResponse({"message": "hello flutter"})

@csrf_exempt
def recommend_course(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        student_name = data.get('student_name')
        interest = data.get('interest')

        recommendations = get_prolog_recommendation(student_name, interest , True)

        return JsonResponse({
            "status": "success",
            "recommendations": recommendations
        })
@csrf_exempt
def recommend_a(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            advisor = GeminiAdvisorService()
            recommendations = advisor.get_recommendations(data)
            return JsonResponse({
                "status": "success",
                "source": "gemini-2.0-flash",
            "recommendations": recommendations
        })
        except Exception as e:
            return JsonResponse({"status": "error", "message": str(e)}, status=400)

    return JsonResponse({"status": "error", "message": "Invalid request method"}, status=405)   