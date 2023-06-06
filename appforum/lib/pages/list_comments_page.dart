import 'package:appforum/models/post_model.dart';
import 'package:flutter/material.dart';

import '../models/comment_model.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';
import '../services/comment_service.dart';
import '../services/post_service.dart';
import '../services/shared_service.dart';
import '../services/user_service.dart';

class ListCommentsPage extends StatefulWidget {
  final int postId;
  const ListCommentsPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<ListCommentsPage> createState() => _ListCommentsPageState();
}

class _ListCommentsPageState extends State<ListCommentsPage> {
  List<CommentModel> comments = [];
  CommentService commentService = CommentService();
  TextEditingController commentController = TextEditingController();
  late bool isEdited;
  late int editedCommentIndex;
  int _userId = 0;
  bool _isAdmin = false;
  PostModel _post = PostModel(title: '', message: '');

  @override
  void initState() {
    super.initState();
    fetchComments();
    _getUserProfile();
    _fetchPostDetails();
    isEdited = false;
    editedCommentIndex = -1;
  }

  Future<void> _getUserProfile() async {
    LoginResponseModel? user = await SharedService.loginDetails();
    if (user != null) {
      setState(() {
        _userId = user.idUser;
        _isAdmin = user.isAdmin;
      });
    }
  }

  Future<void> fetchComments() async {
    try {
      final fetchedComments = await commentService.getComments(widget.postId);
      setState(() {
        comments = fetchedComments;
      });
    } catch (error) {
      print('Failed to fetch comments: $error');
    }
  }

  Future<String?> getUserById(int? idUser) async {
    try {
      final userService = UserService();
      UserModel? user = await userService.getUserById(idUser);

      if (user != null) {
        String? username = user.username;
        return username;
      } else {
        return null;
      }
    } catch (e) {
      // Gérer l'erreur
      print('Error: $e');
      return null;
    }
  }

  Future<void> addComment() async {
    if (commentController.text.isEmpty) {
      return;
    }

    final newComment =
        CommentModel(comment: commentController.text, idPost: widget.postId);

    try {
      await commentService.addComment(newComment);
      commentController.clear();

      setState(() {
        fetchComments();
      });
    } catch (error) {
      print('Failed to add comment: $error');
      // Gérer l'erreur d'ajout de commentaire ici
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      await commentService.deleteComment(commentId);
      fetchComments();
    } catch (error) {
      print('Impossible de supprimer le commentaire: $error');
      // Gérer l'erreur de suppression de commentaire ici
    }
  }

  void editComment(int index) {
    setState(() {
      isEdited = true;
      editedCommentIndex = index;
      commentController.text = comments[index].comment;
    });
  }

  Future<void> saveEditedComment(int commentId) async {
    final editedComment = CommentModel(
      idComment: commentId,
      comment: commentController.text,
    );

    try {
      await commentService.editComment(commentId, editedComment);
      setState(() {
        isEdited = false;
        editedCommentIndex = -1;
        commentController.clear();
        fetchComments();
      });
    } catch (error) {
      print('Erreur lors de la modification du commentaire: $error');
      // Gérer l'erreur de modification de commentaire ici
    }
  }

  Future<void> _fetchPostDetails() async {
    try {
      final postService = PostService();
      final post = await postService.getPostDetails(widget.postId);
      setState(() {
        _post = post;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_post.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Card(
                  child: ListTile(
                    title: isEdited && editedCommentIndex == index
                        ? TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'Modifier le commentaire...',
                            ),
                          )
                        : Text(comment.comment),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String?>(
                          future: getUserById(comment.idUser),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String username = snapshot.data!;
                              return Text(
                                'Ajouté par $username',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Text(
                                'Erreur lors de la récupération de l\'utilisateur',
                                style: TextStyle(fontSize: 10),
                              );
                            } else {
                              return const Text(
                                'Chargement de l\'utilisateur...',
                                style: TextStyle(fontSize: 10),
                              );
                            }
                          },
                        ),
                        Text(
                          'Date d\'ajout: ${comment.createdAt}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_userId == comment.idUser)
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                isEdited = true;
                                editedCommentIndex = index;
                                commentController.text = comment.comment;
                              });
                            },
                          ),
                        if (_isAdmin || _userId == comment.idUser)
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
                                        'Êtes-vous sûr de vouloir supprimer ce commentaire ?'),
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
                                          deleteComment(comment.idComment!);
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    enabled: !isEdited,
                    decoration: const InputDecoration(
                      hintText: 'Ajouter un commentaire...',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isEdited
                      ? () => saveEditedComment(
                          comments[editedCommentIndex].idComment!)
                      : addComment,
                  child: Text(isEdited ? 'Enregistrer' : 'Ajouter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
