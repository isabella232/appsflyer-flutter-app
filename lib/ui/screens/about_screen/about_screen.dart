import 'package:ezshop/core/providers/app_provider.dart';
import 'package:ezshop/ui/widgets/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';
import '../../widgets/main_side_drawer.dart';

class AboutScreen extends StatelessWidget {
  static final String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final app = Provider.of<AppProvider>(context);

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
              buildDetailsContainer(
                context: context,
                label:
                    "${Constants.VERSION_NUMBER} (${AppModeHelper.getValue(app.appMode)})",
                iconData: FontAwesomeIcons.mobileAlt,
              ),
              app.appsFlyerSdkMode == AppsFlyerSdkMode.Initialized
                  ? FutureBuilder(
                      future: app.appsFlyerService.appsFlyerSdk.getSDKVersion(),
                      builder: (ctx, dataSnapshot) {
                        if (dataSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (dataSnapshot.error != null) {
                            return Center(
                              child: Text('An error occured'),
                            );
                          } else {
                            String version = dataSnapshot.data as String;
                            return buildDetailsContainer(
                              context: context,
                              label: version,
                              iconData: CustomIcons.appsflyer,
                            );
                          }
                        }
                      },
                    )
                  : buildDetailsContainer(
                      context: context,
                      label: "AppsFlyer SDK not initialised",
                      iconData: CustomIcons.appsflyer,
                    ),
              buildDetailsContainer(
                context: context,
                label: 'To the GitHub repository',
                iconData: FontAwesomeIcons.github,
                onClick: () async {
                  await _launchUrl();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDetailsContainer(
      {@required BuildContext context,
      @required String label,
      @required IconData iconData,
      Function onClick}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        onTap: onClick == null ? () {} : onClick,
        leading: Icon(
          iconData,
          size: 30,
        ),
        title: Text(label),
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
