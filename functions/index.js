const { onCall } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const { plantCollection } = require("./collections");
const functions = require("firebase-functions");
admin.initializeApp();

const firestore = admin.firestore();

exports.toUpperCase = onCall(async (request) => {
  try {
    const db = firestore;
    const collectionName = request.data;
    const dataRef = db.collection(collectionName);
    const snapshot = await dataRef.get();
    const batch = db.batch();
    snapshot.forEach((doc) => {
      const data = doc.data();
      const upperCaseData = data.name.toUpperCase();
      batch.update(doc.ref, { name: upperCaseData });
    });
    await batch.commit();
    return { success: true };
  } catch (e) {
    return { success: false, message: e.message };
  }
});

exports.toLowerCase = onCall(async (request) => {
  try {
    const db = firestore;
    const collectionName = request.data;
    const dataRef = db.collection(collectionName);
    const snapshot = await dataRef.get();
    const batch = db.batch();
    snapshot.forEach((doc) => {
      const data = doc.data();
      const lowerCaseData = data.name.toLowerCase();
      batch.update(doc.ref, { name: lowerCaseData });
    });
    await batch.commit();
    return { success: true };
  } catch (e) {
    return { success: false, message: e.message };
  }
});

exports.onCreatePlant = functions.firestore
  .document(`${plantCollection}/{plantId}`)
  .onCreate((snapshot, context) => {
    try {
      const newPlant = snapshot.data();
      const newName =
        newPlant["name"].charAt(0).toUpperCase() + newPlant["name"].slice(1);
      return snapshot.ref.update({ name: newName });
    } catch (e) {
      console.log(e.message);
    }
  });

exports.onUpdatePlant = functions.firestore
  .document(`${plantCollection}/{plantId}`)
  .onUpdate((change, context) => {
    try {
      const newData = change.after.data();
      const newName = newData["name"];

      if (!newName.includes("(ред)") && !newName.includes("(РЕД)")) {
        const updatedName = newName + " (ред)";
        return change.after.ref.update({ name: updatedName }); 
      } else {
        return null; 
      }
    } catch (e) {
      console.log(e.message);
      return null; 
    }
  });


exports.onDeletePlant = functions.firestore
  .document(`${plantCollection}/{plantId}`)
  .onDelete((snapshot, context) => {
    try {
      console.log("Document Deleted:", snapshot.data());
      return null;
    } catch (e) {
      console.log(e.message);
      return null;
    }
  });

// exports.printPlantCount = functions.pubsub
//   .schedule("every 2 minutes")
//   .onRun(async (context) => {
//     try {
//       const snapshot = await admin.firestore().collection("plants").get();
//       const plantCount = snapshot.size;
//       console.log(`Кількість рослин у колекції: ${plantCount}`);
//       return null;
//     } catch (error) {
//       console.error("Помилка при отриманні кількості рослин:", error);
//       return null;
//     }
//   });


