from django.urls import path
from . import views

urlpatterns = [
    path('recommend/noAi/', views.get_recommendations),
]