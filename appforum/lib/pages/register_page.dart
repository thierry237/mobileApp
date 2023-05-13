import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../config.dart';
import '../models/register_request_model.dart';
import '../services/api_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? lastname;
  String? firstname;
  String? username;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 3,
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
                    'Appforum',
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
            child: Text(
              'Inscription',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          FormHelper.inputFieldWidget(
            context,
            "lastname",
            "Nom",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'lastname can\'t be empty.';
              }

              return null;
            },
            (onSavedVal) => {
              lastname = onSavedVal,
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
              "firstname",
              "Prénom",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'firstbame can\'t be empty.';
                }

                return null;
              },
              (onSavedVal) => {
                firstname = onSavedVal,
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FormHelper.inputFieldWidget(
              context,
              "username",
              "Nom d'utilisateur",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'username can\'t be empty.';
                }
                if (onValidateVal.length <= 3 || onValidateVal.length >= 14) {
                  return 'minimum 3 à 13 caractères requis ';
                }

                return null;
              },
              (onSavedVal) => {
                username = onSavedVal,
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FormHelper.inputFieldWidget(
              context,
              "email",
              "Adresse email",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'email requis.';
                }
                final emailRegex =
                    RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
                if (!emailRegex.hasMatch(onValidateVal)) {
                  return 'format email incorrect ';
                }

                return null;
              },
              (onSavedVal) => {
                email = onSavedVal,
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: FormHelper.inputFieldWidget(
                context, "password", "mot de passe", (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'mot de passe requis.';
              }
              if (onValidateVal.length <= 4 || onValidateVal.length >= 8) {
                return 'mot de passe entre 4 et 8 caractères.';
              }

              return null;
            },
                (onSavedVal) => {
                      password = onSavedVal,
                    },
                borderFocusColor: Colors.white,
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                borderRadius: 10,
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: FormHelper.submitButton(
              "S'inscrire",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });

                  RegisterRequestModel model = RegisterRequestModel(
                      lastname: lastname!,
                      firstname: firstname!,
                      username: username!,
                      email: email!,
                      password: password!);
                  APIService.register(model).then((response) {
                    // ignore: unnecessary_null_comparison
                    if (response.idUser! != null) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "Inscription réussie, connectez-vous à votre compte",
                        "OK",
                        () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (route) => false);
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "email existe déjà",
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
                      "email existe déjà",
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
                    text: 'Accueil',
                    style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/');
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
