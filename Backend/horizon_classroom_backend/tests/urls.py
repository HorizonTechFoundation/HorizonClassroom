from django.urls import path
from .views import GetTestByIdView, AddMarkView

urlpatterns = [
    path('students/gettestbyid/<int:id>/', GetTestByIdView.as_view()),
    path('students/addmark/', AddMarkView.as_view()),
]
