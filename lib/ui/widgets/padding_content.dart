import 'package:flutter/material.dart';

class PaddedContent extends StatelessWidget {
  final Widget child;

  PaddedContent({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }
}
