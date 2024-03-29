import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/widgets/custom_button.dart';
import 'package:thrift_exchange/common/widgets/custom_textfield.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/auth/services/auth_service.dart';

enum Auth {
  signin,
  signup,
  reset,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Possible bug here
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text);
  }

  void resetUser(){
    authService.resetUser(context: context, email: _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalVariables.greyBackgroundColor,
        
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,

                image: AssetImage("assets/images/testbackground.jpg")
                ),
            ),

            child: Center(
              child: Container(
                constraints: BoxConstraints(minWidth: 100,maxWidth: 500),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    const Text("Welcome!",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.amber)),
                    ListTile(
                    
                      title: const Text("Create Account",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )),
                      tileColor: _auth == Auth.signup
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundColor,
                      leading: Radio(
                        activeColor: GlobalVariables.secondaryColor,
                        value: Auth.signup,
                        groupValue: _auth,
                        onChanged: (Auth? val) {
                          setState(() {
                            _auth = val!;
                          });
                        },
                      ),
                    ),
                    if (_auth == Auth.signup)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                        color: GlobalVariables.backgroundColor,

                          borderRadius: BorderRadius.circular(
                                13), // Rounded corner radius
                         ),
                        child: Form(
                            key: _signUpFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _nameController,
                                  hintText: "Name",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: "Email",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: "Password",
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                    text: "Sign Up",
                                    onTap: () {
                                      if (_passwordController.text.trim().length < 8){
                                        showSnackBar(context, 'Pass word must be at least 8 characters');
                                        return;
                                      }
                                      if (_signUpFormKey.currentState!.validate()) {
                                        signUpUser();
                                      }
                                    })
                              ],
                            )),
                      ),
                    ListTile(
                      title: const Text("Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      tileColor: _auth == Auth.signin
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundColor,
                      leading: Radio(
                        activeColor: GlobalVariables.secondaryColor,
                        value: Auth.signin,
                        groupValue: _auth,
                        onChanged: (Auth? val) {
                          setState(() {
                            _auth = val!;
                          });
                        },
                      ),
                    ),
                    if (_auth == Auth.signin)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                        color: GlobalVariables.backgroundColor,

                          borderRadius: BorderRadius.circular(
                                13), // Rounded corner radius
                         ),
                        child: Form(
                            key: _signInFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: "Email",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: "Password",
                                  obscureText: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                    text: "Sign In",
                                    onTap: () {
                                      if (_signInFormKey.currentState!.validate()) {
                                        signInUser();
                                      }
                                    })
                              ],
                            )),
                      ),
                    ListTile(
                      title: const Text("Reset Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      tileColor: _auth == Auth.signin
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundColor,
                      leading: Radio(
                        activeColor: GlobalVariables.secondaryColor,
                        value: Auth.reset,
                        groupValue: _auth,
                        onChanged: (Auth? val) {
                          setState(() {
                            _auth = val!;
                          });
                        },
                      ),
                    ),
                    if (_auth == Auth.reset)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                        color: GlobalVariables.backgroundColor,

                          borderRadius: BorderRadius.circular(
                                13), // Rounded corner radius
                         ),
                        child: Form(
                            key: _resetFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: "Email",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                    text: "Reset",
                                    onTap: () {
                                      if (_resetFormKey.currentState!.validate()) {
                                        resetUser();
                                      }
                                    })
                              ],
                            )),
                      ),
                  ],
                ),
              ),
            ),
          )));
  }
}
