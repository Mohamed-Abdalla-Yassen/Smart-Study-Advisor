from django.shortcuts import render

from django.http import HttpResponse
# Create your views here.

def say_hello(request):
    # Pull data from the database (if needed)
    # Send data to the template (if needed)
    return HttpResponse("Hello, World!")

def template_view(request):
    return render(request, 'playground/template.html')