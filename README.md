# instamojodemo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StepperViewPage(),
    );
  }
}

class StepperViewPage extends StatefulWidget {
  @override
  _StepperViewPageState createState() => _StepperViewPageState();
}

class _StepperViewPageState extends State<StepperViewPage> {
  // Example dynamic data list
  final List<Map<String, String>> records = [
    {
      'visitDate': '12/09/2024',
      'nextVisitDate': '12/09/2024',
      'details': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
    },
    {
      'visitDate': '15/10/2024',
      'nextVisitDate': '20/10/2024',
      'details': 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    },
    // Add more records dynamically
  ];

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Stepper View'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (int step) {
          setState(() {
            _currentStep = step;
          });
        },
        onStepContinue: () {
          if (_currentStep < records.length - 1) {
            setState(() {
              _currentStep++;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        steps: records.map((record) {
          return Step(
            title: Text('Visit Date: ${record['visitDate']}'),
            subtitle: Text('Next Visit Date: ${record['nextVisitDate']}'),
            content: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(record['details']!),
              ),
            ),
            isActive: records.indexOf(record) <= _currentStep,
            state: records.indexOf(record) == _currentStep
                ? StepState.editing
                : StepState.indexed,
          );
        }).toList(),
      ),
    );
  }
}
