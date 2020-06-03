class User {
  String email;
  String userId;
  List<String> _shortlist = [];

  List<String> get shortlist {
    return [..._shortlist];
  }

  set shortlist(List<String> val) {
    _shortlist = val;
  }

  User(this.userId, this.email);

  void addToShortlist(String id) {
    if (!_shortlist.contains(id)) {
      _shortlist.add(id);
    }
  }

  void removeFromShortlist(String listId) {
    _shortlist.remove(listId);
  }

  toJson() {
    return {
      'userId': userId,
      'shortlist': shortlist.map((listId) => {'listId': listId}).toList(),
    };
  }
}
