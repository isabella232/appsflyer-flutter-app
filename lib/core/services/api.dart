import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
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
