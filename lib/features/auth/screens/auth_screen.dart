
import 'package:amazon_clone_tutorial/common/widgets/custom_button.dart';
import 'package:amazon_clone_tutorial/common/widgets/custom_textfield.dart';
import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';


enum Auth {
  signin,
  signup,
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

  void signUpUser(){
    authService.signUpUser(
      context: context, 
      email: _emailController.text, 
      password: _passwordController.text, 
      name: _nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text("Welcome!", style:TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            )),

            ListTile(
              title: const Text("Create Account", style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
              tileColor: _auth == Auth.signup ? GlobalVariables.backgroundColor : GlobalVariables.greyBackgroundColor,
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
                color: GlobalVariables.backgroundColor,
                child: Form (
                  key: _signUpFormKey,
                  child: Column(children: [
                    CustomTextField(controller: _nameController, hintText: "Name",),
                    const SizedBox(height: 10,),
                    CustomTextField(controller: _emailController, hintText: "Email",),
                    const SizedBox(height: 10,),
                    CustomTextField(controller: _passwordController, hintText: "Password",),
                    const SizedBox(height: 10,),
                    CustomButton(text: "Sign Up", onTap:(){
                      if (_signUpFormKey.currentState!.validate()){
                        signUpUser();
                      }
                    } )
                  ],)
                ),
              ),
            

            ListTile(
              title: const Text("Sign In", style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
              tileColor: _auth == Auth.signin ? GlobalVariables.backgroundColor : GlobalVariables.greyBackgroundColor,

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
                color: GlobalVariables.backgroundColor,
                child: Form (
                  key: _signUpFormKey,
                  child: Column(children: [
                    CustomTextField(controller: _emailController, hintText: "Email",),
                    const SizedBox(height: 10,),
                    CustomTextField(controller: _passwordController, hintText: "Password",),
                    const SizedBox(height: 10,),
                    CustomButton(text: "Sign In", onTap:(){

                    } )
                  ],)
                ),
              ),
            


          ],),
        )
      )
    );
  }
}