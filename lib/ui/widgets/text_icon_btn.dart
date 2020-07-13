import 'package:ezshop/constants.dart';
import 'package:flutter/material.dart';

class TextIconBtn extends StatelessWidget {
  final IconData iconData;
  final String btnText;
  final Function onTap;
  final BorderRadius borderRadius;

  TextIconBtn(
      {@required this.iconData,
      @required this.btnText,
      @required this.onTap,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: InkWell(
          borderRadius:
              borderRadius != null ? borderRadius : BorderRadius.circular(0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  color: Colors.white,
                ),
                Text(
                  btnText,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          splashColor: Colors.red,
          onTap: onTap,
        ),
        color: Colors.transparent,
      ),
    );
  }
}
