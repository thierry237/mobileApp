import 'package:appforum/models/login_response_model.dart';
import 'package:appforum/services/course_service.dart';
import 'package:appforum/services/shared_service.dart';
import 'package:flutter/material.dart';

import '../models/course_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    CourseListPage(),
    const UserPage(),
  ];

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  String _userProfile = '';

  Future<void> _getUserProfile() async {
    LoginResponseModel? user = await SharedService.loginDetails();
    if (user != null) {
      setState(() {
        _userProfile = user.username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userProfile),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Cours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Utilisateurs',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Ajouter cours'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Rechercher'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Se déconnecter'),
              onTap: () {
                SharedService.logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class CourseListPage extends StatefulWidget {
  const CourseListPage({Key? key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  late Future<List<CourseModel>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = CourseService().getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cours'),
      ),
      body: FutureBuilder<List<CourseModel>>(
        future: _coursesFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<CourseModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (BuildContext context, int index) {
                final course = courses[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            // Afficher la description du cours
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(course.name),
                                  content: Text(course.description),
                                );
                              },
                            );
                          },
                        ),
                        title: Text(course.name),
                        subtitle: Text(course.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Action de modification du cours
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Action de suppression du cours
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
      ),
      body: const Center(
        child: Text('Page des utilisateurs'),
      ),
    );
  }
}
