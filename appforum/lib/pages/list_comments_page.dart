import 'package:flutter/material.dart';

import '../models/comment_model.dart';
import '../services/comment_service.dart';

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

  @override
  void initState() {
    super.initState();
    fetchComments();
    isEdited = false;
    editedCommentIndex = -1;
  }

  Future<void> fetchComments() async {
    try {
      final fetchedComments = await commentService.getComments(widget.postId);
      setState(() {
        comments = fetchedComments;
      });
    } catch (error) {
      print('Failed to fetch comments: $error');
      // Gérer l'erreur de récupération des commentaires ici
    }
  }

  Future<void> addComment() async {
    if (commentController.text.isEmpty) {
      return;
    }

    print(widget.postId);

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
      print('Failed to delete comment: $error');
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
      print('Failed to edit comment: $error');
      // Gérer l'erreur de modification de commentaire ici
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des commentaires'),
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
                        Text(
                          'Ajouté par: ${comment.idUser}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Date d\'ajout: ${comment.createdAt}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEdited = true;
                              editedCommentIndex = index;
                              commentController.text = comment.comment;
                            });
                          },
                        ),
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
