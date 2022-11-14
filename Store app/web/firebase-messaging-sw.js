importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyAMLk1-dj8g0qCqU3DkxLKHbrT0VhK5EeQ",
  authDomain: "e-food-9e6e3.firebaseapp.com",
  projectId: "e-food-9e6e3",
  storageBucket: "e-food-9e6e3.appspot.com",
  messagingSenderId: "410522356318",
  appId: "1:410522356318:web:c0983d7d2f5e3e933dc2cf",
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});