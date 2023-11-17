import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../utils/utils.dart';
import '../widgets/custom_buttons.dart';

import '../widgets/custom_text_field.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  void signupUser() {
    setState(
      () {
        loading = true;
      },
    );
    _auth
        .createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((value) {
      setState(
        () {
          loading = false;
        },
      );
      NormalUtils().toastMessage(
        'User Registered!',
      );
    }).onError(
      (error, stackTrace) {
        setState(
          () {
            loading = false;
          },
        );
        Utils().toastMessage(
          error.toString(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 85.0,
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextField(
                    hintText: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    keyboardType: TextInputType.multiline,
                    // isVisable: !iconVisibilityProvider.isVisable,
                    icon: IconButton(
                      onPressed: () {
                        // iconVisibilityProvider.toggleVisibilty();
                      },
                      icon: const Icon(
                          // iconVisibilityProvider.isVisable
                          Icons.visibility_rounded
                          // : Icons.visibility_off_rounded,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    loading: loading,
                    onTap: () {
                      signupUser();
                    },
                    title: 'Sign up',
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          color: myBlackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Login Now',
                        style: GoogleFonts.urbanist(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
