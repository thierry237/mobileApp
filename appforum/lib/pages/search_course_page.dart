import 'package:flutter/material.dart';
import '../services/course_service.dart';
import '../models/course_model.dart';
import '../services/shared_service.dart';

class SearchCoursePage extends StatefulWidget {
  const SearchCoursePage({Key? key}) : super(key: key);

  @override
  _SearchCoursePageState createState() => _SearchCoursePageState();
}

class _SearchCoursePageState extends State<SearchCoursePage> {
  final TextEditingController _searchController = TextEditingController();
  CourseModel? _searchResult;
  bool _isLoading = false;

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    String query = _searchController.text;

    try {
      CourseModel result = await CourseService().searchCourse(query);
      setState(() {
        _searchResult = result;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _searchResult = null;
        _isLoading = false;
      });
      print('Failed to search course: $error');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche de cours'),
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
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pushNamed(context, "/home");
              },
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchResult = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'Recherche',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : _searchResult != null
                  ? ListTile(
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
                                title: Text(_searchResult!.name),
                                content: Text(_searchResult!.description),
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
                      title: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/list-posts',
                              arguments: _searchResult!.idCourse);
                        },
                        child: Text(
                          _searchResult!.name,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre de posts : ${_searchResult!.posts?.length}',
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Ajouté le ${_searchResult!.createdAt}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    )
                  : Container(),
        ],
      ),
    );
  }
}
