<p align="start">
  <img src="https://github.com/HorizonTechFoundation/HorizonClassroom/blob/main/Utils/horizonclassroombanner.png" alt="Horizon Classroom Banner" width="80%">
</p>

# HORIZON CLASSROOM

[![Flutter](https://img.shields.io/badge/Built%20With-Flutter-blue?logo=flutter)](https://flutter.dev)
[![Django](https://img.shields.io/badge/Backend-Django-darkgreen?logo=django)](https://www.djangoproject.com/)


**An innovative classroom engagement app by Horizon Tech Foundation**  
**Built with Flutter (Frontend) + Django (Backend)**

---

## 🎯 Purpose

**Horizon Classroom** is a mobile-first solution designed to minimize distractions during class or test hours. By enforcing in-app presence, the app automatically tracks student attention. If a student closes or minimizes the app, they are instantly **marked as absent**—encouraging full participation and minimizing mobile misuse.

### Project Info

| Name              | Horizon Classroom                          |
|-------------------|---------------------------------------------|
| Company           | Horizon Tech Foundation                    |
| Developed By      | Kishor T                                   |
| Frontend          | Flutter + Dart                             |
| Backend           | Django (REST Framework)                    |
| Monetization      | Google AdMob (In-App Ads)                  |
| Platforms         | Android, iOS                               |
| Use Case          | Prevent phone usage during class/test time |


---

## 🛠️ Tech Stack

- **Frontend:** Flutter + Dart  
- **Backend:** Django REST Framework  
- **Database:** SQLite/PostgreSQL  
- **Authentication:** Token-based Auth  
- **Deployment:** Firebase (for app) / Heroku or Render (for backend)  
- **Monetization:** Google AdMob (In-App Ads)

---

## 🔑 Key Features

- **App Lock & Attendance**  
  Automatically marks students **absent** if they close or minimize the app during class.

- **Real-time Session Tracking**  
  Faculty can monitor ongoing sessions and see live attendance data.

- **Role-based Access**  
  Different views for **students** and **faculty**.

- **Secure APIs**  
  Django backend ensures safe communication and data validation.

- **Ad Revenue Model**  
  Displays in-app ads during sessions for monetization.

---

## 📸 Screenshots

| Home Screen | Faculty Session | Student Lock View |
|-------------|------------------|-------------------|
| *Coming Soon* | *Coming Soon*   | *Coming Soon*     |

---

## 🚀 Getting Started

### 📦 Prerequisites

- Flutter SDK
- Python 3.x
- Django
- Node.js (for optional admin dashboard)
- Postman (for API testing)

### 🧪 Local Setup

#### Flutter App

```bash
git clone https://github.com/HorizonTechFoundation/HorizonClassroom.git
cd HorizonClassroom/Frontend/horizon_classroom
flutter pub get
flutter run
```
#### Django Backend
```bash
cd HorizonClassroom/Backend/horizon_classroom_backend
python -m venv env
source env/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## Future Improvements

- Face Detection or Facial Presence Check
- Geo-fencing for Campus Validation
- AI/ML-based Student Behavior Analysis
- Analytics Dashboard for Admin

## Author
**Kishor T**</br>
Horizon Tech Foundation</br>
kishor404@outlook.in

## Support
If you find this project useful, give it a ⭐️ and share it with your peers! </br>
Pull requests and suggestions are welcome.
