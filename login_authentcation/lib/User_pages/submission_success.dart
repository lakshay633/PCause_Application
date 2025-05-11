import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_authentcation/User_pages/PCOSQuestionnaire.dart';
import 'view_response.dart';

class SubmissionSuccessPage extends StatelessWidget {
  final String documentId;
  SubmissionSuccessPage({required this.documentId});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/success.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for your response!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ViewResponsePage(documentId: documentId),
                  ));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 10, 13, 44)),
                child: Text("View Your Response"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('YourCollectionName')
                      .doc(documentId)
                      .delete();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => PCOSQuestionnaire()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 69, 15, 11)),
                child: Text("Submit Another Response"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
