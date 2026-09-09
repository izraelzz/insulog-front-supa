import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insulog/screens/clock_record_form_screen.dart';
import 'package:insulog/widgets/app_shell.dart';
import 'package:insulog/screens/glucose_record_form_screen.dart';
import 'package:insulog/screens/login.dart';
import 'package:insulog/screens/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF3EA75F),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color.fromARGB(255, 255, 255, 255),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF3EA75F),
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const AppShell(),
        '/login': (context) =>  LoginScreen(),
        '/register': (context) =>  Register(),
        '/glucoseRecordForm': (context) => const GlucoseRecordFormScreen(),
        '/clock_register': (context) => const ClockRegisterScreen(),
      },
    );
  }
}
