import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/logo.dart';
import '../component/material_button.dart';
import '../component/textField.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();

  TextEditingController passWord = TextEditingController();

  TextEditingController userName = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    passWord.dispose();
    userName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const CustomLogo(),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("Sign Up to continue using the app"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "User Name",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    validator: (val){
                      if(val == ""){
                        return "can't to be empty";
                      }
                    },
                    hint: 'Enter Your Name',
                    controller: userName,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    validator: (val){
                      if(val == ""){
                        return "can't to be empty";
                      }
                    },
                    hint: 'Enter Your Email',
                    controller: email,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    validator: (val){
                      if(val == ""){
                        return "can't to be empty";
                      }
                    },
                    hint: 'Enter Your PassWord',
                    controller: passWord,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forget Password?",
                    ),
                  ),
                ],
              ),
            ),
            CustomMaterialButton(
              text: 'Sign Up',
              onPressed: () async {
                if(formState.currentState!.validate()){
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: passWord.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.of(context).pushReplacementNamed("Login");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The password provided is too weak',
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The account already exists for that email',
                      ).show();
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            Container(
              height: 20,
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have An Account?"),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("Login");
                  },
                  child: Text(
                    "  Login",
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
