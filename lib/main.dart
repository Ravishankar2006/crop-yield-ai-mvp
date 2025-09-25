import 'package:flutter/material.dart';

// Import each page from the screens folder.
import 'screens/welcome_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/crop_insights_page.dart';
import 'screens/tasks_page.dart';
import 'screens/diagnosis_page.dart';
import 'screens/financial_page.dart';

void main() => runApp(HarvestProApp());

class HarvestProApp extends StatelessWidget {
  const HarvestProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HarvestPro',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green[800],
        colorScheme: ColorScheme.dark(
          primary: Colors.green[600]!,
          secondary: Colors.green[300]!,
          surface: Colors.grey[900]!,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.green[400],
          unselectedItemColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.black,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: WelcomePage(), // Start with welcome page instead of MainScreen
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final _pages = [
    DashboardPage(),
    CropInsightsPage(),
    TasksPage(),
    DiagnosisPage(),
    FinancialPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (index) => setState(() => _pageIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: "Insights"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Diagnosis"),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Financials")
        ],
        selectedItemColor: Colors.green,
      ),
    );
  }
}
