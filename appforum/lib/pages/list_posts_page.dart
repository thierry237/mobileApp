import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../models/login_response_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../services/course_service.dart';
import '../services/post_service.dart';
import '../services/shared_service.dart';

class ListPostsPage extends StatefulWidget {
  final int courseId;
  const ListPostsPage({Key? key, required this.courseId}) : super(key: key);

  @override
  State<ListPostsPage> createState() => _ListPostsPageState();
}

class _ListPostsPageState extends State<ListPostsPage> {
  late List<PostModel> _posts = [];
  CourseModel _course = CourseModel(name: '', description: '');
  late bool _isLoading;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getUserProfile();
    _fetchCourseDetails();
    _fetchPosts();
  }

  int _userId = 0;
  bool _isAdmin = false;

  Future<void> _getUserProfile() async {
    LoginResponseModel? user = await SharedService.loginDetails();
    if (user != null) {
      setState(() {
        _userId = user.idUser;
        _isAdmin = user.isAdmin;
      });
    }
  }

  Future<void> _fetchCourseDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final courseService = CourseService();
      final course = await courseService.getCourseDetails(widget.courseId);
      setState(() {
        _course = course;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPosts() async {
    try {
      final postService = PostService();
      final posts = await postService.getPosts(widget.courseId);
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deletePostAndRefresh(int postId) async {
    try {
      final postService = PostService();
      await postService.deletePost(postId);
      _fetchPosts();
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_course.name),
            const Text('Posts'),
          ],
        ),
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
              title: const Text('Ajouter un post'),
              onTap: () {
                Navigator.pushNamed(context, "/add-post",
                    arguments: widget.courseId);
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(post.title),
                              content: Text(post.message),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
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
                        // Action à effectuer lors du clic sur le lien
                        // Par exemple, naviguer vers une page détaillée du cours
                        Navigator.pushNamed(context, '/list-comments',
                            arguments: post.idPost);
                      },
                      child: Text(
                        post.title,
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
                          'Posté le ${post.createdAt ?? 'N/A'}',
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          'Par ${post.createdAt ?? 'N/A'}',
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          'Nombre de commentaires : ${post.idUser}',
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_userId == post.idUser)
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/edit-post',
                                arguments: post.idPost,
                              );
                            },
                          ),
                        if (_isAdmin || _userId == post.idUser)
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
                                        'Êtes-vous sûr de vouloir supprimer cette publication ?'),
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
                                          _deletePostAndRefresh(post.idPost!);
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
                );
              },
            ),
    );
  }
}
