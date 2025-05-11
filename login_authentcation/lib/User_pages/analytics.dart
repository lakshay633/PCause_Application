import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Map<String, dynamic>? userResponse;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allResponses = [];

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final allData = await FirebaseFirestore.instance
          .collection('YourCollectionName')
          .get();
      final responses = allData.docs;

      final userDoc = responses
          .where((doc) => doc.data()['uid'] == currentUser.uid)
          .toList();

      setState(() {
        allResponses = responses;
        userResponse = userDoc.isNotEmpty ? userDoc.first.data() : null;
      });
    } catch (e) {
      print('Error fetching analytics: $e');
    }
  }

  int countYes(String key) {
    return allResponses.where((doc) => doc.data()[key] == 'Y').length;
  }

  Widget buildBarChart(String key, String title) {
    final yes = countYes(key);
    final no = allResponses.length - yes;
    final userAnswer = userResponse?[key];

    final data = [
      ChartData('Yes', yes),
      ChartData('No', no),
    ];

    String userInsight = "";
    if (userAnswer != null) {
      userInsight =
          "You lie in the group of people who answered '${userAnswer.toUpperCase()}' to this question.";
    }

    return Card(
      color: Colors.white,
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16)),
            SizedBox(height: 10),
            Expanded(
              child: charts.BarChart(
                [
                  charts.Series<ChartData, String>(
                    id: key,
                    domainFn: (ChartData data, _) => data.label,
                    measureFn: (ChartData data, _) => data.value,
                    data: data,
                    labelAccessorFn: (ChartData data, _) => '${data.value}',
                    colorFn: (_, __) =>
                        charts.MaterialPalette.teal.shadeDefault,
                  )
                ],
                animate: true,
                vertical: false,
              ),
            ),
            if (userResponse != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  userInsight,
                  style: TextStyle(
                      color: Colors.black87, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildNumericStats(String key, String title) {
    final values = allResponses
        .map((doc) => int.tryParse(doc.data()[key]?.toString() ?? ''))
        .where((v) => v != null)
        .map((e) => e!)
        .toList();

    if (values.isEmpty) return SizedBox();

    final avg =
        (values.reduce((a, b) => a + b) / values.length).toStringAsFixed(0);
    final userValueRaw = userResponse?[key];
    final userValue = int.tryParse(userValueRaw?.toString() ?? '');

    return Card(
      color: Colors.white,
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 300,
        width: double.infinity, // Take full width like other charts
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16)),
            SizedBox(height: 20),
            Text("Average value among users: $avg",
                style: TextStyle(color: Colors.black, fontSize: 14)),
            if (userValue != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "You reported: $userValue",
                  style: TextStyle(
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                      fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade400, Colors.blue.shade700],
          ),
        ),
        child: allResponses.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stacked_line_chart_outlined,
                              color: Colors.white, size: 30),
                          SizedBox(width: 10),
                          Text(
                            "Analytics",
                            style: TextStyle(
                              fontSize: screenHeight * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.bar_chart_outlined,
                              color: Colors.white, size: 30),
                        ],
                      ),
                    ),
                    buildBarChart('hair growth(Y/N)', 'Hair Growth'),
                    buildBarChart('Pimples(Y/N)', 'Pimples'),
                    buildBarChart('Hair loss(Y/N)', 'Hair Loss'),
                    buildBarChart('Weight gain(Y/N)', 'Weight Gain'),
                    buildBarChart('Skin darkening (Y/N)', 'Skin Darkening'),
                    buildBarChart('Fast food (Y/N)', 'Fast Food Consumption'),
                    buildBarChart('Reg.Exercise(Y/N)', 'Regular Exercise'),
                    buildBarChart('Pregnant(Y/N)', 'Pregnancy'),
                    buildNumericStats(
                        'Cycle length(days)', 'Cycle Length (in days)'),
                    buildNumericStats(
                        'No. of aborptions', 'Number of Abortions'),
                    SizedBox(height: screenHeight * 0.02),
                    if (userResponse == null)
                      Center(
                        child: Text(
                          "Submit your information to view your personal analytics.",
                          style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}
