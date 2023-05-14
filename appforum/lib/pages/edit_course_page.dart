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
  bool _isLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCourseDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
        _nameController.text = _course.name;
        _descriptionController.text = _course.description;
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

    // Save the changes
    try {
      final courseService = CourseService();
      await courseService.editCourse(widget.courseId, _course);

      // Show a success dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Course changes saved successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
        title: const Text('Edit Course'),
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
                    initialValue: _nameController.text,
                    decoration: const InputDecoration(
                      labelText: 'Course Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _course.name = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _descriptionController.text,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _course.description = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveCourseChanges,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
