import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/page/home_page/widgets/home_page_widgets.dart';
import 'package:supo_market/page/util_function.dart';

import '../entity/item_entity.dart';

class OppositePage extends StatefulWidget {
  final int? sellerId;
  final String? sellerImage;
  final String? sellerName;
  final String? sellerGrade;
  //final List<Item>? selleritems;
  const OppositePage(this.sellerId, this.sellerImage, this.sellerName, this.sellerGrade, {Key? key});

  @override
  State<OppositePage> createState() => _OppositePageState();
}

class _OppositePageState extends State<OppositePage> {
  int? oppId;
  String? oppImage;
  String? oppName;
  String? oppGrade;
  List<Item>? oppItems;
  List<String>? titles;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    oppId = widget.sellerId;
    oppImage = widget.sellerImage;
    oppName = widget.sellerName;
    oppGrade = widget.sellerGrade;
    print("아이디는??");
    print(oppId);

    getItems();
    //oppItems = widget.selleritems;
    super.initState();
  }

  void getItems() async {
    oppItems = await getItemList(oppId!);
    setState(() {
    });
    print("목록??");
    print(titles);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        leading: IconButton (
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(oppName!),
      ),
      body: Column (
        children: [
          Stack (
            children: [
              Container (
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                child: Image.network(
                  oppImage!,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned (
                  top: 10,
                  right: 20,
                  child: Image.asset("assets/images/${oppGrade ?? "F"}.jpeg",
                    width: 70,
                    height: 70,
                  ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "신용등급",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(width: 20,),
                Text(
                  oppGrade!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded (
              child: ListView.builder (
                  controller: scrollController,
                  itemCount: oppItems?.length,
                  itemBuilder: (context, position) {
                    oppItems![position].uploadDate = formatDate (
                        oppItems![position].uploadDateForCompare ??
                            DateTime.now());
                    //uploadDate를 현재 시간 기준으로 계속 업데이트하기
                      //급처분 아이템은 보여주지 않기
                      return ItemCard(
                        itemID: oppItems![position].itemID!,
                        image: oppItems![position].imageListB.isEmpty
                            ? Image.asset("assets/images/main_logo.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover)
                            : Image.network(
                            oppItems![position].imageListB[0],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover),
                        title: oppItems![position].sellingTitle!,
                        date: oppItems![position].uploadDate ??
                            "",
                        price: oppItems![position].sellingPrice!,
                        view: oppItems![position].view!,
                        onTap: () {

                        },
                      );
                  }
              ),
          ),
        ],
      ),
    );
  }
}
