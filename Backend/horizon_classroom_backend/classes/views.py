from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from datetime import date
from .models import ScheduledClass
from .serializers import ScheduledClassSerializer

class GetScheduledClasses(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        today = date.today()

        scheduled_classes = ScheduledClass.objects.filter(
            students=user,
            institute=user.institute,
            date=today,
            status= 'not started'
        )

        print(user.institute, today, user)

        serializer = ScheduledClassSerializer(scheduled_classes, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class GetCurrentClass(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        today = date.today()

        current_class = ScheduledClass.objects.filter(
            students=user,
            institute=user.institute,
            date=today,
            status='started'
        ).first()

        if current_class:
            serializer = ScheduledClassSerializer(current_class)
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response({}, status=status.HTTP_200_OK)
