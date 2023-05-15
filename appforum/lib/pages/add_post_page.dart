import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

class AddPostPage extends StatefulWidget {
  final int courseId;
  const AddPostPage({Key? key, required this.courseId}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _messageController = TextEditingController();
  late PostModel _post;

  @override
  void initState() {
    super.initState();
    _post = PostModel(
      title: '',
      message: '',
      idCourse: 0,
    );
  }

  Future<void> _savePost(BuildContext context) async {
    // Validate the course details
    if (_post.title.isEmpty || _post.message.isEmpty) {
      // Show an error message indicating that the required fields are empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all the required fields.'),
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

    print('save-post');
    print(_post.title);
    print(_post.message);
    print(_post.idCourse);

    // Save the new course
    try {
      final postService = PostService();
      await postService.addPost(_post);

      // Show a success dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('New post added successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/list-posts',
                  arguments: widget.courseId),
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
          content: const Text('Failed to add new Post.'),
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
        title: const Text('Ajouter un Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Post',
              ),
              onChanged: (value) {
                setState(() {
                  _post = PostModel(
                    title: value,
                    message: _post.message,
                    idCourse: widget.courseId,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Question',
              ),
              minLines: 3,
              maxLines: 6,
              onChanged: (value) {
                setState(() {
                  _post = PostModel(
                    title: _post.title,
                    message: value,
                    idCourse: widget.courseId,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _savePost(context),
              child: const Text('Enregistrer'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list-posts',
                    arguments: widget.courseId);
              },
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
