import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_authentcation/Pages/login.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePassword(_newPasswordController.text);
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content:
                Text('Password changed successfully. Please log in again.'),
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade300, Colors.blue.shade600],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "New Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.blue),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter a new password' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            changePassword();
                          }
                        },
                        child: Text("Change Password",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
