import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_mang/database/dataModel.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final delayedStreamProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
});

final fetchProvider = StreamProvider<List<DataBase>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('Employee')
      .orderBy('empName')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => DataBase.fromMap(doc.data(), doc.id))
        .toList();
  });
});

final addDataProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return (DataBase data) async {
    await firestore.collection('Employee').add(data.toMap());
  };
});

final updateDataProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return (DataBase data) async {
    await firestore.collection('Employee').doc(data.id).update(data.toMap());
  };
});

final deleteDataProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return (String id) async {
    await firestore.collection('Employee').doc(id).delete();
  };
});
