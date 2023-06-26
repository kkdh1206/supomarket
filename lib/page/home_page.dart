import 'package:flutter/material.dart';
import '../entity/goods_entity.dart';

Color postechRed = Color(0xffac145a);

class HomePage extends StatelessWidget {

  final List<Goods>? list;
  const HomePage({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      floatingActionButton: FloatingActionButton(
        backgroundColor: postechRed,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Container(
        child: Center(
          child: ListView.builder(itemBuilder: (context, position) {
            //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
            return Card(
              child: Row(
                children: [
                  Image.asset(list![position].imagePath_1!, width:100, height: 100, fit: BoxFit.contain),
                  Text(list![position].goodsName!),
                  ],
                ),
              );
            },
            itemCount: list!.length, //아이템 개수만큼 스크롤 가능
          ),
        ),
      ),
    );
  }
}


