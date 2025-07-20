from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import StudentLoginSerializer, StudentLoginResponseSerializer
from .models import User

class StudentLoginView(APIView):
    authentication_classes = []  # No auth needed to login
    permission_classes = []

    def post(self, request):
        serializer = StudentLoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        register_number = serializer.validated_data['register_number']
        password = serializer.validated_data['password']

        # Use authenticate with the right kwarg: `username` instead of `register_number`
        # because Django's authenticate expects `username` by default.
        user = authenticate(request, username=register_number, password=password)

        if user is None or user.role != 'student':
            return Response({"detail": "Invalid credentials or not a student"}, status=status.HTTP_401_UNAUTHORIZED)

        print(f"User ID: {user.id} (type: {type(user.id)})")

        refresh = RefreshToken.for_user(user)

        response_data = {
            "id": user.id,
            "name": user.name,
            "register_number": user.register_number,
            "department": user.department,
            "batch": user.batch,
            "institute": user.institute,
            "is_login": 1,
            "access_token": str(refresh.access_token),
            "refresh_token": str(refresh)
        }

        response_serializer = StudentLoginResponseSerializer(response_data)
        return Response(response_serializer.data)

