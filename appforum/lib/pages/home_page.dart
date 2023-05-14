import 'package:appforum/models/login_response_model.dart';
import 'package:appforum/services/course_service.dart';
import 'package:appforum/services/shared_service.dart';
import 'package:flutter/material.dart';

import '../models/course_model.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

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
  bool _isAdmin = false;

  Future<void> _getUserProfile() async {
    LoginResponseModel? user = await SharedService.loginDetails();
    if (user != null) {
      setState(() {
        _userProfile = user.username;
        _isAdmin = user.isAdmin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userProfile),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Action à effectuer lorsque l'icône est cliquée
              // Ajoutez ici la navigation vers la page de modification de profil
            },
          ),
        ],
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
            if (_isAdmin)
              ListTile(
                title: const Text('Ajouter cours'),
                onTap: () {
                  Navigator.pushNamed(context, "/add-course");
                },
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
    _getUserProfile();
    _coursesFuture = CourseService().getCourses();
  }

  bool _isAdmin = false;
  Future<void> _getUserProfile() async {
    LoginResponseModel? user = await SharedService.loginDetails();
    if (user != null) {
      setState(() {
        _isAdmin = user.isAdmin;
      });
    }
  }

  Future<void> _deleteCourseAndRefresh(int courseId) async {
    try {
      await CourseService().deleteCourse(courseId);
      setState(() {
        _coursesFuture = CourseService().getCourses();
      });
    } catch (error) {
      // Gérer l'erreur
      print('Échec de la suppression du cours : $error');
    }
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
                          icon: const Icon(
                            Icons.info,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            // Afficher la description du cours
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(course.name),
                                  content: Text(course.description),
                                  actions: [
                                    TextButton(
                                      child: const Text('ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        title: Text(course.name),
                        subtitle: Text('Ajouté le ${course.createdAt}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isAdmin)
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                onPressed: () {
                                  Navigator.popAndPushNamed(
                                      context, '/edit-course',
                                      arguments: course.idCourse);
                                },
                              ),
                            if (_isAdmin)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Êtes-vous sûr de vouloir supprimer ce cours ?'),
                                        actions: [
                                          TextButton(
                                            child: const Text('Annuler'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Supprimer'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _deleteCourseAndRefresh(
                                                  course.idCourse!);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
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

class UserPage extends StatefulWidget {
  const UserPage({Key? key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    LoginResponseModel? user = await SharedService.loginDetails();
    if (user != null) {
      setState(() {
        _isAdmin = user.isAdmin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Action de recherche
              // _performSearch();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: UserService().getUsers(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<UserModel> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final UserModel user = users[index];
                return Card(
                  child: ListTile(
                    title: Text('${user.firstname} ${user.lastname}'),
                    subtitle: Text('Date d\'inscription: ${user.createdAt}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isAdmin)
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Action de suppression de l'utilisateur
                              // _deleteUser(user);
                            },
                          ),
                        if (_isAdmin)
                          IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () {
                              // Action d'ajout en tant qu'administrateur
                              // _makeAdmin(user);
                            },
                          ),
                      ],
                    ),
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
