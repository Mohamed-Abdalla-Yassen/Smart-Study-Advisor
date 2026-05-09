from django.urls import path
from .views import hello, recommend_course, recommend_a
from . import views

urlpatterns = [
    path('hello/', hello),
    path('recommend/',recommend_course),
    path('recommend/ai/', views.recommend_a, name='recommend_a'),

]
