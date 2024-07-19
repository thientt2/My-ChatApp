import 'package:chatapp_basic/UI/login.dart';
import 'package:chatapp_basic/UI/register.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  //initially, show login ui
  bool showLoginUI = true;

  //toggle between login and register
  void togglePages(){
    setState(() {
      showLoginUI = !showLoginUI;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginUI){
      return LoginUI(
        onTap: togglePages,
      );
    }else {
      return RegisterUI(
        onTap: togglePages,
      );
    }
  }
}