from django.urls import path
from .views import hello , recommend_course


urlpatterns = [
    path('hello/', hello),
    path('recommend/',recommend_course)
]
