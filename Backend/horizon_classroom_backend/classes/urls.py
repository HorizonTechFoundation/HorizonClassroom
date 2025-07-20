from django.urls import path
from .views import GetScheduledClasses, GetCurrentClass
from rest_framework_simplejwt.views import TokenRefreshView

urlpatterns = [
    path('students/scheduledclasses/', GetScheduledClasses.as_view(), name='get_scheduled_classes'),
    path('students/currentclass/', GetCurrentClass.as_view(), name='get_current_class'),
    path('students/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
