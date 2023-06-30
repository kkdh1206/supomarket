import 'package:flutter/material.dart';

Color postechRed = Color(0xffac145a);

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              "슈포마켓", style: TextStyle(fontWeight: FontWeight.w300)),
          backgroundColor: postechRed),
      body: const Center(
        child: Column(

        ),
      ),
    );
  }
}

//로그인페이지,추가페이지,설정페이지, 설명페이지 추가