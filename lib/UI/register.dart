import 'package:chatapp_basic/services/auth/auth_service.dart';
import 'package:chatapp_basic/components/my_button.dart';
import 'package:chatapp_basic/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterUI extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cfpassController = TextEditingController();
  final void Function()? onTap;

  RegisterUI({super.key, required this.onTap});

  void register(BuildContext context) {
    final auth = AuthService();

    //password match -> create user
    if (_cfpassController.text == _passController.text) {
      try {
        auth.signUpWithEmailAndPassword(
          _emailController.text,
          _passController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //password don't match -> show error to user
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(
              height: 50,
            ),

            //welcome back message
            Text(
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            //email textfield
            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(
              height: 10,
            ),

            MyTextfield(
              hintText: "Password",
              obscureText: true,
              controller: _passController,
            ),

            const SizedBox(
              height: 10,
            ),

            MyTextfield(
              hintText: "Confirm password",
              obscureText: true,
              controller: _cfpassController,
            ),

            const SizedBox(
              height: 25,
            ),

            //login button
            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),

            const SizedBox(
              height: 25,
            ),

            //resigter now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
