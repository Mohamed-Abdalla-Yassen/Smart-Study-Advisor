from django.urls import path
from . import views

urlpatterns = [
    # path('recommend/noAi/', views.get_recommendations),
    path('recommendPost/noAi/', views.get_recommendations_post),
    path('recommend/ai/', views.get_AI_recommendations),
    path('recommend/complex/noAi/', views.get_recommendations_complex),
]