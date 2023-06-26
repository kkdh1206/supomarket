import 'package:flutter/material.dart';
import 'home_page.dart';
import 'log_in_page.dart';

String userState = "login";
Color postechRed = Color(0xffac145a);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Nanum',
      ),
      home: userState == "logout"? const WelcomePage() : const HomePage(),
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
        body : Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height:20),
              Image.asset('assets/images/main_logo.jpg'),
              const SizedBox(height:50),
              MaterialButton(
                  height: 60,
                  minWidth: 180,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                  color: const Color(0xffac145a),
                  elevation: 5,
                  onPressed: (){
                    if(userState == "login"){
                      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    }
                    else if(userState == "logout"){
                      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()));
                    }
                  },
                  child: const Text("시작하기", textScaleFactor: 2.0, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
              // MaterialButton(
              //   onPressed: (){},
              //   child: const Text("회원가입", textScaleFactor: 1.0, textAlign: TextAlign.center, style: TextStyle(color: Colors.black))
              //),
            ],
          ),
        ),
      ),
    );
  }
}

