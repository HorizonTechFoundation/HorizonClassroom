from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from datetime import date, datetime
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

        # Filter classes for today with status 'started'
        classes = ScheduledClass.objects.filter(
            students=user,
            institute=user.institute,
            date=today,
            status='started'
        )

        if not classes.exists():
            return Response({}, status=status.HTTP_200_OK)

        # Convert timeStart to actual time object for sorting
        def parse_time(cls):
            try:
                return datetime.strptime(cls.timeStart, "%I:%M %p").time()
            except ValueError:
                return datetime.max.time()  # Push invalid formats to the end

        # Sort by parsed time and get the earliest one
        earliest_class = sorted(classes, key=parse_time)[0]

        serializer = ScheduledClassSerializer(earliest_class)
        return Response(serializer.data, status=status.HTTP_200_OK)
