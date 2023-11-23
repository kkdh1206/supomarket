// uploadBoard

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../infra/my_info_data.dart';

class Back extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          CupertinoIcons.back,
          color: Colors.black,
          size: 30,
        ));
  }
}

class EachTextField extends StatefulWidget {
  final String text;
  final Function(String) onChanged;

  const EachTextField({Key? key, required this.text, required this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EachTextFieldState();
  }
}

class EachTextFieldState extends State<EachTextField> {

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        children: [
          Text('        '),
          Text(
            widget.text,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'KBO-B'),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Text('        '),
          Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              width: 325.0,
              height: widget.text == "문의 내용" ? 250 : 50.0,
              padding: EdgeInsets.all(5),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    alignLabelWithHint: true,
                    label: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          widget.text == "작성자"? myUserInfo.userName??"익명" : widget.text == "작성 일시"? DateFormat('yy/MM/dd - HH:mm:ss').format(DateTime.now()) : "",
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  onChanged: widget.onChanged,
                  keyboardType: widget.text == "문의 내용"
                      ? TextInputType.multiline
                      : TextInputType.text,
                  maxLines: widget.text == "문의 내용" ? 30 : 1,
                ),
              )
          ),
        ],
      )
    ]);
  }
}


class EachTextFieldModified extends StatefulWidget {
  final String text;
  final Function(String) onChanged;
  final String initialValue;

  const EachTextFieldModified({Key? key, required this.text, required this.onChanged, required this.initialValue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EachTextFieldModifiedState();
  }
}

class EachTextFieldModifiedState extends State<EachTextFieldModified> {

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        children: [
          Text('        '),
          Text(
            widget.text,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'KBO-B'),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Text('        '),
          Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              width: 325.0,
              height: widget.text == "문의 내용" ? 250 : 50.0,
              padding: EdgeInsets.all(5),
              child: Center(
                child: TextFormField(
                  initialValue: widget.initialValue,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    alignLabelWithHint: true,
                    label: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          widget.text == "작성자"? myUserInfo.userName??"익명" : widget.text == "작성 일시"? DateFormat('yy/MM/dd - HH:mm:ss').format(DateTime.now()) : "",
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  onChanged: widget.onChanged,
                  keyboardType: widget.text == "문의 내용"
                      ? TextInputType.multiline
                      : TextInputType.text,
                  maxLines: widget.text == "문의 내용" ? 30 : 1,
                ),
              )
          ),
        ],
      )
    ]);
  }
}


class QnAListCard extends StatelessWidget {
  const QnAListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.grey[200],
        margin:
        const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                //if(searchList![position].boardStatus == BoardStatus.PRIVATE)
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      "assets/images/lock.png",
                    ),
                  ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 40,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        const SizedBox(
                            height: 10),
                        Row(
                          children: [
                            Expanded(
                                child:
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    //searchList![position].boardStatus == BoardStatus.PRIVATE? "비밀글 입니다" : searchList![position].title!,
                                      "아 겁나 열받네",
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis
                                  ),
                                )
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child:
                              Padding( padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  //"등록 일자: ${searchList![position].uploadDate ?? ""}",
                                    "등록 일자  2024.1.2",
                                    style:
                                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 10),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 30,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class MyQnAPage extends StatelessWidget {
  const MyQnAPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.grey[200],
        margin:
        const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                //if(searchList![position].boardStatus == BoardStatus.PRIVATE)
                Container(
                  padding: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 40,
                  child: Image.asset(
                    "assets/images/lock.png",
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(left: 15),
                //   height: 40,
                //   width: 40,
                // ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        const SizedBox(
                            height: 10),
                        Row(
                          children: [
                            Expanded(
                                child:
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    //searchList![position].title!,
                                      "비밀글 입니다.",
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis
                                  ),
                                )
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child:
                              Padding( padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  //"등록 일자: ${searchList![position].uploadDate ?? ""}",
                                    "등록 일자  2024.1.2",
                                    style:
                                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 10),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          height: 38,
                          width: 38,
                          padding: EdgeInsets.only(right: 20.0),
                          child: Image.asset("assets/images/pencil.png"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/bin.png"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// uploadBoard

class BoardName extends StatelessWidget {

  final String text;
  const BoardName({Key?key, required this.text}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'KBO-B'),
          ),
        ],
      ),
    ]);
  }
}

class BoardOwner extends StatelessWidget {

  final String text;
  const BoardOwner({Key?key, required this.text}) : super(key:key);


  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '작성자: ',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'KBO-M'),
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'KBO-M'),
          ),
        ],
      ),

    ]);
  }
}

class UploadTime extends StatelessWidget {
  final String text;

  const UploadTime({Key?key, required this.text}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        children: [
          Text(
            '작성일시: ',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'KBO-B'),
          ),

          Text(
            text,
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'KBO-M'),
          ),
        ],
      ),

    ]);
  }
}

class BoardContents extends StatelessWidget {
  final String text;

  const BoardContents({Key?key, required this.text}) : super(key:key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        width: width * 0.9,
        decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            )
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '문의 내용',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'KBO-B'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.8,
                      child: Text("$text\n",
                        maxLines: null,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'KBO-M'

                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),

          ],
        ),
      ),
    ]);
  }
}

class CommentInput extends StatefulWidget{
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final Function() onPressed;
  final TextEditingController controller;

  CommentInput({super.key, required this.onChanged, required this.onSubmitted, required this.onPressed, required this.controller});

  @override
  CommentInputState createState() => CommentInputState();
}

class CommentInputState extends State<CommentInput>{
  @override
  Widget build (BuildContext context){
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Container(
            width: 325.0,
            padding: EdgeInsets.all(5),
            child:
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: widget.controller,
                        decoration: InputDecoration(
                          hintText: '댓글 입력...',
                          hintStyle: TextStyle(
                            color: Colors.grey[600], // labelText의 텍스트 색상
                            fontSize: 16.0, // labelText의 텍스트 크기 -> 이것
                            fontFamily: 'KBO-M', // 알아서 변경할 것!!
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFB70001), width: 2), // 활성 상태일 때 밑줄 색상
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFB70001), width: 2), // 포커스 상태일 때 밑줄 색상
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: -10,
                  bottom: 0,
                  child: TextButton(
                      onPressed: widget.onPressed,
                      child: Icon(Icons.send)
                  ),
                )
              ],
            )
        )]
    );
  }
}

class CommentCard extends StatelessWidget {
  final String writer;
  final String date;
  final String content;

  const CommentCard({Key?key, required this.writer, required this.date, required this.content}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(

      width: 350,
      child: Card(
          color: Colors.grey[200],

          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Column(
                      children: [
                        Text('', style: TextStyle(fontSize: 12),),

                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [

                    Container(
                      width: 315,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('      '),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8.0),

                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('', style: TextStyle(fontSize: 9)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        writer,
                                        style: TextStyle(fontFamily: 'KBO-B', fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height : 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '작성일시  ',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'KBO-B',
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'KBO-M',
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10), // 추가한 여백
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible( // Flexible로 감싸서 텍스트가 넘칠 경우 줄 바꿈이 가능하도록 함
                                        child: Text(
                                          content,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontFamily: 'KBO-M',
                                            fontSize: 15,
                                          ),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8), // 추가한 여백
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],



                ),

              ]
          )
      ),
    );
  }
}