from django.urls import path
from .views import hello, recommend_course, recommend_a

urlpatterns = [
    path('hello/', hello),
    path('recommend/',recommend_course),
    path('recommend_/',recommend_a)

]
