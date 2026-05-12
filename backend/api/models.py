from django.db import models

# Create your models here.

class Course(models.Model):
    code = models.CharField(max_length=10, unique=True)
    title = models.CharField(max_length=100)
    difficulty = models.IntegerField()

    def __str__(self):
        return f"{self.code}: {self.title}"

class StudentProfile(models.Model):
    name = models.CharField(max_length=100)
    completed_courses = models.ManyToManyField(Course, blank=True)
    interest_area = models.CharField(max_length=50)