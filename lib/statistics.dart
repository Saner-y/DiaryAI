import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodChartPage extends StatefulWidget {
  @override
  _MoodChartPageState createState() => _MoodChartPageState();
}

class _MoodChartPageState extends State<MoodChartPage> {
  Map<String, double> moodCounts = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('notes')
          .get();

      Map<String, double> tempMoodCounts = {};
      snapshot.docs.forEach((doc) {
        List<dynamic> sentimentScores = doc['sentimentScores'];
        sentimentScores.forEach((score) {
          String label = score['label'];
          double scoreValue = score['score'].toDouble();
          if (tempMoodCounts[label] == null) {
            tempMoodCounts[label] = scoreValue;
          } else {
            tempMoodCounts[label] = tempMoodCounts[label]! + scoreValue;
          }
        });
      });

      setState(() {
        moodCounts = tempMoodCounts;
      });
    }
  }
  String transformLabel(String originalLabel) {
    switch (originalLabel) {
      case 'joy':
        return 'Mutlu';
      case 'sadness':
        return 'Üzgün';
      case 'anger':
        return 'Sinirli';
      case 'fear':
        return 'Korkmuş';
      case 'surprise':
        return 'Şaşırmış';
      case 'love':
        return 'Aşık';
      default:
        return originalLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total count
    double totalCount = moodCounts.isNotEmpty ? moodCounts.values.reduce((a, b) => a + b) : 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 39, 81),
        iconTheme: IconThemeData(color: Colors.white,size: 48),
        title: Text('İstatistikler',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: Color.fromARGB(255, 40, 39, 81),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5, // 50% of the screen height
            width: MediaQuery.of(context).size.width * 0.8, // 80% of the screen width
            child: (totalCount > 0)
                ? PieChart(
              PieChartData(
                sectionsSpace: 3, // Add space between sections
                centerSpaceRadius: 50, // Add radius to make it look like a donut chart
                sections: moodCounts.entries.map((entry) {
                  return PieChartSectionData(
                    color: Colors.primaries[moodCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
                    value: entry.value,
                    title: transformLabel(entry.key), // Show label instead of percentage
                    radius: 100, // Increase the radius for larger sections
                    titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Style the title
                  );
                }).toList(),
              ),
            )
                : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}