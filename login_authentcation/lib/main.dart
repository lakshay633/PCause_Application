import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_authentcation/Pages/animation.dart';
import 'package:login_authentcation/user/change_paasword.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text("Something Went Wrong")),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return MaterialApp(
          title: 'PCause - Flutter Firebase Auth',
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
