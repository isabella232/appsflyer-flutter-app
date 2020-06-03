import 'dart:convert';

import 'package:ezshop/core/models/shopping_list.dart';
import 'package:ezshop/core/models/user.dart';
import 'package:ezshop/core/services/api.dart';
import 'package:ezshop/core/services/appsflyer.dart';
import 'package:ezshop/locator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './shopping_item.dart';
import './app_provider.dart';

class ShoppingLists with ChangeNotifier {
  Api _apiShoppingLists = Api('shoppingLists');
  Api _apiUsers = Api('usersShortlist');
  AppsFlyerService _appsFlyerService = locator<AppsFlyerService>();
  AppMode _appMode;

  List<ShoppingList> _lists = [];

  String _userId;
  User _user;

  set user(User myUser) {
    if (myUser == null) {
      _user = null;
      return;
    }

    _userId = myUser.userId;
    _user = myUser;
  }

  User get user {
    return _user;
  }

  set appMode(AppMode appMode) {
    _appMode = appMode;
  }

  Future<List<ShoppingList>> fetchLists({bool getTemplates}) async {
    List<ShoppingList> templateLists = List<ShoppingList>();
    List<ShoppingList> regulartLists = List<ShoppingList>();
    if (_appMode == AppMode.OpenSource) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> encodedLists = prefs.getStringList("lists");
      if (encodedLists == null) {
        return null;
      }

      List<ShoppingList> sharedPrefsLists = encodedLists.map((encodedList) {
        int index = encodedLists.indexOf(encodedList);
        Map<String, dynamic> decodedListMap = json.decode(encodedList);
        return ShoppingList.fromMap(decodedListMap, (++index).toString());
      }).toList();

      sharedPrefsLists.forEach((sharedPrefsList) {
        bool exist = _lists
                .where(
                    (list) => list.timestampId == sharedPrefsList.timestampId)
                .toList()
                .length >
            0;
        if (!exist) {
          _lists.add(sharedPrefsList);
        }
      });
      return _lists;
    } else {
      var shortlistIds = await fetchUserShortlistIds();
      //Fetch as stream the     selected ids
      if (shortlistIds.length == 0) {
        return null;
      }

      QuerySnapshot snapshot =
          await _apiShoppingLists.getDataCollection(shortlistIds);

      for (DocumentSnapshot doc in snapshot.documents) {
        ShoppingList list = ShoppingList.fromMap(doc.data, doc.documentID);
        if (getTemplates && list.template) {
          templateLists.add(list);
        } else if (!getTemplates && !list.template) {
          regulartLists.add(list);
        }
      }

      if (getTemplates) {
        return templateLists;
      }
      return regulartLists;
    }
  }

  Future<Stream<QuerySnapshot>> fetchListsAsStream() async {
    //Get the list of shoppingLists ids of the user
    if (_userId == null) {
      return null;
    }

    if (_appMode == AppMode.OpenSource) {
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
  //Only available for Firebase version
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
    if (_appMode == AppMode.OpenSource) {
      return _lists.firstWhere((list) => list.id == id);
    }

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

  //Update the list with the toggled item
  Future updateList(ShoppingList data, String id) async {
    if (_appMode == AppMode.OpenSource) {
      await _saveToSharedPrefs();
      notifyListeners();
      return;
    }

    await _apiShoppingLists.updateDocument(data.toJson(), id);
    notifyListeners();
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
  Future addList(String listId, String listName, bool isTemplate) async {
    final myList = await getListById(listId);
    myList.title =
        listName; //update the list name (when initially created it is still null)

    _appsFlyerService.appsFlyerSdk.trackEvent(
        "Added new list", {"List Name": myList.title, "user": user.email});
    //Check if the app is from GitHub. If it is, save it into the shared preferences
    if (_appMode == AppMode.OpenSource) {
      //convert _lists into encoded list
      await _saveToSharedPrefs();
      return;
    }

    myList.template = isTemplate;
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

  Future _saveToSharedPrefs() async {
    List<String> encodedLists =
        _lists.map((list) => json.encode(list)).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("lists", encodedLists);
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

  String createList({List<ShoppingItem> items}) {
    final listId = 'temp${DateTime.now().toIso8601String()}';
    _lists.add(
      ShoppingList(
        id: listId,
        title: 'temp list',
        items: items != null ? items : [],
        timestampId: listId,
        template: false,
      ),
    );
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
