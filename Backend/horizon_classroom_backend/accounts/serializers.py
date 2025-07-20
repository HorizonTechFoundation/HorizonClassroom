from rest_framework import serializers
from .models import User

class StudentLoginSerializer(serializers.Serializer):
    register_number = serializers.CharField()
    password = serializers.CharField(write_only=True)

class StudentLoginResponseSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField()
    register_number = serializers.CharField()
    department = serializers.CharField(allow_null=True, allow_blank=True, required=False)
    batch = serializers.CharField(allow_null=True, allow_blank=True, required=False)
    institute = serializers.CharField(allow_null=True, allow_blank=True, required=False)
    is_login = serializers.IntegerField()
    access_token = serializers.CharField()
    refresh_token = serializers.CharField()