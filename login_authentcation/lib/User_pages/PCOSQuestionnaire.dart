// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'submission_success.dart';

// class PCOSQuestionnaire extends StatefulWidget {
//   @override
//   _PCOSQuestionnaireState createState() => _PCOSQuestionnaireState();
// }

// class _PCOSQuestionnaireState extends State<PCOSQuestionnaire> {
//   final _formKey = GlobalKey<FormState>();

//   // Final data to be submitted
//   final Map<String, dynamic> responses = {};

//   // Temp dropdown values to safely hold String data
//   final Map<String, String?> dropdownValues = {};

//   final fields = [
//     {
//       'label': 'How many days does your cycle last?',
//       'key': 'Cycle length(days)',
//       'isText': true
//     },
//     {
//       'label': 'Are your periods Regular or Irregular?',
//       'key': 'Cycle(R/I)',
//       'options': ['R', 'I']
//     },
//     {'label': 'Do you eat fast food often?', 'key': 'Fast food (Y/N)'},
//     {'label': 'Are you experiencing hair loss?', 'key': 'Hair loss(Y/N)'},
//     {
//       'label': 'How many abortions have you had?',
//       'key': 'No. of aborptions',
//       'isText': true
//     },
//     {'label': 'Do you have pimples or oily skin?', 'key': 'Pimples(Y/N)'},
//     {'label': 'Are you pregnant?', 'key': 'Pregnant(Y/N)'},
//     {'label': 'Do you exercise regularly?', 'key': 'Reg.Exercise(Y/N)'},
//     {
//       'label': 'Do you have dark patches on your skin?',
//       'key': 'Skin darkening (Y/N)'
//     },
//     {'label': 'Have you gained weight recently?', 'key': 'Weight gain(Y/N)'},
//     {'label': 'Do you have excessive hair growth?', 'key': 'hair growth(Y/N)'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.pink.shade300, Colors.blue.shade600],
//         ),
//       ),
//       child: Form(
//         key: _formKey,
//         child: ListView(
//           padding: EdgeInsets.all(16),
//           children: [
//             ...fields.map((field) {
//               final key = field['key'] as String;
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: field['isText'] == true
//                     ? TextFormField(
//                         decoration: InputDecoration(
//                             labelText: field['label'] as String),
//                         keyboardType: TextInputType.number,
//                         validator: (val) =>
//                             val == null || val.isEmpty ? 'Required' : null,
//                         onSaved: (val) => responses[key] = val ?? '',
//                       )
//                     : DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                             labelText: field['label'] as String),
//                         value: dropdownValues[key],
//                         items: (field['options'] as List<String>? ?? ['Y', 'N'])
//                             .map<DropdownMenuItem<String>>((opt) {
//                           return DropdownMenuItem(value: opt, child: Text(opt));
//                         }).toList(),
//                         onChanged: (val) {
//                           setState(() {
//                             dropdownValues[key] = val;
//                           });
//                         },
//                         validator: (val) => val == null ? 'Required' : null,
//                         onSaved: (val) => responses[key] = val ?? '',
//                       ),
//               );
//             }).toList(),
//             SizedBox(height: 24),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//               ),
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   _formKey.currentState!.save();
//                   responses['submitted_at'] = Timestamp.now();
//                   final user = FirebaseAuth.instance.currentUser;
//                   if (user != null) {
//                     responses['uid'] = user.uid;
//                   }
//                   final doc = await FirebaseFirestore.instance
//                       .collection('YourCollectionName')
//                       .add(responses);

//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       content: Text(
//                           "You can check your analytics by going to the Home page."),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                             Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                 builder: (_) =>
//                                     SubmissionSuccessPage(documentId: doc.id),
//                               ),
//                             );
//                           },
//                           child: Text("OK"),
//                         )
//                       ],
//                     ),
//                   );
//                 }
//               },
//               child: Text("Submit"),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'submission_success.dart';

class PCOSQuestionnaire extends StatefulWidget {
  @override
  _PCOSQuestionnaireState createState() => _PCOSQuestionnaireState();
}

class _PCOSQuestionnaireState extends State<PCOSQuestionnaire> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> responses = {};
  final Map<String, String?> dropdownValues = {};

  final fields = [
    {
      'label': 'How many days does your cycle last?',
      'key': 'Cycle length(days)',
      'isText': true
    },
    {
      'label': 'Are your periods Regular or Irregular?',
      'key': 'Cycle(R/I)',
      'options': ['R', 'I']
    },
    {'label': 'Do you eat fast food often?', 'key': 'Fast food (Y/N)'},
    {'label': 'Are you experiencing hair loss?', 'key': 'Hair loss(Y/N)'},
    {
      'label': 'How many abortions have you had?',
      'key': 'No. of aborptions',
      'isText': true
    },
    {'label': 'Do you have pimples or oily skin?', 'key': 'Pimples(Y/N)'},
    {'label': 'Are you pregnant?', 'key': 'Pregnant(Y/N)'},
    {'label': 'Do you exercise regularly?', 'key': 'Reg.Exercise(Y/N)'},
    {
      'label': 'Do you have dark patches on your skin?',
      'key': 'Skin darkening (Y/N)'
    },
    {'label': 'Have you gained weight recently?', 'key': 'Weight gain(Y/N)'},
    {'label': 'Do you have excessive hair growth?', 'key': 'hair growth(Y/N)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PCOS Questionnaire"),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade300, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ...fields.map((field) {
                    final key = field['key'] as String;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: field['isText'] == true
                          ? TextFormField(
                              decoration: InputDecoration(
                                labelText: field['label'] as String,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Required'
                                  : null,
                              onSaved: (val) => responses[key] = val ?? '',
                            )
                          : DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: field['label'] as String,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              value: dropdownValues[key],
                              items: (field['options'] as List<String>? ??
                                      ['Y', 'N'])
                                  .map((opt) => DropdownMenuItem(
                                        value: opt,
                                        child: Text(opt),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  dropdownValues[key] = val;
                                });
                              },
                              validator: (val) =>
                                  val == null ? 'Required' : null,
                              onSaved: (val) => responses[key] = val ?? '',
                            ),
                    );
                  }).toList(),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        responses['submitted_at'] = Timestamp.now();
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          responses['uid'] = user.uid;
                        }

                        try {
                          final doc = await FirebaseFirestore.instance
                              .collection('YourCollectionName')
                              .add(responses);

                          if (!mounted) return;

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) =>
                                  SubmissionSuccessPage(documentId: doc.id),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Submission failed: $e"),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                    child: Text("Submit"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
