import 'package:image_picker/image_picker.dart';

class Goods{
  String? sellingTitle;
  String? goodsType;
  String? goodsQuality;
  String? sellerName;
  String? sellerImage;
  String? sellerSchoolNum;
  int sellingPrice;
  String? goodsDetail;
  String? uploadDate;
  DateTime? uploadDateForCompare;
  bool? isLiked;
  bool isQuickSell;
  List<XFile> imageListA;
  List<String> imageListB;
  int sellingState;

  Goods( //생성자
      { required this.sellingTitle,
        required this.goodsType,
        required this.goodsQuality,
        required this.sellerName,
        required this.sellerImage,
        required this.sellingPrice,
        required this.isLiked,
        required this.isQuickSell,
        required this.sellerSchoolNum,
        this.goodsDetail,
        required this.uploadDate,
        required this.uploadDateForCompare,
        required this.imageListA,
        required this.imageListB,
        required this.sellingState}
      );

}
