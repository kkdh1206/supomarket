import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/firebase_options.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../infra/my_info_data.dart';
import 'control_page.dart';
import 'log_in_page/log_in_page.dart';

Color postechRed = Color(0xffac145a);

void main() async {

  //firebase 사용을 위한 호출들
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/main_logo.jpg"),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(postechRed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Nanum',
      ),
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3), () => "Intro Completed."),
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: SplashConditionWidget(snapshot)
          );
        },
      ),
        initialRoute: '/',
        routes: {'/control': (context) => const ControlPage(),
        //'/subHome': (context) => const SubHomePage()
        },
    );
  }
}

Widget SplashConditionWidget(AsyncSnapshot<Object?> snapshot) {
  if(snapshot.hasError) {
    return const Text("Error!!");
  } else if(snapshot.hasData) {
    //data를 받아와서 login이 되어있는 것을 확인했으면 ControlPage로 이동
    //logout되어있으면 WelcomePage로 이동해서 Login 페이지로 이동할 수 있게 함
    return myUserInfo.isUserLogin == false? const WelcomePage() : const ControlPage();
  } else {
    return SplashScreen();
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

