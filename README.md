# Todo App

## Description
This is a simple and efficient Todo App built with Flutter. It allows users to manage their tasks with features like creating, updating, reading, and deleting tasks. The app supports email and password login and signup, and uses Firebase for data storage. Additionally, it includes local notifications to remind users of their tasks 10 minutes before the scheduled time.

## Features

- **Email and Password Login and Signup**
  - Users can register with their email and password.
  - Users can log in using their registered email and password.

- **Firebase for Data Storage**
  - All user data and tasks are securely stored in Firebase Firestore.
  - Real-time synchronization of data.

- **Local Notifications for Reminders**
  - The app uses Flutter Local Notifications to send reminders.
  - Reminders notify users 10 minutes before the scheduled task time.

- **Task Management**
  - Users can seamlessly create new tasks.
  - Users can update existing tasks.
  - Users can delete tasks.
  - Users can read and manage their tasks effortlessly.

## Installation

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase Account: [Create Firebase Project](https://firebase.google.com/)

### Steps

1. **Clone the repository**

```bash
git clone https://github.com/Antony-Maxwell/ToDo-Firebase.git
cd todo_app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure Firebase**

- Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
- Add an Android/iOS app to your Firebase project.
- Follow the instructions to download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) file and place it in the appropriate directory in your Flutter project.

4. **Run the app**

```bash
flutter run
```

## Usage

1. **Login/Signup**
   - Open the app.
   - Sign up using your email and password, or log in if you already have an account.

2. **Manage Tasks**
   - Create new tasks by tapping the 'Add Task' button.
   - Update existing tasks by tapping on the task and modifying the details.
   - Delete tasks by swiping left or right on the task.
   - View all your tasks in a neatly organized list.

3. **Reminders**
   - Set a date and time for your tasks.
   - Receive a notification 10 minutes before the scheduled time to remind you of your task.

## Contributing

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch`
3. Make your changes and commit them: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature-branch`
5. Submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
