// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:login_authentcation/Pages/login.dart';
// // import 'package:login_authentcation/user/change_paasword.dart';

// // class Profile extends StatefulWidget {
// //   Profile({Key? key}) : super(key: key);

// //   @override
// //   _ProfileState createState() => _ProfileState();
// // }

// // class _ProfileState extends State<Profile> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final FirebaseStorage _storage = FirebaseStorage.instance;

// //   User? user;
// //   String? email;
// //   DateTime? creationTime;

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadUserData();
// //   }

// //   void loadUserData() {
// //     user = _auth.currentUser;
// //     setState(() {
// //       email = user?.email;
// //       creationTime = user?.metadata.creationTime;
// //     });
// //   }

// //   Future<void> verifyEmail() async {
// //     if (user != null) {
// //       await user!.sendEmailVerification();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Verification email sent!')),
// //       );
// //     }
// //   }

// //   Future<void> deleteAccount() async {
// //     try {
// //       if (user == null) return;
// //       await _firestore.collection('users').doc(user!.uid).delete();
// //       try {
// //         await _storage.ref('profile_images/${user!.uid}.jpg').delete();
// //       } catch (e) {
// //         print("No profile image found.");
// //       }
// //       await user!.delete();
// //       await _auth.signOut();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Account deleted successfully.")),
// //       );
// //       Navigator.pushReplacement(
// //           context, MaterialPageRoute(builder: (context) => Login()));
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Failed to delete account: ${e.toString()}")),
// //       );
// //     }
// //   }

// //   void confirmDeleteAccount() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text("Delete Account"),
// //           content: Text("Are you sure you want to delete your account?"),
// //           actions: [
// //             TextButton(
// //               child: Text("Cancel"),
// //               onPressed: () => Navigator.of(context).pop(),
// //             ),
// //             TextButton(
// //               child: Text("Delete", style: TextStyle(color: Colors.red)),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //                 deleteAccount();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Future<void> logout() async {
// //     await _auth.signOut();
// //     Navigator.pushReplacement(
// //         context, MaterialPageRoute(builder: (context) => Login()));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           "Profile",
// //           style: TextStyle(
// //               fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //       ),
// //       body: SingleChildScrollView(
// //         child: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Colors.pink.shade300, Colors.blue.shade300],
// //             ),
// //           ),
// //           child: Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Icon(Icons.account_circle, size: 100, color: Colors.white),
// //                 SizedBox(height: 20),
// //                 buildProfileCard(),
// //                 SizedBox(height: 30),
// //                 buildButton("Change Password", Colors.green, () {
// //                   Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                           builder: (context) => ChangePassword()));
// //                 }),
// //                 SizedBox(height: 10),
// //                 buildButton("Delete Account", Colors.red, confirmDeleteAccount),
// //                 SizedBox(height: 10),
// //                 buildButton("Logout", Colors.blue, logout),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildProfileCard() {
// //     bool isVerified = user?.emailVerified ?? false;
// //     return Container(
// //       width: double.infinity,
// //       child: Card(
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(15),
// //         ),
// //         elevation: 5,
// //         margin: EdgeInsets.symmetric(vertical: 8),
// //         child: Padding(
// //           padding: EdgeInsets.all(20),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text("Email:",
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //               Text(email ?? "N/A", style: TextStyle(fontSize: 16)),
// //               SizedBox(height: 10),
// //               Text("Created On:",
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //               Text(creationTime?.toLocal().toString() ?? "N/A",
// //                   style: TextStyle(fontSize: 16)),
// //               SizedBox(height: 10),
// //               Text(
// //                 isVerified ? "User already verified" : "Verify your email",
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: isVerified ? Colors.green : Colors.red,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildButton(String text, Color color, VoidCallback onPressed) {
// //     return SizedBox(
// //       width: double.infinity,
// //       height: 50,
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           primary: color,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(10),
// //             side: BorderSide(color: Colors.white, width: 0.5),
// //           ),
// //         ),
// //         onPressed: onPressed,
// //         child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
// //       ),
// //     );
// //   }
// // }import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:login_authentcation/Pages/login.dart';
// import 'package:login_authentcation/user/change_paasword.dart';

// class Profile extends StatefulWidget {
//   Profile({Key? key}) : super(key: key);

//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   User? user;
//   String? email;
//   DateTime? creationTime;

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   void loadUserData() {
//     user = _auth.currentUser;
//     setState(() {
//       email = user?.email;
//       creationTime = user?.metadata.creationTime;
//     });
//   }

//   Future<void> verifyEmail() async {
//     if (user != null) {
//       await user!.sendEmailVerification();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Verification email sent!')),
//       );
//     }
//   }

//   Future<void> deleteAccount() async {
//     try {
//       if (user == null) return;
//       await _firestore.collection('users').doc(user!.uid).delete();
//       try {
//         await _storage.ref('profile_images/${user!.uid}.jpg').delete();
//       } catch (e) {
//         print("No profile image found.");
//       }
//       await user!.delete();
//       await _auth.signOut();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Account deleted successfully.")),
//       );
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Login()));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to delete account: ${e.toString()}")),
//       );
//     }
//   }

