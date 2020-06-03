import 'package:flutter/material.dart';

class SearchListForm extends StatefulWidget {
  @override
  _SearchListFormState createState() => _SearchListFormState();
}

class _SearchListFormState extends State<SearchListForm> {
  final _form = GlobalKey<FormState>();
  String submittedId;

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    Navigator.of(context).pop(submittedId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Form(
        key: _form,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Please enter the list id",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "List Id",
                ),
                onSaved: (val) {
                  submittedId = val;
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Please provide a valid id";
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (_) {
                  _saveForm();
                },
              ),
              RaisedButton(
                onPressed: () {
                  _saveForm();
                },
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Search shopping list",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
