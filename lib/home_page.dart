import 'package:flutter/material.dart';

Color postechRed = Color(0xffac145a);

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("슈포마켓", style: TextStyle(fontWeight: FontWeight.w300)), backgroundColor: postechRed),
      backgroundColor: Colors.white,
    );
  }


}


