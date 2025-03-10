import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_authentcation/Pages/forgot_password.dart';
import 'package:login_authentcation/Pages/signup.dart';
import 'package:login_authentcation/user/dashboard.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var email = "", password = "";
  bool _obscurePassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } on FirebaseAuthException catch (e) {
      String message = (e.code == 'user-not-found')
          ? "No User Found for that Email"
          : (e.code == 'wrong-password')
              ? "Wrong Password Provided by User"
              : "An error occurred";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.pinkAccent,
          content: Text(message,
              style: TextStyle(fontSize: 16.0, color: Colors.white))));
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Google Sign-In failed. Try again."),
          backgroundColor: Colors.red));
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.pink.shade400, Colors.blue.shade700])),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/1st.png', height: 120.0),
                    SizedBox(height: 20.0),
                    Text('Login',
                        style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(fontSize: 18.0, color: Colors.white),
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter email'
                          : (!value.contains('@'))
                              ? 'Enter a valid email'
                              : null,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(fontSize: 18.0, color: Colors.white),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter password'
                          : null,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 40.0)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                          });
                          userLogin();
                        }
                      },
                      child: Text('Login',
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0)),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword())),
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                            style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, a, b) => Signup(),
                                  transitionDuration: Duration(seconds: 0)),
                              (route) => false),
                          child: Text('Signup',
                              style: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
