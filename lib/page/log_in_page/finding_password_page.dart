import 'package:flutter/material.dart';

Color postechRed = Color(0xffac145a);

class FindingPasswordPage extends StatefulWidget {
  const FindingPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FindingPasswordPageState();
  }
}

class _FindingPasswordPageState extends State<FindingPasswordPage> {
  bool isChecked = false;
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/main_logo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: postechRed.withOpacity(0.9),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                '슈포마켓', style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5 - 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: id,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "ID",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: password,
                            style: const TextStyle(),
                            obscureText: true, //패스워드 별표 처리
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  child: const Text("회원가입 하러가기", style: TextStyle(color: Colors.white54, decoration: TextDecoration.underline)),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text("비밀번호 찾기", style: TextStyle(color: Colors.white54, decoration: TextDecoration.underline)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Sign in', style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700, color: Colors.black45),
                              ),
                              const SizedBox(width: 15),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                      //   return home();
                                      // },),);
                                      //login();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}