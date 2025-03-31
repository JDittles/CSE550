import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';               // new
// import 'package:my_flutter_app/screens/med_manage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:medication_management_module/medication_management_module.dart'; // Import the module
import 'package:provider/provider.dart'; // Import provider for state management

import 'app_state.dart'; // Import the app state management
import 'home_page.dart'; // Import the home page
import 'screens/user_profile_screen.dart';
import 'screens/med_manage.dart';

// Define a library of colors for easy reference
class AppColors {
  static const Color offBlue = Color(0xFFE0F7FA);
  static const Color deepBlues = Color(0xFF2C3E50);
  static const Color getItGreen = Color(0xFF76C7C0);
  static const Color urgentOrange = Color(0xFFF4A261);
  static const Color white = Color(0xFFFFFFFF);
  // Add more colors as needed
}

// Main entry point for the application
// LEARN: Flutter uses a single main() function as the application entry point
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  )); // Wraps the app with a provider for state management
}

// Root widget that configures the overall app theme and initial route
// LEARN: StatelessWidget is used for UI components that don't change state internally
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  }); // Constructor with const for widget caching optimization

  //
  @override
  Widget build(BuildContext context) {
    // MaterialApp provides the foundation for material design and navigation
    return MaterialApp.router(
      title: 'Medication Tracker', // App name shown in task switchers
      theme: ThemeData(
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: AppColors.deepBlues,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.deepBlues,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18.0,
            color: AppColors.deepBlues,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2C3E50)),
      ),
      routerConfig: _router,
      //home: const MyHomePage(title: 'Medication Tracker'), // Initial route
    );
  }
}

// Primary screen widget that can maintain state
// LEARN: StatefulWidget separates widget configuration from mutable state
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title; // Immutable configuration parameter

//   @override
//   // Creates the mutable state associated with this widget
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// // Implementation of the MyHomePage widget's state and UI
// // LEARN: State objects contain mutable data that can change during widget lifetime
// class _MyHomePageState extends State<MyHomePage> {
//   int _totalMedications = 0; // Private mutable state variable

//   @override
//   Widget build(BuildContext context) {
//     // Scaffold implements the basic material design layout structure
//     return Scaffold(
//       // App header with title
//       appBar: AppBar(
//         // Uses theme colors for consistent appearance
//         backgroundColor: AppColors.white,
//         title: Text(
//           widget.title,
//           style: Theme.of(context).textTheme.headlineMedium,
//         ), // Accesses parent widget's immutable properties with 'widget.'
//       ),

//       // Main content area with counter and medication module
//       body: Center(
//         child: Column(
//           // Aligns children at the top of the available space
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             const SizedBox(height: 20), // Optional top padding
//             Text(
//               "Hi John, You have $_totalMedications medication(s) scheduled today",
//             ),
//             const SizedBox(height: 20),

//             // Integration point for Medication Management Module
//             // LEARN: This demonstrates modular architecture with external packages
//             // LEARN: The module is a self-contained widget that can be reused in other apps
//             MedicationModuleWidget(
//               onMedicationCountChanged: (count) {
//                 setState(() {
//                   _totalMedications = count;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//configure "go_router" for navigation through pre-made login flow
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.pushReplacement('/');
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/screens/user_profile_screen',
      builder: (context, state) => UserProfileScreen(),
    ),
    GoRoute(
      path: '/screens/med_manage',
      builder: (context, state) => MedManage(title: 'Medications')
    ),
  ],
);