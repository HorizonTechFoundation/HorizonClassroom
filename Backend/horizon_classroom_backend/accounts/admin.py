from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.translation import gettext_lazy as _
from .models import User

@admin.register(User)
class UserAdmin(BaseUserAdmin):
    # Use register_number as the "username" field
    ordering = ('register_number',)
    list_display = ('register_number', 'is_staff', 'is_superuser', 'is_active')
    list_filter = ('is_staff', 'is_superuser', 'is_active')

    # Fields to display on the user detail page
    fieldsets = (
        (None, {'fields': ('register_number', 'name', 'department', 'batch', 'institute', 'password')}),
        (_('Permissions'), {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        (_('Important dates'), {'fields': ('last_login',)}),
    )

    # Fields shown on the create user page
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('register_number', 'name', 'department', 'batch', 'institute', 'password1', 'password2'),
        }),
    )

    search_fields = ('register_number',)
