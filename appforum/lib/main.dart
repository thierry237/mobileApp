import 'package:appforum/pages/add_course_page.dart';
import 'package:appforum/pages/edit_course_page.dart';
import 'package:appforum/pages/home_page.dart';
import 'package:appforum/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

Widget defaultHome = const LoginPage();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppForum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => defaultHome,
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        "/add-course": (context) => const AddCoursePage(),
        "/edit-course": (context) => EditCoursePage(
              courseId: ModalRoute.of(context)?.settings.arguments as int,
            ),
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool result = await SharedService.isLoggedIn();
  if (result) {
    defaultHome = const HomePage();
  } else {
    defaultHome = const LoginPage();
  }
  runApp(const MyApp());
}
