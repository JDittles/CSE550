import 'package:flutter/material.dart';
import 'package:medication_management_module/medication_management_module.dart'; // Import the module

class MedManage extends StatefulWidget {
  const MedManage({super.key, required this.title});

  final String title; // Immutable configuration parameter

  @override
  // Creates the mutable state associated with this widget
  State<MedManage> createState() => _MedPageState();
}

// Implementation of the MyHomePage widget's state and UI
// LEARN: State objects contain mutable data that can change during widget lifetime
class _MedPageState extends State<MedManage> {
  int _totalMedications = 0; // Private mutable state variable

  @override
  Widget build(BuildContext context) {
    // Scaffold implements the basic material design layout structure
    return Scaffold(
      // App header with title
      appBar: AppBar(
        // Uses theme colors for consistent appearance
        backgroundColor: AppColors.white,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ), // Accesses parent widget's immutable properties with 'widget.'
      ),

      // Main content area with counter and medication module
      body: Center(
        child: Column(
          // Aligns children at the top of the available space
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20), // Optional top padding
            Text(
              "Hi John, You have $_totalMedications medication(s) scheduled today",
            ),
            const SizedBox(height: 20),

            // Integration point for Medication Management Module
            // LEARN: This demonstrates modular architecture with external packages
            // LEARN: The module is a self-contained widget that can be reused in other apps
            MedicationModuleWidget(
              onMedicationCountChanged: (count) {
                setState(() {
                  _totalMedications = count;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}