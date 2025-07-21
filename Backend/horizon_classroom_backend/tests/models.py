from django.db import models
from django.contrib.auth import get_user_model
from classes.models import ScheduledClass

User = get_user_model()

class ClassTest(models.Model):
    classid = models.OneToOneField(ScheduledClass, on_delete=models.CASCADE, related_name='test')

    testdata = models.JSONField(default=list)  # List of dicts with question, options, correctAnswer

    # Result Data
    position1_student = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL, related_name='position1_tests')
    position1_mark = models.IntegerField(default=0)

    position2_student = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL, related_name='position2_tests')
    position2_mark = models.IntegerField(default=0)

    position3_student = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL, related_name='position3_tests')
    position3_mark = models.IntegerField(default=0)
