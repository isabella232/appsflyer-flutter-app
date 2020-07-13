import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Api {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://ezshop-dcad9.appspot.com/');
  String path;
  CollectionReference ref;

  Api.dataStore();

  Api(this.path) {
    ref = _db.collection(path);
  }

  StorageUploadTask startUpload(String filename, File file) {
    String filepath = 'images/$filename.png';
    return _storage.ref().child(filepath).putFile(file);
  }

  Future<dynamic> getFile(String filename) async {
    String filepath = 'images/$filename';
    var res =
        await _storage.ref().child(filepath).getDownloadURL().catchError((err) {
      return null;
    });
    return res;
  }

  Future<QuerySnapshot> getDataCollection(List<String> docIds) {
    return ref.where(FieldPath.documentId, whereIn: docIds).getDocuments();
  }

  //Filter the data stream by doc ids
  Stream<QuerySnapshot> streamDataCollection(List<String> docIds) {
    return ref.where(FieldPath.documentId, whereIn: docIds).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  //Added this function specially for usersShortlist collection
  Future setDocument(String docId, Map data) {
    return ref.document(docId).setData(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }
}
