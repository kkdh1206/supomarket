import '../finding_password_page.dart';
import '../register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

RegisterUseCase registerUseCase = RegisterUseCase();

class RegisterUseCase{

  Future openRegisterPage(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  Future openFindingPasswordPage(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => FindingPasswordPage()));
  }

}



