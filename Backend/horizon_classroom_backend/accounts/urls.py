from django.urls import path
from .views import StudentLoginView

urlpatterns = [
    path('students/login/', StudentLoginView.as_view(), name='student-login'),
]
