import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:schoolmi/localization/localization.dart';
import 'package:schoolmi/constants/brand_colors.dart';
import 'package:schoolmi/constants/fonts.dart';
import 'package:schoolmi/pages/auth.dart';
import 'package:schoolmi/pages/home.dart';
import 'package:schoolmi/network/auth/user_service.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() {
  Localization localization = Localization();
  initializeDateFormatting(localization.locale);
  Stetho.initialize();
  runApp(MainApp());
  UserService().initializeAuthListener();
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Localization().getValue(Localization().appName),
      home: StreamBuilder<UserResult>(
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
      ),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: BrandColors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            title: TextStyle(fontFamily: Fonts.lato, fontSize: 19.0, fontWeight: FontWeight.w800),
          ),
        ),
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
        buttonColor: BrandColors.blue,
        fontFamily: Fonts.lato,
        textTheme: TextTheme(
          button: TextStyle(
            fontFamily: Fonts.lato,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

}

