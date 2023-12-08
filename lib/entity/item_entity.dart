import 'package:image_picker/image_picker.dart';

enum ItemQuality {HIGH, MID, LOW}
enum ItemType{BOOK, CLOTHES, REFRIGERATOR, MONITOR, ROOM, ETC}
enum ItemStatus {RESERVED, USERFASTSELL, SUPOFASTSELL, SOLDOUT, TRADING, DELETED}

class Item{
  int? itemID;
  String? sellingTitle;
  ItemType? itemType;
  ItemQuality itemQuality;
  String? sellerName;
  String? sellerImage;
  String? sellerSchoolNum;
  int sellingPrice;
  String? sellerUid;
  String? itemDetail;
  String? uploadDate;
  DateTime? uploadDateForCompare;
  bool? isLiked;
  List imageListA;
  List<String> imageListB;
  ItemStatus itemStatus;
  String? buyingDate;
  DateTime? buyingDateForCompare;

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
        required this.itemStatus,
        required this.itemID,
        this.sellerUid,
        this.buyingDate,
        this.buyingDateForCompare}
      );

}
