import 'package:flutter/material.dart';
import 'control_page.dart';
import 'log_in_page.dart';

String userState = "login";
Color postechRed = Color(0xffac145a);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // void initiate(){
  //   debugPrint('initiate');
  // }
  //
  // @override
  // void didChangeDependencies(){ //데이터에 의존한다면 반영되고 출력
  //   debugPrint('didChangeDependencies');
  // }
  // @override
  // void didUpdateWidget(){ //위젯을 갱신해야한다면 호출
  //   debugPrint('didUpdateWidget');
  // }
  // @override
  // void update(){ //위젯을 실제로 업데이트함
  //   debugPrint('update');
  // }
  //이외에도 deactivate, dispose, mounted==true / mounted==false

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Nanum',
      ),
      home: userState == "logout"? const WelcomePage() : const ControlPage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      fontFamily: 'Nanum'
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body : Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child : Image.asset('assets/images/main_logo.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child : MaterialButton(
                      height: 60,
                      minWidth: 180,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                      color: const Color(0xffac145a),
                      elevation: 5,
                      onPressed: (){
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()));
                      },
                      child: const Text("시작하기", textScaleFactor: 2.0, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

