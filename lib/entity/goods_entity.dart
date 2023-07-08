class Goods{
  String? sellingTitle;
  String? goodsType;
  String? goodsQuality;
  String? sellerName;
  String? sellerImage;
  int sellingPrice;
  String? goodsDetail;
  String? imagePath_1;
  String? imagePath_2;
  String? imagePath_3;
  String? goodsNum;
  String? uploadDate;
  DateTime? uploadDateForCompare;
  bool? isLiked;
  bool isQuickSell;

  Goods( //생성자
      { required this.sellingTitle,
        required this.goodsType,
        required this.goodsQuality,
        required this.sellerName,
        required this.sellerImage,
        required this.imagePath_1,
        required this.sellingPrice,
        required this.isLiked,
        required this.isQuickSell,
        this.goodsDetail,
        this.imagePath_2,
        this.imagePath_3,
        this.goodsNum,
        required this.uploadDate,
        required this.uploadDateForCompare,}
      );

}
