class ChatRoom{
  String? traderName;
  String? traderImage;
  String? itemName;
  String? sellingTitle;
  //String? tradeCategory;
  String? lastChattingDay;
  String? lastChattingSentence;

  ChatRoom(
  {
    required this.traderName,
    required this.traderImage,
    //required this.tradeCategory,
    required this.itemName,
    required this.sellingTitle,
    this.lastChattingDay,
    this.lastChattingSentence
  });
}