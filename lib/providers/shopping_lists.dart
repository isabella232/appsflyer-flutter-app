import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/shopping_list.dart';
import '../models/user.dart';
import '../services/api.dart';
import './shopping_item.dart';

class ShoppingLists with ChangeNotifier {
  Api _apiShoppingLists = Api('shoppingLists');
  Api _apiUsers = Api('usersShortlist');

  List<ShoppingList> _lists = [];

  String _userId;
  User user;
  FirebaseUser _firebaseUser;

  set firebaseUser(FirebaseUser user) {
    if (user != null) {
      userId = user.uid;
    }
    _firebaseUser = user;
  }

  set userId(String value) {
    _userId = value;
    user = User(value);
  }

  //Firestore
  Future<List<ShoppingList>> fetchLists() async {
    var result = await _apiShoppingLists.getDataCollection();
    _lists = result.documents
        .map((doc) => ShoppingList.fromMap(doc.data, doc.documentID))
        .toList();
    return [..._lists];
  }

  Future<Stream<QuerySnapshot>> fetchListsAsStream() async {
    //Get the list of shoppingLists ids of the user
    if (_userId == null) {
      return null;
    }

    var shortlistIds = await fetchUserShortlistIds();
    //Fetch as stream the     selected ids
    if (shortlistIds.length == 0) {
      return null;
    }

    return _apiShoppingLists.streamDataCollection(shortlistIds);
  }

  //Search list by list id. if found something add it to the user shortlist
  Future<bool> searchList(String listId) async {
    DocumentSnapshot snapshot = await _apiShoppingLists.getDocumentById(listId);
    if (snapshot.data == null) {
      return false;
    }

    addListToUser(listId);
    notifyListeners();
    return true;
  }

  Future<ShoppingList> getListById(String id) async {
    var doc = await _apiShoppingLists.getDocumentById(id);
    if (doc.data == null) {
      return _lists.firstWhere((list) => list.id == id);
    }
    return ShoppingList.fromMap(doc.data, doc.documentID);
  }

  //Remove the list from the user and shoppingLists collections
  Future removeList(String id) async {
    await _apiShoppingLists.removeDocument(id);
    user.removeFromShortlist(id);
    await _apiUsers.updateDocument(user.toJson(), _userId);
    return;
  }

  Future updateList(ShoppingList data, String id) async {
    await _apiShoppingLists.updateDocument(data.toJson(), id);
    return;
  }

  Future updateUserShortlist(User data, String id) async {
    await _apiUsers.updateDocument(data.toJson(), id);
    return;
  }

  Future addUserShortlist() async {
    await _apiUsers.setDocument(_userId, user.toJson());
    return;
  }

  //This function add a new list to firestore db if the list is not written yet to the db.
  //If the list already exist in our db, the function update the list.
  //It also updates the usersShortlist collection.
  Future addList(String listId, String listName) async {
    final myList = await getListById(listId);
    myList.title =
        listName; //update the list name (when initially created it is still null)

    if (myList.id.contains('temp')) {
      //Add new list to both user and shoppingLists collections
      DocumentReference ref =
          await _apiShoppingLists.addDocument(myList.toJson());

      String shoppingListFirestoreId = ref.documentID;
      addListToUser(shoppingListFirestoreId);

      return;
    } else {
      //The list already exist in the db, we don't need to update the user shortlist
      updateList(myList, listId);
      return;
    }
  }

  void addListToUser(String shoppingListFirestoreId) {
    user.addToShortlist(shoppingListFirestoreId);

    if (user.shortlist.length == 1) {
      //Need to create new document in the usersShortlist collection
      addUserShortlist();
    } else {
      //update the document
      updateUserShortlist(user, _userId);
    }
  }

  //Users db
  Future<List<String>> fetchUserShortlistIds() async {
    try {
      var documentSnapshot = await _apiUsers.getDocumentById(_userId);
      var shortListNode = documentSnapshot.data['shortlist'] as List;
      var shortlist = shortListNode.map((val) {
        return val['listId'] as String;
      }).toList();
      user.shortlist = shortlist;
      return shortlist;
    } catch (error) {
      return [];
    }
  }

  //Before Firestore

  List<ShoppingList> get lists {
    return [..._lists];
  }

  String createList() {
    final listId = 'temp${DateTime.now().toIso8601String()}';
    _lists.add(ShoppingList(id: listId, title: 'temp list', items: []));
    return listId;
  }

  Future<List<ShoppingItem>> getItems(String id) async {
    final myList = await getListById(id);
    if (myList != null) {
      return myList.items;
    } else {
      return null;
    }
  }

  Future addItem(String listId, String name, int qty) async {
    final myList = await getListById(listId);
    if (myList != null) {
      myList.items.add(ShoppingItem(
          itemId: DateTime.now().toString(), name: name, quantity: qty));
      if (!myList.id.contains('temp')) {
        //Update the firestore db
        await updateList(myList, listId);
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future removeItem(String listId, ShoppingItem itemToDelete) async {
    final myList = await getListById(listId);
    if (myList != null) {
      myList.items.removeWhere((item) => item.itemId == itemToDelete.itemId);
    }
    await updateList(myList, listId);
  }
}
