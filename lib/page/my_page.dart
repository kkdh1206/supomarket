import 'package:flutter/material.dart';
import '../entity/user_entity.dart';

class MyPage extends StatelessWidget{
  final User user;
  const MyPage({Key? key, required this.user}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(left:20, top:30),
                  child : Image.asset(user!.imagePath!, width: 80, height: 80, fit: BoxFit.contain),
                ),
                Padding(padding: const EdgeInsets.only(top:30, left:20),
                  child: Row(
                      children: [
                        Text(user!.userSchoolNum??"", textScaleFactor: 1.2, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 5),
                        Text(user!.userName??"", textScaleFactor: 1.2, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                ),
              ],
            ),
            const SizedBox(height:10),
            const SizedBox(width: 500, child: Divider(color: Colors.black, thickness: 0.1)),
            Expanded(child:
              ListView(
                children: [
                  SizedBox(
                      height: 50,
                      child: MaterialButton(
                          onPressed: () {  },
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(Icons.settings),
                                SizedBox(width:18),
                                Text('환경 설정', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                              ],
                            ),
                          ),
                      )
                  ),
                  SizedBox(
                      height: 50,
                      child: MaterialButton(
                        onPressed: () {  },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width:18),
                              Text('내 정보 변경', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                      )
                  ),
                  SizedBox(
                      height: 50,
                      child: MaterialButton(
                        onPressed: () {  },
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(Icons.message),
                              SizedBox(width:18),
                              Text('고객 센터', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}


