import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class EditCoursePage extends StatefulWidget {
  final int courseId;

  const EditCoursePage({Key? key, required this.courseId}) : super(key: key);

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  CourseModel _course = CourseModel(name: '', description: '');
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCourseDetails();
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
        _descriptionController.text = _course.description;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCourseChanges() async {
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
    final courseService = CourseService();
    bool courseExists = await courseService.checkCourseExists(_course);

    if (courseExists) {
      // Show an error message indicating that the course already exists
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
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

    // Save the changes
    try {
      await courseService.editCourse(widget.courseId, _course);

      // Show a success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Cours modifié avec succès.'),
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
          title: const Text('Error'),
          content: const Text('Failed to save course changes.'),
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
        title: const Text('Modifier Cours'),
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
                    initialValue: _course.name,
                    decoration: const InputDecoration(
                      labelText: 'Cours',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _course = CourseModel(
                            name: value, description: _course.description);
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
                        _course =
                            CourseModel(name: _course.name, description: value);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveCourseChanges,
                    child: const Text('Valider'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/home'); // Redirige vers la page d'accueil
                    },
                    child: const Text('Annuler'),
                  ),
                ],
              ),
            ),
    );
  }
}
