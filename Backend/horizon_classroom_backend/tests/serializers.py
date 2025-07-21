from rest_framework import serializers
from .models import ClassTest

class ClassTestSerializer(serializers.ModelSerializer):
    resultdata = serializers.SerializerMethodField()

    class Meta:
        model = ClassTest
        fields = ['classid', 'testdata', 'resultdata']

    def get_resultdata(self, obj):
        return {
            "position1": {
                "student": obj.position1_student.id if obj.position1_student else None,
                "mark": obj.position1_mark
            },
            "position2": {
                "student": obj.position2_student.id if obj.position2_student else None,
                "mark": obj.position2_mark
            },
            "position3": {
                "student": obj.position3_student.id if obj.position3_student else None,
                "mark": obj.position3_mark
            }
        }
