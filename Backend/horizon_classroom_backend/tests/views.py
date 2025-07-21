from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from classes.models import ScheduledClass
from .models import ClassTest
from .serializers import ClassTestSerializer

# GET TEST FOR CLASSROOM
class GetTestByIdView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, id):
        try:
            classroom = ScheduledClass.objects.get(id=id, status='started')
            class_test = ClassTest.objects.get(classid=classroom)
            serializer = ClassTestSerializer(class_test)
            return Response(serializer.data)
        except ScheduledClass.DoesNotExist:
            return Response({"error": "Class not found or not started"}, status=404)
        except ClassTest.DoesNotExist:
            return Response({"error": "Test not found"}, status=404)

# ADD MARK TO RESULTS
class AddMarkView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        class_id = request.data.get('classid')
        marks = request.data.get('markscored')
        user = request.user

        try:
            class_test = ClassTest.objects.get(classid__id=class_id)
        except ClassTest.DoesNotExist:
            return Response({"error": "Class test not found"}, status=404)

        # Ranking logic
        positions = [
            ('position1_mark', 'position1_student'),
            ('position2_mark', 'position2_student'),
            ('position3_mark', 'position3_student')
        ]

        for i, (mark_field, student_field) in enumerate(positions):
            if marks > getattr(class_test, mark_field):
                # Shift lower positions down
                for j in range(2, i, -1):
                    setattr(class_test, positions[j][0], getattr(class_test, positions[j-1][0]))
                    setattr(class_test, positions[j][1], getattr(class_test, positions[j-1][1]))

                setattr(class_test, mark_field, marks)
                setattr(class_test, student_field, user)
                class_test.save()
                return Response({"message": f"Mark added at position {i+1}"}, status=200)

        return Response({"message": "Mark not high enough to enter top 3"}, status=200)
