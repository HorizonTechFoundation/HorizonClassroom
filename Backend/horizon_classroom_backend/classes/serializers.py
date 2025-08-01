from rest_framework import serializers
from .models import ScheduledClass

class ScheduledClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = ScheduledClass
        fields = ['id', 'classname', 'timeStart', 'timeEnd', 'date', 'takenBy', 'venue', 'status']
