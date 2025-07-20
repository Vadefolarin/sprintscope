# Firebase Setup for SprintScope

## 🔥 Firebase Configuration

To enable authentication in SprintScope, you need to set up Firebase and configure the app.

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `sprintscope`
4. Follow the setup wizard

### 2. Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password** authentication
5. Click **Save**

### 3. Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select a location close to your users
5. Click **Done**

### 4. Get Firebase Configuration

1. In Firebase Console, go to **Project settings** (gear icon)
2. Scroll down to **Your apps** section
3. Click **Add app** and select **Web**
4. Register app with name: `SprintScope Web`
5. Copy the Firebase configuration object

### 5. Update Web Configuration

Replace the placeholder values in `web/index.html`:

```javascript
const firebaseConfig = {
  apiKey: "YOUR_ACTUAL_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID",
  measurementId: "YOUR_MEASUREMENT_ID"
};
```

### 6. Security Rules (Optional)

For production, update Firestore security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 7. Test Authentication

1. Run the app: `flutter run -d chrome`
2. Try signing up with a new account
3. Try signing in with existing credentials
4. Check Firebase Console to see user data

## 🚀 Features Enabled

- ✅ **Email/Password Authentication**
- ✅ **User Registration**
- ✅ **User Login**
- ✅ **Password Reset**
- ✅ **User Profile Storage**
- ✅ **Authentication State Management**
- ✅ **Error Handling**

## 📱 User Data Structure

Users are stored in Firestore with the following structure:

```json
{
  "fullName": "John Doe",
  "email": "john@example.com",
  "createdAt": "2024-01-01T00:00:00Z",
  "lastLoginAt": "2024-01-01T00:00:00Z"
}
```

## 🔧 Troubleshooting

### Common Issues:

1. **"Firebase not initialized"**
   - Check if Firebase config is correct in `web/index.html`
   - Ensure Firebase project is created and configured

2. **"Permission denied"**
   - Check Firestore security rules
   - Ensure authentication is enabled

3. **"Invalid email format"**
   - Check email validation in the app
   - Ensure proper email format

### Support:

For Firebase-specific issues, refer to:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/) 