from django.db import models
from django.conf import settings

class ScheduledClass(models.Model):
    STATUS_CHOICES = [
        ('not started', 'Not Started'),
        ('started', 'Started'),
        ('end', 'Ended'),
    ]

    students = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name='scheduled_classes', blank=True)

    institute = models.CharField(max_length=255)
    classname = models.CharField(max_length=255)
    timeStart = models.CharField(max_length=20)
    timeEnd = models.CharField(max_length=20)
    date = models.DateField()
    takenBy = models.CharField(max_length=255)
    venue = models.CharField(max_length=255)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='not started')

    def __str__(self):
        return f"{self.classname} on {self.date}"
