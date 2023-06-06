import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  CourseModel _course = CourseModel(name: '', description: '');
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _saveCourse(BuildContext context) async {
    // Validate the course details
    if (_course.name.isEmpty || _course.description.isEmpty) {
      // Show an error message indicating that the required fields are empty
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

    // Check if the course already exists
    try {
      final courseService = CourseService();
      bool courseExists = await courseService.checkCourseExists(_course);

      if (courseExists) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Message'),
            content: const Text('Le cours existe déjà.'),
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

      // Save the new course
      await courseService.addCourse(_course);

      // Show a success dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Succès'),
          content: const Text('Cours ajouté avec succès.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
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
          title: const Text('Message'),
          content: const Text('Impossible d\'ajouter le cours'),
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
        title: const Text('Ajouter un cours'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cours',
              ),
              onChanged: (value) {
                setState(() {
                  _course = CourseModel(
                    name: value,
                    description: _course.description,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              minLines: 3,
              maxLines: 6,
              onChanged: (value) {
                setState(() {
                  _course = CourseModel(
                    name: _course.name,
                    description: value,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _saveCourse(context),
              child: const Text('Enregistrer'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
