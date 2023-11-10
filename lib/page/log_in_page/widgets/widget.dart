

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupoTitle extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      child: const Text(
        '슈포마켓',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Tenada',
          //fontWeight: FontWeight.w700,
          fontSize: 35,
        ),
      ),
    );
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
                // 버튼이 클릭되었을 때의 동작
              },
              child: Text('회원가입',
                // textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFB70001), fontFamily: 'Tenada', fontWeight: FontWeight.w600, fontSize: 15),
              ),

            ),
            Text('|'),
            TextButton(
              onPressed: () {
                // 버튼이 클릭되었을 때의 동작
              },
              child: Text('비밀번호 찾기',
                // textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFB70001), fontFamily: 'Tenada', fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ],
        )
    );
  }
}



class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:325,
      height: 60,
      child: TextButton(
          onPressed: () {
            // 버튼이 클릭되었을 때의 동작
          },
          style: TextButton.styleFrom(

            backgroundColor: Color(0xFFB70001),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // 원하는 둥근 정도 설정
            ),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('로그인',
              // textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontFamily: 'Tenada', fontWeight: FontWeight.w600, fontSize: 23),
            )],
          )

      ),
    );
  }
}





class TextInputwithButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Container(
            alignment: Alignment.center,


            width: 325.0,
            height: 80.0,
            padding: EdgeInsets.all(5),
            child:
            Stack(
              children: [
                TextField(
                  onChanged: (event) {
                    // 알아서 넣어
                  },
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,

                  decoration: InputDecoration(
                      hintText: '이메일',
                      hintStyle: TextStyle(
                        color: Colors.grey[600], // labelText의 텍스트 색상
                        fontSize: 16.0, // labelText의 텍스트 크기 -> 이것
                        fontFamily: 'Tenada', // 알아서 변경할 것!!
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      helperText: '',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none

                      )
                  ),
                ),

                Positioned(
                    right: 0,
                    top: 10,

                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(

                          width: 75,
                          height: 28,
                          alignment: Alignment.center,
                          child:

                          ElevatedButton(

                            onPressed: () {
                              // 버튼이 클릭되었을 때의 동작
                            },
                            style: ElevatedButton.styleFrom(

                              backgroundColor: Colors.grey[700],
                              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도 설정
                              ),),

                            child: Text('중복확인',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )



                )
                ,
              ],
            )
        )]
    );
  }
}