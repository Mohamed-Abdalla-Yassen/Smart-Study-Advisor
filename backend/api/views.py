from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
import json
from .services import get_prolog_recommendation

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

        recommendations = get_prolog_recommendation(student_name, interest)

        return JsonResponse({
            "status": "success",
            "recommendations": recommendations
        })