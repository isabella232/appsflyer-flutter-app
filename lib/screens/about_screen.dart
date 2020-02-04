import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/main_side_drawer.dart';

class AboutScreen extends StatelessWidget {
  static final String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      drawer: MainSideDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/appsflyerLogo.png',
                  fit: BoxFit.cover,
                  width: size.width * 0.8,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black87, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(text: 'This app was made by '),
                    TextSpan(
                      text: 'Shahar Cohen ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'from AppsFlyer in order to check the new versions of AppsFlyer sdk.\nThis project is open source and hosted on GitHub. \nThe main purpose for this is to demonstrate to clients an example of how to integrate AppsFlyer sdk in a real app'),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  onTap: () async {
                    await _launchUrl();
                  },
                  leading: Icon(FontAwesomeIcons.github),
                  title: Text('To the GitHub repository'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _launchUrl() async {
    const url = 'https://github.com/AppsFlyerSDK/appsflyer-flutter-app';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
