import '../screens/account/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'provider/allProvider.dart';
import 'provider/date_and_tabIndex_provider.dart';
import 'provider/transaction_provider.dart';
import 'screens/main/overall_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await Firebase.initializeApp(
  // options: FirebaseOptions(
  //     apiKey: "AIzaSyAP4T3h2i_xK2_drxotGBThWH7L2wm3J1g",
  //     authDomain: "cholay-ice-v2.firebaseapp.com",
  //     projectId: "cholay-ice-v2",
  //     storageBucket: "cholay-ice-v2.appspot.com",
  //     messagingSenderId: "590219865295",
  //     appId: "1:590219865295:web:5e37f1a4fb61223c55dbba",
  //     measurementId: "G-5K4GLTDL0R"),
  //);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.lightBlue);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AllProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DateAndTabIndex(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cholay Ice',
        theme: ThemeData(
          //fontFamily: 'Pyidaungsu',
          primaryColor: primaryColor,
          primarySwatch: canvasColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  textStyle:
                      const TextStyle(fontSize: 16.0, color: Colors.white))),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {}
              if (userSnapshot.hasData) {
                return OverallScreen();
              }
              return LoginScreen();
            }),
      ),
    );
  }
}
