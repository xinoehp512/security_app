import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:security_app/screens/auth_screen.dart';
import 'package:security_app/screens/main_screen.dart';
import 'package:security_app/screens/settings_screen.dart';
import 'package:security_app/screens/splash_screen.dart';
import 'package:security_app/screens/tic_tac_toe_screen.dart';
import 'package:security_app/screens/ultimate_tic_tac_toe_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }
                if (snapshot.hasData) {
                  return const MainScreen();
                }
                return const AuthScreen();
              },
            );
          }),
      routes: {
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        TicTacToeScreen.routeName: (context) => const TicTacToeScreen(),
        UltimateTicTacToeScreen.routeName: (context) =>
            const UltimateTicTacToeScreen(),
      },
    );
  }
}
