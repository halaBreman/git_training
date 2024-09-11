import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../component/logo.dart';
import '../component/material_button.dart';
import '../component/textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController passWord = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser == null){
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("HomePage", (route) => false);

  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    passWord.dispose();
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
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("Login to continue using the app"),
                  const SizedBox(
                    height: 10,
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
                  InkWell(
                    onTap: () async {
                      if(email.text == ""){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Erorr',
                          desc: 'الرجاء تعبئة حقل البريد الإلكتروني',
                        ).show();
                        return;
                      }
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Done',
                        desc: 'تم إرسال رسالة إلى بريدك الإلكتروني',
                      ).show();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forget Password?",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomMaterialButton(
              isLoading: isLoading,
              text: 'Login',
              onPressed: () async {
                if(formState.currentState!.validate()) {
                    try {
                        isLoading=true;
                        setState(() {
                        });
                      final credential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email.text,
                        password: passWord.text,
                      );
                        isLoading=false;
                        setState(() {
                        });
                      if(credential.user!.emailVerified){
                        Navigator.of(context).pushReplacementNamed("HomePage");
                      } else {
                        isLoading=false;
                        setState(() {
                        });
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'please check Your email',
                        ).show();
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        isLoading=false;
                        setState(() {
                        });
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'No user found for that email',
                        ).show();
                      } else if (e.code == 'wrong-password') {
                        isLoading=false;
                        setState(() {
                        });
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Wrong password provided for that user.',
                        ).show();
                      } else {
                        {
                          isLoading=false;
                          setState(() {
                          });
                          print(e);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: '$e',
                          ).show();
                        }
                      }
                    }
                  } else {
                  print("Not Valid");
                }
              },
            ),
            Container(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                signInWithGoogle();
              },
              textColor: Colors.white,
              color: Colors.grey.shade600,
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text("Login With Google"),
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't Have An Account?"),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("SignUp");
                  },
                  child: Text(
                    "  Register",
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
