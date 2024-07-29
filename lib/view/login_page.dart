import 'package:chat_app/controller/login_controller.dart';
import 'package:chat_app/helper/login_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../helper/firestore_helper.dart';
import '../model/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final LoginController controller = Get.put(LoginController());

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset(
              "assets/chat.png",
              height: 150,
              width: 150,
            )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: signInFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Welcome back to the app",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffB5B9C0)),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Email Address",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: emailController,
                      onSaved: (val) {
                        email = val;
                      },
                      decoration: InputDecoration(
                        hintText: " Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!value.contains('@gmail.com')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Password",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Obx(
                      () => TextFormField(
                        controller: passwordController,
                        onSaved: (val) {
                          password = val;
                        },
                        decoration: InputDecoration(
                          hintText: " Password",
                          suffixIcon: InkWell(
                            onTap: () {
                              controller.toggle();
                            },
                            child: Icon(controller.isHidden.value
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                        ),
                        obscureText: controller.isHidden.value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blue)),
                        onPressed: () async {
                          if (signInFormKey.currentState!.validate()) {
                            signInFormKey.currentState!.save();

                            Map<String, dynamic> res = await LoginHelper
                                .loginHelper
                                .signIn(email: email!, password: password!);

                            if (res["user"] != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("User Sign In Successfully..."),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );

                              User user = res["user"];

                              UserModel userModel = UserModel(
                                email: user.email!,
                                auth_uid: user.uid,
                                created_at: DateTime.now(),
                              );

                              await FirestoreHelper.firestoreHelper
                                  .insertUser(userModel: userModel);

                              Get.offAndToNamed("/home_page",arguments: res["user"]);

                            } else if (res["error"] != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(res["error"]),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("User Sign In failed..."),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }

                            emailController.clear();
                            passwordController.clear();

                            email = null;
                            password = null;
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child: Text(
                      "---------------- or sign in with ----------------",
                      style: TextStyle(color: Color(0xffB5B9C0)),
                    )),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> res =
                              await LoginHelper.loginHelper.signInWithGoogle();

                          if (res["user"] != null) {
                            final User user = res["user"];
                            final UserModel userModel = UserModel(
                              email: user.email!,
                              auth_uid: user.uid,
                              created_at: DateTime.now(),
                              logged_in_at: DateTime.now(),
                            );

                            await FirestoreHelper.firestoreHelper
                                .insertUser(userModel: userModel);

                            Get.offAndToNamed("/home_page",arguments: res["user"]);
                          } else if (res["error"] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(res["error"]),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("User Sign In failed..."),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xffE2E5E9),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 45),
                                child: Image.asset(
                                  "assets/google.png",
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Continue With Google",
                                style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                        child: GestureDetector(
                      onTap: () {
                        validateAndSignUp();
                      },
                      child: Text(
                        "Create an account",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.blue),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateAndSignUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Sign UP",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Form(
          key: signUpFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!value.contains('@gmail.com')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (val) {
                  email = val;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter email",
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              Obx(
                () => TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password least 8 characters';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    password = val;
                  },
                  obscureText: controller.isHidden.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter password",
                    labelText: "Password",
                    suffixIcon: InkWell(
                      onTap: () {
                        controller.toggle();
                      },
                      child: Icon(controller.isHidden.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  TextButton(
                    child: Text("Sign Up"),
                    onPressed: () async {
                      if (signUpFormKey.currentState!.validate()) {
                        signUpFormKey.currentState!.save();

                        Map<String, dynamic> res = await LoginHelper.loginHelper
                            .signUp(email: email!, password: password!);

                        if (res["user"] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("User Sign Up Successfully..."),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          User user = res["user"];

                          UserModel userModel = UserModel(
                              email: user.email!,
                              auth_uid: user.uid,
                              created_at: DateTime.now());

                          await FirestoreHelper.firestoreHelper
                              .insertUser(userModel: userModel);
                        } else if (res["error"] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res["error"]),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("User Sign Up failed..."),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }

                        emailController.clear();
                        passwordController.clear();

                        email = null;
                        password = null;
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