//   void confirmDeleteAccount() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Delete Account"),
//           content: Text("Are you sure you want to delete your account?"),
//           actions: [
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             TextButton(
//               child: Text("Delete", style: TextStyle(color: Colors.red)),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 deleteAccount();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> logout() async {
//     await _auth.signOut();
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => Login()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.pink.shade400, Colors.blue.shade700],
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(Icons.account_circle, size: 100, color: Colors.white),
//               SizedBox(height: 20),
//               buildProfileCard(),
//               SizedBox(height: 30),
//               buildButton("Change Password", Colors.green, () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => ChangePassword()));
//               }),
//               SizedBox(height: 10),
//               buildButton("Delete Account", Colors.red, confirmDeleteAccount),
//               SizedBox(height: 10),
//               buildButton("Logout", Colors.blue, logout),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildProfileCard() {
//     bool isVerified = user?.emailVerified ?? false;
//     return Container(
//       width: double.infinity,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         elevation: 5,
//         margin: EdgeInsets.symmetric(vertical: 8),
//         color: Colors.white,
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Email:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Text(email ?? "N/A", style: TextStyle(fontSize: 16)),
//               SizedBox(height: 10),
//               Text("Created On:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Text(creationTime?.toLocal().toString() ?? "N/A",
//                   style: TextStyle(fontSize: 16)),
//               SizedBox(height: 10),
//               Text(
//                 isVerified ? "User already verified" : "Verify your email",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: isVerified ? Colors.green : Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildButton(String text, Color color, VoidCallback onPressed) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           primary: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//             side: BorderSide(color: Colors.white, width: 0.5),
//           ),
//         ),
//         onPressed: onPressed,
//         child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
//       ),
//     );
//   }
// }

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
      email = user?.email;
      creationTime = user?.metadata.creationTime;
    });
  }

  Future<void> verifyEmail() async {
    if (user != null) {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification email sent!')),
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (user == null) {
        print("⚠️ User is null");
        return;
      }

      // Step 1: Reauthenticate User
      String? password = await _promptForPassword();
      if (password == null || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Password is required to delete the account.")),
        );
        return;
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user!.reauthenticateWithCredential(credential);
      print("✅ Reauthentication successful!");

      // Step 2: Delete Firestore Data
      DocumentReference userDoc = _firestore.collection('users').doc(user!.uid);
      await userDoc.delete().then((_) {
        print("✅ Firestore data deleted!");
      }).catchError((e) {
        print("❌ Firestore delete failed: $e");
      });

      // Step 3: Delete Firebase Storage File
      Reference storageRef = _storage.ref('profile_images/${user!.uid}.jpg');
      await storageRef.delete().then((_) {
        print("✅ Profile image deleted!");
      }).catchError((e) {
        print("⚠️ No profile image found or failed to delete: $e");
      });

      // Step 4: Delete User from Firebase Authentication
      await user!.delete().then((_) {
        print("✅ User account deleted from Firebase Authentication!");
      }).catchError((e) {
        print("❌ Account deletion failed: $e");
      });

      // Step 5: Logout and Redirect to Login Page
      await _auth.signOut();
      print("✅ User logged out!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account deleted successfully.")),
      );
    } catch (e) {
      print("❌ Error in account deletion: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: ${e.toString()}")),
      );
    }
  }

  Future<String?> _promptForPassword() async {
    String? password;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController passwordController = TextEditingController();
        return AlertDialog(
          title: Text("Enter Password"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                password = passwordController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return password;
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
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade400, Colors.blue.shade700],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 100, color: Colors.white),
              SizedBox(height: 20),
              buildProfileCard(),
              SizedBox(height: 30),
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

  Widget buildProfileCard() {
    bool isVerified = user?.emailVerified ?? false;
    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(email ?? "N/A", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text("Created On:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(creationTime?.toLocal().toString() ?? "N/A",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text(
                isVerified ? "User already verified" : "Verify your email",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isVerified ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.white, width: 0.5),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
