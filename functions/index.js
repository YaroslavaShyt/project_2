const { onCall } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
admin.initializeApp();

exports.toUpperCase = onCall(async (request) => {
  try {
    const db = admin.firestore();
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
    const db = admin.firestore();
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
