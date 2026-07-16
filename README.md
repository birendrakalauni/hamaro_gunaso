# hamaro_gunaso

A new Flutter project.

# Hamaro Gunaso – Public Issue Reporting System

A modern Flutter-based Public Issue Reporting System that enables citizens to submit complaints, track their status, and receive transparent responses from administrators.

## Features

### User

* User Registration & Login
* Forgot Password
* Submit Complaint
* Upload Complaint Image (Cloudinary)
* Track Complaint Status
* View Complaint Details
* Search, Filter & Sort Complaints
* Profile Management

### Admin

* Manage All Complaints
* Search & Filter Complaints
* View Complaint Details
* Update Complaint Status
* Send Admin Response
* Delete Complaints
* Real-time Firestore Updates

## Tech Stack

* **Frontend:** Flutter, Dart
* **Backend:** Firebase Authentication, Cloud Firestore
* **Image Storage:** Cloudinary
* **State Management:** Provider
* **Packages:** image_picker, http, intl, uuid

## Getting Started

```bash
git clone https://github.com/birendrakalauni/hamaro_gunaso.git
cd hamaro_gunaso
flutter pub get
flutter run
```

## Firestore Collections

### users

* uid
* name
* email
* role
* createdAt

### complaints

* complaintId
* userId
* title
* category
* description
* location
* imageUrl
* status
* adminResponse
* responseDate
* updatedBy
* createdAt
* updatedAt

## Project Structure

```text
lib/
├── core/
├── models/
├── providers/
├── routes/
├── screens/
│   ├── admin/
│   ├── auth/
│   ├── home/
│   ├── splash/
│   └── user/
├── widgets/
└── main.dart
```

## Future Enhancements

* Push Notifications
* Email Notifications
* Complaint Analytics Dashboard
* Google Maps Integration
* PDF Report Generation
* AI-based Complaint Categorization

## Author

**Birendra Kalauni**

CS Student

GitHub: https://github.com/birendrakalauni

LinkedIn: https://www.linkedin.com/in/birendra-kalauni-297139261/

## License

This software project is developed for educational purposes. Feel free to use and modify it for learning and research.
