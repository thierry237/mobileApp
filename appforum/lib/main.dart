import 'package:appforum/pages/add_course_page.dart';
import 'package:appforum/pages/add_post_page.dart';
import 'package:appforum/pages/edit_course_page.dart';
import 'package:appforum/pages/edit_post_page.dart';
import 'package:appforum/pages/home_page.dart';
import 'package:appforum/pages/list_comments_page.dart';
import 'package:appforum/pages/list_posts_page.dart';
import 'package:appforum/pages/search_course_page.dart';
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
        "/add-course": (context) => AddCoursePage(),
        "/search-course": (context) => const SearchCoursePage(),
        "/edit-course": (context) => EditCoursePage(
              courseId: ModalRoute.of(context)?.settings.arguments as int,
            ),
        "/list-posts": (context) => ListPostsPage(
              courseId: ModalRoute.of(context)?.settings.arguments as int,
            ),
        "/edit-post": (context) => EditPostPage(
              postId: ModalRoute.of(context)?.settings.arguments as int,
            ),
        "/list-comments": (context) => ListCommentsPage(
              postId: ModalRoute.of(context)?.settings.arguments as int,
            ),
        "/add-post": (context) => AddPostPage(
              courseId: ModalRoute.of(context)?.settings.arguments as int,
            ),
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //garantie que les liaisons flutter sont initialisées
  bool result = await SharedService.isLoggedIn();
  if (result) {
    defaultHome = const HomePage();
  } else {
    defaultHome = const LoginPage();
  }
  runApp(const MyApp());
}
