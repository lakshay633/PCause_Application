import 'package:flutter/material.dart';
import 'package:login_authentcation/Pages/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
    );
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double logoSize = constraints.maxWidth * 1;
          double fontSize = constraints.maxWidth * 0.14;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: logoSize,
                  height: logoSize,
                ),
                SizedBox(height: constraints.maxHeight * 0.01),
                FadeTransition(
                  opacity: _textAnimation,
                  child: ScaleTransition(
                    scale: _textAnimation,
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.pink, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'PCause',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
