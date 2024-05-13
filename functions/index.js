const { onCall } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const { plantCollection, userCollection } = require("./collections");
const functions = require("firebase-functions");
const { error } = require("firebase-functions/logger");
const { Storage } = require("@google-cloud/storage");
var serviceAccount = require("./project2-42954-firebase-adminsdk-ro0oz-ce5467fa44.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const storage = new Storage();

exports.saveUserDataOnSignIn = functions.auth.user().onCreate(async (user) => {
  try {
    const userData = {
      name: user.displayName || "Анонім",
      image: user.photoURL || null,
      email: user.email || null,
    };
    return await admin
      .firestore()
      .collection(userCollection)
      .doc(user.uid)
      .set(userData);
  } catch (e) {
    const error = e.message;
    return { error: error };
  }
});

exports.updateUserImage = functions.storage
  .object()
  .onFinalize(async (object) => {
    const filePath = object.name;
    const userId = filePath.split("/")[1];
    const fileBucket = object.bucket;
    const bucket = storage.bucket(fileBucket);

    try {
      const file = bucket.file(filePath);
      const fileUrl = await file.getSignedUrl({
        action: "read",
        expires: "03-16-2025",
      });
      console.log(fileUrl);

      const userRef = admin.firestore().collection("users").doc(userId);
      await userRef.update({
        image: fileUrl[0],
      });
      console.log(`Image URL updated for user ${userId}`);
    } catch (error) {
      console.error(`Error updating image URL for user ${userId}:`, error);
    }
  });

exports.updateUserImage = functions.storage
  .object()
  .onFinalize(async (object) => {
    const filePath = object.name;
    const directory = filePath.split("/")[0];
    const userId = filePath.split("/")[1];
    const fileBucket = object.bucket;
    const bucket = storage.bucket(fileBucket);
    if (directory == userDirectory) {
      try {
        const file = bucket.file(filePath);
        const fileUrl = await file.getSignedUrl({
          action: "read",
          expires: "03-16-2025",
        });
        console.log(fileUrl);

        const userRef = admin.firestore().collection("users").doc(userId);
        await userRef.update({
          image: fileUrl[0],
        });
        console.log(`Image URL updated for user ${userId}`);
      } catch (error) {
        console.error(`Error updating image URL for user ${userId}:`, error);
      }
    }
  });

exports.addPlantPhotosOrVideos = functions.storage
  .object()
  .onFinalize(async (object) => {
    const filePath = object.name;
    const directory = filePath.split("/")[0];
    const fileType = filePath.split("/")[1];
    const plantId = filePath.split("/")[2];
    const fileBucket = object.bucket;
    const bucket = storage.bucket(fileBucket);
    console.log(filePath, directory, fileType, plantId);
    if (directory == plantsDirectory) {
      try {
        const file = bucket.file(filePath);
        const fileUrl = await file.getSignedUrl({
          action: "read",
          expires: "03-16-2025",
        });
        console.log(fileUrl);

        const userRef = admin
          .firestore()
          .collection(plantCollection)
          .doc(plantId);
        if (fileType == filePhoto) {
          await userRef.set(
            {
              photos: admin.firestore.FieldValue.arrayUnion(...fileUrl),
            },
            { merge: true }
          );
          console.log(`file photo URL added for plant ${plantId}`);
        } else if (fileType == fileVideo) {
          await userRef.set(
            {
              videos: admin.firestore.FieldValue.arrayUnion(...fileUrl),
            },
            { merge: true }
          );
          console.log(`file video URL added for plant ${plantId}`);
        }
      } catch (error) {
        console.error(`Error updating file URL for plant ${plantId}:`, error);
      }
    }
  });
