import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SellPage extends StatelessWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    //widget.item.sellingTitle!,
                      "제품이름이름이름이름",
                      textScaleFactor: 2.1,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900
                      ),
                      textAlign: TextAlign.start
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    //widget.item.sellingTitle!,
                      "888,888원",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: Color(0xffB70001),
                      ),
                      textAlign: TextAlign.start
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    //"등록 날짜 : ${widget.item.uploadDate ?? "미상"}",
                      "2023.01.19",
                      //textScaleFactor: 1.1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.start),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "상품종류",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffB70001),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    //     "상품 종류 : "
                    //     "${widget.item.itemType == ItemType.REFRIGERATOR
                    //     ? "냉장고"
                    //     :
                    // widget.item.itemType == ItemType.MONITOR ? "모니터" :
                    // widget.item.itemType == ItemType.BOOK ? "책" :
                    // widget.item.itemType == ItemType.ROOM ? "자취방" :
                    // widget.item.itemType == ItemType.CLOTHES
                    //     ? "옷"
                    //     : "기타"}",
                      "제품제품",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.start
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "상품품질",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffB70001),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    // "상품 품질 : "
                    // "${widget.item.itemQuality == ItemQuality.HIGH
                    // ? "상" : widget.item.itemQuality == ItemQuality.MID
                    // ? "중" : "하"}",
                      "상",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                      ),
                      textAlign: TextAlign.start
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "상품내용",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffB70001),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    //"상품 내용 : ${widget.item.itemDetail ?? ""}",
                      "상품내용내용내용내용내용",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                      textAlign: TextAlign.start),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SellerCard extends StatelessWidget {
  const SellerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(
          vertical: 20, horizontal: 20),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.only(
              top: 10, bottom: 10, left: 10, right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child:
              // widget.item.sellerImage == null ? Image.asset(
              // "assets/images/user.png",
              // width: 100,
              // height: 100,
              // fit: BoxFit.cover)
              // : Image.network(
              // widget.item.sellerImage ?? "", width: 100,
              // height: 100,
              // fit: BoxFit.cover),
              Image.asset("assets/images/human.png",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 1),
                    child: Text(
                      //"판매자 : ""${widget.item.sellerName ?? "미상"}",
                      "김판매",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      //margin: const EdgeInsets.only(left: 1),
                      padding: EdgeInsets.only(left: 6, top: 5, bottom: 4, right: 4),
                      color: Color(0xffB70001),
                      height: 25,
                      width: 50,
                      child: Text(
                        "판매자",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "추가 상세 정보",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox(width: 1)),
        ],
      ),
    );
  }
}