import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../entity/user_entity.dart';
import '../../../infra/my_info_data.dart';
import '../../../infra/users_info_data.dart';
import '../../control_page.dart';
import '../../util_function.dart';
import '../auth_email_page.dart';
import '../usecases/popup_usecase.dart';
import '../usecases/register_usercase.dart';

class SupoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 35),
      Container(
        width: 45,
        height: 45,
        child:
            Image.asset('assets/images/main_logo_3.png', fit: BoxFit.fitHeight),
      ),
      Container(
        child: const Text(
          '슈포마켓',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'KBO-B',
            //fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
      )
    ]);
  }
}

class SupoTitle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 45,
        height: 45,
        child:
        Image.asset('assets/images/main_logo_3.png', fit: BoxFit.fitHeight),
      ),
      Container(
        child: const Text(
          '슈포마켓',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'KBO-B',
            //fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
      )
    ]);
  }
}

class SupoTitle3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 35),
      Container(
        width: 45,
        height: 45,
        child:
        Image.asset('assets/images/main_logo_3.png', fit: BoxFit.fitHeight),
      ),
      Container(
        child: const Text(
          '회원가입',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'KBO-B',
            //fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
      )
    ]);
  }
}

class SupoTitle4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 35),
      Container(
        width: 45,
        height: 45,
        child:
        Image.asset('assets/images/main_logo_3.png', fit: BoxFit.fitHeight),
      ),
      Container(
        child: const Text(
          '비밀번호 찾기',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'KBO-B',
            //fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
      )
    ]);
  }
}


class SupoTitle5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 35),
      Container(
        width: 45,
        height: 45,
        child:
        Image.asset('assets/images/main_logo_3.png', fit: BoxFit.fitHeight),
      ),
      Container(
        child: const Text(
          '비밀번호 변경',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'KBO-B',
            //fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
      )
    ]);
  }
}

class RegisterPassward extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            _openRegisterPage(context);
          },
          child: const Text(
            '회원가입',
            // textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFFB70001),
                fontFamily: 'KBO-M',
                fontWeight: FontWeight.w600,
                fontSize: 15),
          ),
        ),
        const Text('|'),
        TextButton(
          onPressed: () {
            _openFindingPasswordPage(context);
          },
          child: const Text(
            '비밀번호 찾기',
            style: TextStyle(
                color: Color(0xFFB70001),
                fontFamily: 'KBO-M',
                fontWeight: FontWeight.w600,
                fontSize: 15),
          ),
        ),
      ],
    ));
  }

  void _openRegisterPage(BuildContext context) {
    registerUseCase.openRegisterPage(context);
  }

  void _openFindingPasswordPage(BuildContext context) {
    registerUseCase.openFindingPasswordPage(context);
  }
}


class TextInputwithButton extends StatefulWidget {

  final String hintText;
  final Function(String) onChanged;

  const TextInputwithButton({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextInputwithButtonState();
  }

}

class TextInputwithButtonState extends State<TextInputwithButton>{

  dynamic Function(String)? onChanged;
  String? hintText;

  @override
  void initState() {
    onChanged  = widget.onChanged;
    hintText = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 320,
          child: TextField(
            maxLength: hintText == '닉네임'? 6 : null,
            onChanged: onChanged,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            obscureText: hintText == '새 비밀번호' ? true : hintText == '새 비밀번호 확인'? true
                : hintText == "비밀번호"? true: hintText == "비밀번호 재입력"? true: false,
            decoration: InputDecoration(
              hintText: hintText,
              suffixText: hintText == '이메일' ? "@postech.ac.kr" : "",
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 16.0,
                fontFamily: 'KBO-M',
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
              helperText: '',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
