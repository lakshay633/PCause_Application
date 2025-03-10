import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:login_authentcation/Pages/login.dart';
import 'package:login_authentcation/user/change_paasword.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? user;
  String? uid;
  String? email;
  DateTime? creationTime;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() {
    user = _auth.currentUser;
    setState(() {
      uid = user?.uid;
      email = user?.email;
      creationTime = user?.metadata.creationTime;
    });
  }

  Future<void> verifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent!')),
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (user == null) return;
      await _firestore.collection('users').doc(user!.uid).delete();
      try {
        await _storage.ref('profile_images/${user!.uid}.jpg').delete();
      } catch (e) {
        print("No profile image found.");
      }
      await user!.delete();
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account deleted successfully.")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: ${e.toString()}")),
      );
    }
  }

  void confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade300, Colors.blue.shade300],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              buildProfileCard("User ID", uid ?? "N/A"),
              buildProfileCard("Email", email ?? "N/A"),
              buildProfileCard(
                  "Created On", creationTime?.toLocal().toString() ?? "N/A"),
              SizedBox(height: 40),
              if (!(user?.emailVerified ?? false))
                buildButton("Verify Email", Colors.orange, verifyEmail),
              SizedBox(height: 10),
              buildButton("Change Password", Colors.green, () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              }),
              SizedBox(height: 10),
              buildButton("Delete Account", Colors.red, confirmDeleteAccount),
              SizedBox(height: 10),
              buildButton("Logout", Colors.blue, logout),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileCard(String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        title: Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 250,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.white, width: 0.5),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
