from django.db import models
# the Courses data is typically hardcoded in the prolog(.pl) file
# but i guess we may need Admin dynamic insertion for facts about courses in .pl file ( In any of two approaches
# (A: sending all student data as arguments in a query ,B: dynamic temporary insertion( end by restarting the server) for student facts before just quering with no arguments( give us ability to use the db to save student account data and reusing it) ))
#:- dynamic course/3. % marking this type of fact as dynamic Temporary( end by restarting the server) insertion
# prolog.assertz(f"course('cse412','LA', 2)")


class Course(models.Model):
    code = models.CharField(max_length=20, unique=True)
    title = models.CharField(max_length=200)
    department = models.CharField(max_length=50) # e.g., 'CCE'
    difficulty = models.IntegerField() # e.g., 1-5
    prerequisites = models.JSONField(default=list)

