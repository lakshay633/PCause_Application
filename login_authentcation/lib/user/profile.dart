// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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
//   User? user;
//   String? email, name = "Anonymous";
//   int? age;

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   Future<void> loadUserData() async {
//     user = _auth.currentUser;
//     if (user != null) {
//       await user!.reload();
//       user = _auth.currentUser;

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       setState(() {
//         email = user!.email ?? "Not available";
//         name = prefs.getString('name') ?? "Anonymous";
//         age = prefs.getInt('age') ?? null;
//       });
//     }
//   }

//   void updateUserData(String newName, int newAge) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('name', newName);
//     await prefs.setInt('age', newAge);

//     setState(() {
//       name = newName;
//       age = newAge;
//     });
//   }

//   void showEditDialog() {
//     TextEditingController nameController = TextEditingController(text: name);
//     TextEditingController ageController =
//         TextEditingController(text: age?.toString() ?? "");

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Edit Profile"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: "Enter Name"),
//               ),
//               TextField(
//                 controller: ageController,
//                 decoration: InputDecoration(labelText: "Enter Age"),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 updateUserData(
//                   nameController.text,
//                   int.tryParse(ageController.text) ?? 0,
//                 );
//                 Navigator.pop(context);
//               },
//               child: Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void deleteAccount() async {
//     try {
//       await _firestore.collection('users').doc(user!.uid).delete();
//       await user!.delete();
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Login()));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error deleting account: $e")),
//       );
//     }
//   }

//   void logout() async {
//     await _auth.signOut();
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => Login()));
//   }

//   Widget buildProfileCard() {
//     bool isVerified = user?.emailVerified ?? false;
//     return Container(
//       width: double.infinity,
//       height: 400,
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
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: AssetImage("assets/images.png"),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text("Name: ",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Text(name ?? "Anonymous", style: TextStyle(fontSize: 16)),
//               SizedBox(height: 5),
//               Text("Age: ",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Text(age != null ? age.toString() : "Unknown",
//                   style: TextStyle(fontSize: 16)),
//               SizedBox(height: 5),
//               Text("Email: ",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Text(email ?? "Not available", style: TextStyle(fontSize: 16)),
//               SizedBox(height: 10),
//               Center(
//                 child: IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: showEditDialog,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Center(
//                 child: GestureDetector(
//                   onTap: () async {
//                     if (!isVerified) {
//                       await user?.sendEmailVerification();
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Verification email sent!")),
//                       );
//                     }
//                   },
//                   child: Text(
//                     isVerified ? "User already verified" : "Verify your email",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isVerified ? Colors.green : Colors.red,
//                     ),
//                   ),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.pink.shade400, Colors.blue.shade700],
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 buildProfileCard(),
//                 SizedBox(height: 20),
//                 buildButton("Change Password", Colors.green, () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ChangePassword()));
//                 }),
//                 SizedBox(height: 10),
//                 buildButton("Delete Account", Colors.red, deleteAccount),
//                 SizedBox(height: 10),
//                 buildButton("Logout", Colors.blue, logout),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  User? user;
  String? email, name = "Anonymous";
  int? age;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      await user!.reload();
      user = _auth.currentUser;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        email = user!.email ?? "Not available";
        name = prefs.getString('name') ?? "Anonymous";
        age = prefs.getInt('age') ?? null;
      });
    }
  }

  void updateUserData({String? newName, int? newAge}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newName != null) {
      await prefs.setString('name', newName);
      setState(() {
        name = newName;
      });
    }
    if (newAge != null) {
      await prefs.setInt('age', newAge);
      setState(() {
        age = newAge;
      });
    }
  }

  void showEditDialog(String fieldType) {
    TextEditingController controller = TextEditingController(
      text: fieldType == "Name" ? name : age?.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $fieldType"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Enter $fieldType"),
            keyboardType: fieldType == "Age" ? TextInputType.number : null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (fieldType == "Name") {
                  updateUserData(newName: controller.text);
                } else {
                  updateUserData(newAge: int.tryParse(controller.text) ?? 0);
                }
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void deleteAccount() async {
    try {
      await _firestore.collection('users').doc(user!.uid).delete();
      await user!.delete();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting account: $e")),
      );
    }
  }

  void logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  Widget buildProfileInfo(String label, String value, {VoidCallback? onEdit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: Text(value, style: TextStyle(fontSize: 16)),
            ),
            if (onEdit != null)
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEdit,
              ),
          ],
        ),
        Divider(thickness: 1, color: Colors.grey.shade300),
      ],
    );
  }

  Widget buildProfileCard() {
    bool isVerified = user?.emailVerified ?? false;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images.png"),
              ),
            ),
            SizedBox(height: 20),
            buildProfileInfo("Name", name ?? "Anonymous",
                onEdit: () => showEditDialog("Name")),
            buildProfileInfo("Age", age != null ? age.toString() : "Unknown",
                onEdit: () => showEditDialog("Age")),
            buildProfileInfo("Email", email ?? "Not available"),
            SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (!isVerified) {
                    await user?.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Verification email sent!")),
                    );
                  }
                },
                child: Text(
                  isVerified ? "User already verified" : "Verify your email",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isVerified ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
          ],
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      children: [
                        buildProfileCard(),
                        SizedBox(height: 20),
                        buildButton("Change Password", Colors.green, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword()));
                        }),
                        SizedBox(height: 10),
                        buildButton(
                            "Delete Account", Colors.red, deleteAccount),
                        SizedBox(height: 10),
                        buildButton("Logout", Colors.blue, logout),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
