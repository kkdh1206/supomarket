import 'package:flutter/material.dart';

class Goods{
  String? goodsName;
  String? goodsQuality;
  String? sellerName;
  String? imagePath_1;
  String? imagePath_2;
  String? imagePath_3;

  Goods( //생성자
      {required this.goodsName,
      required this.goodsQuality,
      required this.sellerName,
      required this.imagePath_1,
      this.imagePath_2,
      this.imagePath_3}
      );

}
