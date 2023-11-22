
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../entity/item_entity.dart';
import '../sub_category_page.dart';

class PlusButton extends StatefulWidget {
  @override
  PlusButtonState createState() => PlusButtonState();
}

class Etc extends StatefulWidget {
  final List<Item>? list;
  final String? text;

  const Etc({Key? key, required this.list, this.text}) : super(key: key);

  @override
  EtcState createState() => EtcState();
}

class Book extends StatefulWidget {
  final List<Item>? list;
  final String? text;

  const Book({Key? key, required this.list, this.text}) : super(key: key);
  @override
  BookState createState() => BookState();
}

class Clothes extends StatefulWidget {
  final List<Item>? list;
  final String? text;

  const Clothes({Key? key, required this.list, this.text}) : super(key: key);
  @override
  ClothesState createState() => ClothesState();
}

class Monitor extends StatefulWidget {
  final List<Item>? list;
  final String? text;

  const Monitor({Key? key, required this.list, this.text}) : super(key: key);
  @override
  MonitorState createState() => MonitorState();
}

class Refrigerator extends StatefulWidget {
  final List<Item>? list;
  final String? text;

  const Refrigerator({Key? key, required this.list, this.text}) : super(key: key);
  @override
  RefrigeratorState createState() => RefrigeratorState();
}

class Rooms extends StatefulWidget {
  final List<Item>? list;
  final String? text;

  const Rooms({Key? key, required this.list, this.text}) : super(key: key);
  @override
  RoomsState createState() => RoomsState();
}

class PlusButtonState extends State<PlusButton> {
  // 여기에 상태를 나타내는 변수들을 선언하세요.

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: (){
            // + 버튼 동작 기능 넣기
          },
          child: Image.asset('assets/images/icons/plus_again.png',
            width: 55,
            height: 55,),
        )
    );
  }
}

class EtcState extends State<Etc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.only(top: 10, right: 5, bottom: 0, left: 10),
      color: Colors.grey[400],
      child: InkWell(
          onTap: () {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SubCategoryPage(list: widget.list, type : widget.text); // 화면을 반환하는 부분
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset(0.0, 0.0);
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
            ));
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.text!,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-B',
                            fontWeight: FontWeight.w400,
                            fontSize: 25),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'etc',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-L',
                            fontWeight: FontWeight.w200,
                            fontSize: 20),
                      )
                    ],
                  ),

                ],
              ),
              Positioned(
                right: 0,
                bottom: 5,
                child: Image.asset(
                  'assets/images/icons/pending.png',
                  width: 100,
                  height: 100,
                ),
              )
            ],
          )),
    );
  }
}

class BookState extends State<Book> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.only(top: 10, right: 5, bottom: 0, left: 10),
      color: Colors.grey[400],
      child: InkWell(
          onTap: () {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SubCategoryPage(list: widget.list, type : widget.text); // 화면을 반환하는 부분
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset(0.0, 0.0);
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
            ));
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '책',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-B',
                            fontWeight: FontWeight.w400,
                            fontSize: 25),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'books',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-L',
                            fontWeight: FontWeight.w200,
                            fontSize: 20),
                      )
                    ],
                  ),

                ],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/icons/books.png',
                  width: 110,
                  height: 110,
                ),
              )
            ],
          )),
    );
  }
}

class MonitorState extends State<Monitor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.only(top: 10, right: 5, bottom: 0, left: 10),
      color: Colors.grey[400],
      child: InkWell(
          onTap: () {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SubCategoryPage(list: widget.list, type : widget.text); // 화면을 반환하는 부분
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset(0.0, 0.0);
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
            ));
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '모니터',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-B',
                            fontWeight: FontWeight.w400,
                            fontSize: 25),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'monitors',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-L',
                            fontWeight: FontWeight.w200,
                            fontSize: 20),
                      )
                    ],
                  ),

                ],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/icons/desktop.png',
                  width: 100,
                  height: 100,
                ),
              )
            ],
          )),
    );
  }
}


class ClothesState extends State<Clothes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.only(top: 10, right: 5, bottom: 0, left: 10),
      color: Colors.grey[400],
      child: InkWell(
          onTap: () {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SubCategoryPage(list: widget.list, type : widget.text); // 화면을 반환하는 부분
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset(0.0, 0.0);
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
            ));
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '의류',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-B',
                            fontWeight: FontWeight.w400,
                            fontSize: 25),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'clothes',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-L',
                            fontWeight: FontWeight.w200,
                            fontSize: 20),
                      )
                    ],
                  ),

                ],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/icons/clothes-hanger.png',
                  width: 110,
                  height: 110,
                ),
              )
            ],
          )),
    );
  }
}

class RefrigeratorState extends State<Refrigerator>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.only(top: 10, right: 5, bottom: 0, left: 10),
      color: Colors.grey[400],
      child: InkWell(
          onTap: () {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SubCategoryPage(list: widget.list, type : widget.text); // 화면을 반환하는 부분
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset(0.0, 0.0);
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
            ));
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '냉장고',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-B',
                            fontWeight: FontWeight.w400,
                            fontSize: 25),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'fridges',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-L',
                            fontWeight: FontWeight.w200,
                            fontSize: 20),
                      )
                    ],
                  ),

                ],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  'assets/images/icons/fridge.png',
                  width: 100,
                  height: 100,
                ),
              )
            ],
          )),
    );
  }
}

class RoomsState extends State<Rooms> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.only(top: 10, right: 10, bottom: 0, left: 10),
      color: Colors.grey[400],
      child: InkWell(
          onTap: () {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SubCategoryPage(list: widget.list, type : widget.text); // 화면을 반환하는 부분
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset(0.0, 0.0);
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                    position: offsetAnimation, child: child);
              },
            ));
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '자취방',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-B',
                            fontWeight: FontWeight.w400,
                            fontSize: 25),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'studio\napartments',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KBO-L',
                            fontWeight: FontWeight.w200,
                            fontSize: 20),
                      )
                    ],
                  ),

                ],
              ),
              Positioned(
                right: 0,
                bottom: -5,
                child: Image.asset(
                  'assets/images/icons/room.png',
                  width: 100,
                  height: 100,
                ),
              )
            ],
          )),
    );
  }
}

class Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('슈포마켓',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'KBO-B',
              fontWeight: FontWeight.w700,
              fontSize: 35)),
    );
  }
}