#!/bin/bash

echo "🚀 Deploying SprintScope to Firebase Hosting..."

# Build the Flutter web app
echo "📦 Building Flutter web app..."
flutter build web --release

# Deploy to Firebase Hosting
echo "🔥 Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo "✅ Deployment complete!"
echo "🌐 Your app is live at: https://sprintscope-85e72.web.app"
echo "📊 Firebase Console: https://console.firebase.google.com/project/sprintscope-85e72/overview" 