from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
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
        data = json.loads(request.body)
        student_name = data.get('student_name')
        interest = data.get('interest')

        recommendations = get_prolog_recommendation(student_name, interest , False)

        return JsonResponse({
            "status": "success",
            "recommendations": recommendations
        })



# @csrf_exempt
# def recommend_course_view(request):
#     if request.method == 'POST':
#         # Parse Input
#         data = json.loads(request.body)
#
#         # Dependency Injection (Manually here, or via a factory)
#         # You can easily swap this with GeminiAdvisorService()
#         advisor = PrologAdvisorService()
#
#         recommendations = advisor.get_recommendations(data)
#
#         return JsonResponse({
#             "status": "success",
#             "data": recommendations
#         })