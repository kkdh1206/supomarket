class Goods{
  String? sellingTitle;
  String? goodsName;
  String? goodsQuality;
  String? sellerName;
  int sellingPrice;
  String? imagePath_1;
  String? imagePath_2;
  String? imagePath_3;
  String? goodsNum;
  String? uploadDate;

  Goods( //생성자
      { required this.sellingTitle,
        required this.goodsName,
        required this.goodsQuality,
        required this.sellerName,
        required this.imagePath_1,
        required this.sellingPrice,
        this.imagePath_2,
        this.imagePath_3,
        this.goodsNum,
        this.uploadDate}
      );

}
