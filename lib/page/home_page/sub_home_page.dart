import 'dart:io';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../entity/goods_entity.dart';
import 'package:flutter/services.dart';

Color postechRed = Color(0xffac145a);

class SubHomePage extends StatefulWidget {

  final Goods goods;
  const SubHomePage({Key? key, required this.goods}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubHomePageState();
  }
}

class _SubHomePageState extends State<SubHomePage>{

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {

    @override
    void initState(){
      debugPrint("Sub Home Page Initialize");
      activeIndex = 0;
      super.initState();
    }

    @override
    void dispose(){
      super.dispose();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Stack(
              children: [
                Padding(padding: const EdgeInsets.only(top:0),
                  child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[

                    widget.goods.imageList.isEmpty?
                    Image.asset("assets/images/main_logo.jpg", width: 400, height: 400, fit: BoxFit.fitHeight,)
                    : CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 400,
                          initialPage: 0,
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) => setState(() {
                            activeIndex = index;
                          }),
                          ),
                            itemCount: widget.goods.imageList?.length,
                            itemBuilder: (context, index, realIndex) {
                              final path = widget.goods.imageList?[index].path;
                              return imageSlider(path, index);
                            },
                      ),


                    widget.goods.imageList.isEmpty? const SizedBox(width:0, height: 0)
                    : Positioned(
                      bottom : 20,
                      child: CarouselIndicator(
                          animationDuration: 100,
                          count: widget.goods.imageList?.length,
                          index: activeIndex,
                        ),
                    )
              ],
            ),
            ),
              Positioned(
                  left: 10, top : 10,
                  child: IconButton (onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.white54), iconSize: 30)
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
                      child : Text(widget.goods.sellingTitle!, textScaleFactor: 1.8, style: const TextStyle(fontWeight: FontWeight.w900), textAlign: TextAlign.start),
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
                      child : Text("등록 날짜 : ${widget.goods.uploadDate??"미상"}", textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.w400), textAlign: TextAlign.start),
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
                      child : Text("상품 종류 : ${widget.goods.goodsType??"미상"}", textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.w400), textAlign: TextAlign.start),
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
                      child : Text("상품 품질 : ${widget.goods.goodsQuality??"미상"}", textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.w400), textAlign: TextAlign.start),
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
                      child : Text("상품 내용 : ${widget.goods.goodsDetail??""}", textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.w400), textAlign: TextAlign.start),
                    ),
                  ),
                ),
              ],
            ),

            //판매자 카드
            Card(
              color: Colors.grey[200],
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10), elevation: 1,
              child: Row(
                children: [
                  Padding(padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.asset(widget.goods.sellerImage??"assets/images/user.png", width:100, height: 100, fit: BoxFit.fitHeight),),
                  ),
                  Text("판매자 : ${widget.goods.sellerName??"미상"}", textScaleFactor: 1.2),
                  const Expanded(child: SizedBox(width:1)),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child : Text("${widget.goods.sellingPrice!.toString()}원", textScaleFactor: 1.8, style: const TextStyle(fontWeight: FontWeight.w900), textAlign: TextAlign.start),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(icon: widget.goods.isLiked == true? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                onPressed: () {
                  setState((){widget.goods.isLiked = !(widget.goods.isLiked!);});
                }),
              IconButton(icon: Icon(Icons.chat),onPressed: () {},),
              IconButton(icon: Icon(Icons.more_vert),onPressed: () {},),
              const SizedBox(width: 120),
              Expanded(child: Padding(padding: EdgeInsets.only(right:10),
                  child: MaterialButton(color: postechRed,
                      child: const Text("채팅하기", textScaleFactor: 1.0, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      onPressed: () {  })
              )
              ),
            ],
          ),
        )
    );
  }

  //이미지 넘기는 슬라이더
  Widget imageSlider(path, index) => Container(
    width: 400,
    height: 400,
    color: Colors.grey,
    child: Image.file(File(path), fit: BoxFit.cover, width: 400, height: 400),
  );

}