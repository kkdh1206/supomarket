//홈화면 리스트뷰 카드

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../entity/util_entity.dart';

class ItemCard extends StatelessWidget {
  final Image image;
  final String title;
  final String date;
  final int price;
  final Function() onTap;

  ItemCard({Key? key, required this.image, required this.title, required this.date, required this.price, required this.onTap}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width : 80,
        height: 110,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 10
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: image,
                      ),
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    title,
                                    style:
                                    TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.w700),
                                    overflow:
                                    TextOverflow
                                        .ellipsis),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    "등록 일자: ${date}",
                                    style:
                                    TextStyle(
                                        fontSize:
                                        15),
                                    overflow:
                                    TextOverflow
                                        .ellipsis),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    "가격: ${f.format(price).toString()}원",
                                    style:
                                    TextStyle(
                                        fontSize:
                                        15),
                                    overflow:
                                    TextOverflow
                                        .ellipsis),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DropDown extends StatefulWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final options1 = [
    SortType.DATEASCEND,
    SortType.DATEDESCEND,
    SortType.PRICEDESCEND,
    SortType.PRICEASCEND
  ];

  SortType selectedOption1 = SortType.DATEASCEND;
  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      height: 35,
      //width: 100,
      decoration: BoxDecoration(
          color: Color(0xffB70001),
          border: Border.all(color: Color(0xffB70001)),
          borderRadius: BorderRadius.circular(20.0)
      ),
      padding: const EdgeInsets.only(left: 10, bottom: 2),
      child: DropdownButton(
        dropdownColor: Color(0xffB70001),
        icon: const SizedBox.shrink(),
        underline: const SizedBox.shrink(),
        value: selectedOption1,
        items: options1
            .map((e) => DropdownMenuItem(
            value: e,
            child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      e == SortType.PRICEASCEND
                          ? "가격 낮은 순"
                          : e == SortType.PRICEDESCEND
                          ? "가격 높은 순"
                          : e == SortType.DATEASCEND
                          ? "최신 순"
                          : "오래된 순",
                      textScaleFactor: 0.8,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.arrow_drop_down_sharp, color: Colors.white,),
                  ],
                ))))
            .toList(),
        onChanged: (value) async {
          setState(() {

          });
        },
        itemHeight: 50.0,
      ),
    );
  }
}