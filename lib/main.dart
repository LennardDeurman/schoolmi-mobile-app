import 'package:flutter/material.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/pages/auth.dart';
import 'package:schoolmi/pages/home.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() {
  Localization localization = Localization();
  initializeDateFormatting(localization.locale);
  runApp(MainApp());
}

class MainApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MainAppState();
  }

}

class MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserResult>(
      stream: UserService().userResultStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          UserResult userResult = snapshot.data;
          if (userResult == null) {
            return AuthPage();
          }
          return HomePage();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

}
