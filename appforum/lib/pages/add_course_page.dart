import 'dart:convert';

import 'package:appforum/models/course_model.dart';
import 'package:appforum/pages/home_page.dart';
import 'package:appforum/services/course_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../config.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? name;
  String? description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _addCourse(context),
          ),
        ),
      ),
    );
  }

  Widget _addCourse(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Ajouter Cours',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              bottom: 30,
              top: 50,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.book,
                  size: 24,
                  color: Colors.yellowAccent,
                ),
                SizedBox(width: 10), // Espace entre l'icône et le texte
                Text(
                  'Nouveau Cours',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          FormHelper.inputFieldWidget(
            context,
            "name",
            "Nom du cours",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'name course can\'t be empty.';
              }

              return null;
            },
            (onSavedVal) => {
              name = onSavedVal,
            },
            obscureText: false,
            borderFocusColor: Colors.white,
            prefixIconColor: Colors.white,
            borderColor: Colors.white,
            textColor: Colors.white,
            hintColor: Colors.white.withOpacity(0.7),
            borderRadius: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FormHelper.inputFieldWidget(
              context,
              "description",
              "Description",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'description can\'t be empty.';
                }

                return null;
              },
              (onSavedVal) => {
                description = onSavedVal,
              },
              obscureText: false,
              borderFocusColor: Colors.white,
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.7),
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "Ajouter",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });

                  CourseModel model = CourseModel(
                    name: name!,
                    description: description!,
                  );
                  CourseService().addCourse(model).then((response) {
                    Map<String, dynamic> jsonResponse = jsonDecode(response);
                    String message = jsonResponse['message'];
                    if (message == 'Course created successfully.') {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "Ajout réussi, retour à liste des cours",
                        "OK",
                        () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false);
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "cours existe déjà",
                        "OK",
                        () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  }).catchError((onError) {
                    FormHelper.showSimpleAlertDialog(
                      context,
                      Config.appName,
                      "Une erreur s'est produite lors de l'ajout du cours",
                      "OK",
                      () {
                        Navigator.pop(context);
                      },
                    );
                  });
                }
              },
              btnColor: Colors.blue,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 10,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'OU',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Retour aux cours',
                    style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/home');
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if ((form!.validate())) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
