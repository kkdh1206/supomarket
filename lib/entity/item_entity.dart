import 'package:image_picker/image_picker.dart';

enum ItemQuality {HIGH, MID, LOW}
enum ItemType{BOOK, CLOTHES, REFRIGERATOR, MONITOR, ROOM, ETC}
enum ItemStatus {RESERVED, FASTSELL, SOLDOUT, TRADING}

class Item{
  String? sellingTitle;
  ItemType? itemType;
  ItemQuality itemQuality;
  String? sellerName;
  String? sellerImage;
  String? sellerSchoolNum;
  int sellingPrice;
  String? itemDetail;
  String? uploadDate;
  DateTime? uploadDateForCompare;
  bool? isLiked;
  List<XFile> imageListA;
  List<String> imageListB;
  ItemStatus itemStatus;

  Item( //생성자
      { required this.sellingTitle,
        required this.itemType,
        required this.itemQuality,
        required this.sellerName,
        required this.sellerImage,
        required this.sellingPrice,
        required this.isLiked,
        required this.sellerSchoolNum,
        this.itemDetail,
        required this.uploadDate,
        required this.uploadDateForCompare,
        required this.imageListA,
        required this.imageListB,
        required this.itemStatus}
      );

}
