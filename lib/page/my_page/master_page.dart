import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../entity/goods_entity.dart';

class MasterPage extends StatefulWidget {
  final List<Goods>? list;
  const MasterPage({Key? key, required this.list}) : super(key: key);

  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage>{

  List<Goods>? list;
  int refreshNum = 0;
  String selectedOption = "최신 순";
  final options = ["최신 순", "가격 순"];

  @override
  void initState() {
    list = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [

          ],
        ),
      )
    );
  }
}