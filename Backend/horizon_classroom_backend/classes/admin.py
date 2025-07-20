from django.contrib import admin
from .models import ScheduledClass

@admin.register(ScheduledClass)
class ScheduledClassAdmin(admin.ModelAdmin):

    def enrolled_students(self, obj):
        return ", ".join([str(s.register_number) for s in obj.students.all()])
    enrolled_students.short_description = "Students"


    list_display = ('classname', 'date', 'timeStart', 'timeEnd', 'takenBy', 'venue', 'status', 'institute', 'enrolled_students')
    list_filter = ('date', 'status', 'institute')
    search_fields = ('classname', 'takenBy', 'venue', 'institute')
    filter_horizontal = ('students',)  # Enables a better UI for ManyToManyField
    ordering = ('-date', 'timeStart')
