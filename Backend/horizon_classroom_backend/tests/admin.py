from django.contrib import admin
from .models import ClassTest

@admin.register(ClassTest)
class ClassTestAdmin(admin.ModelAdmin):
    list_display = ('classid', 'position1_student', 'position1_mark', 'position2_student', 'position2_mark', 'position3_student', 'position3_mark')
    readonly_fields = ('position1_student', 'position1_mark', 'position2_student', 'position2_mark', 'position3_student', 'position3_mark', 'formatted_testdata')
    
    # Show testdata JSON clearly
    def formatted_testdata(self, obj):
        import json
        return json.dumps(obj.testdata, indent=2)
    formatted_testdata.short_description = 'Test Data (Formatted)'
    
    fields = (
        'classid',
        'testdata',
        'formatted_testdata',
        'position1_student', 'position1_mark',
        'position2_student', 'position2_mark',
        'position3_student', 'position3_mark'
    )
