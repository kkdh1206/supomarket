import 'package:flutter/material.dart';
import '../entity/goods_entity.dart';

Color postechRed = Color(0xffac145a);

class SubHomePage extends StatelessWidget {

  final Goods goods;

  const SubHomePage({Key? key, required this.goods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: postechRed),
      backgroundColor: Colors.white,
      body: Column(
          children: [
            Padding(padding: const EdgeInsets.only(top:30),
                child: Text("제목 : ${goods.sellingTitle!}", textScaleFactor: 1.5, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.start)
            ),
            Image.asset(goods.imagePath_1!, width:400, height: 400, fit: BoxFit.contain),
            const SizedBox(width:380, child: Divider(color: Colors.black),),
            Padding(padding: const EdgeInsets.only(top:10),
                child: Text("가격 : ${goods.sellingPrice!}", textScaleFactor: 2, textAlign: TextAlign.left)
            ),
        ],
      ),
    );
  }
}