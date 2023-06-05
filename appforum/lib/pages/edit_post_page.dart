import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class EditPostPage extends StatefulWidget {
  final int postId;

  const EditPostPage({Key? key, required this.postId}) : super(key: key);

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  PostModel _post = PostModel(title: '', message: '');
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  int courseId = 0;

  @override
  void initState() {
    super.initState();
    _fetchPostDetails();
  }

  Future<void> _fetchPostDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final postService = PostService();
      final post = await postService.getPostDetails(widget.postId);
      setState(() {
        _post = post;
        courseId = _post.idCourse!;
        _messageController.text = _post.message;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _savePostChanges(int idCourse) async {
    // Validate the course details
    if (_post.title.isEmpty || _post.message.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Veuillez remplir tous les champs obligatoires'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Save the changes
    try {
      final postService = PostService();
      await postService.editPost(widget.postId, _post);

      // Show a success dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Post modifié'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/list-posts',
                  arguments: idCourse),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Impossible de modifier le post.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Post'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: _post.title,
                    decoration: const InputDecoration(
                      labelText: 'Post',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _post = PostModel(title: value, message: _post.message);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Question:',
                    ),
                    minLines: 3,
                    maxLines: 6,
                    onChanged: (value) {
                      setState(() {
                        _post = PostModel(title: _post.title, message: value);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _savePostChanges(courseId);
                    },
                    child: const Text('Valider'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Annuler'),
                  ),
                ],
              ),
            ),
    );
  }
}
