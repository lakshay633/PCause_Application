// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ViewResponsePage extends StatelessWidget {
//   final String documentId;

//   ViewResponsePage({required this.documentId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: Text(
//           "Your Response",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.pink.shade300, Colors.blue.shade600],
//           ),
//         ),
//         child: FutureBuilder<DocumentSnapshot>(
//           future: FirebaseFirestore.instance
//               .collection('YourCollectionName')
//               .doc(documentId)
//               .get(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData)
//               return Center(child: CircularProgressIndicator());
//             final data = snapshot.data!.data() as Map<String, dynamic>;

//             return ListView(
//               padding: EdgeInsets.all(16),
//               children: data.entries.map((entry) {
//                 if (entry.key == 'submitted_at') return SizedBox();
//                 return ListTile(
//                   title: Text(
//                     formatLabel(entry.key),
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   subtitle: Text(
//                     entry.value.toString(),
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   String formatLabel(String key) {
//     final map = {
//       'hair growth(Y/N)': "Do you have excessive hair growth?",
//       'Pimples(Y/N)': "Do you have pimples or oily skin?",
//       'Hair loss(Y/N)': "Are you experiencing hair loss?",
//       'Weight gain(Y/N)': "Have you gained weight recently?",
//       'Skin darkening (Y/N)': "Do you have dark patches on your skin?",
//       'Fast food (Y/N)': "Do you eat fast food often?",
//       'Reg.Exercise(Y/N)': "Do you exercise regularly?",
//       'Cycle(R/I)': "Are your periods regular or irregular?",
//       'Cycle length(days)': "How long does your cycle last?",
//       'Pregnant(Y/N)': "Are you pregnant?",
//       'No. of aborptions': "Number of abortions"
//     };
//     return map[key] ?? key;
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewResponsePage extends StatelessWidget {
  final String documentId;

  ViewResponsePage({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Your Response",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade300, Colors.blue.shade600],
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('YourCollectionName')
              .doc(documentId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                child: Text(
                  "No data found for this response.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                if (data.containsKey('submitted_at'))
                  ListTile(
                    title: Text(
                      "Submitted At",
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd()
                          .add_jm()
                          .format((data['submitted_at'] as Timestamp).toDate()),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ...data.entries
                    .where((entry) =>
                        entry.key != 'submitted_at' && entry.key != 'uid')
                    .map((entry) {
                  return ListTile(
                    title: Text(
                      formatLabel(entry.key),
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      entry.value.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  String formatLabel(String key) {
    final map = {
      'hair growth(Y/N)': "Do you have excessive hair growth?",
      'Pimples(Y/N)': "Do you have pimples or oily skin?",
      'Hair loss(Y/N)': "Are you experiencing hair loss?",
      'Weight gain(Y/N)': "Have you gained weight recently?",
      'Skin darkening (Y/N)': "Do you have dark patches on your skin?",
      'Fast food (Y/N)': "Do you eat fast food often?",
      'Reg.Exercise(Y/N)': "Do you exercise regularly?",
      'Cycle(R/I)': "Are your periods regular or irregular?",
      'Cycle length(days)': "How many days does your cycle last?",
      'Pregnant(Y/N)': "Are you pregnant?",
      'No. of aborptions': "Number of abortions",
    };
    return map[key] ?? key;
  }
}
