// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../entity/item_entity.dart';
// import '../page/my_page/sub_selling_page_modify_page.dart';
//
// var f = NumberFormat('###,###,###,###'); //숫자 가격 콤마 표시
// Color postechRed = Color(0xffac145a);
//
//
// class ModifyCard(List<Item> list, int position) extends StatefulWidget{
//
//
// }
//
// @override
// Widget build(BuildContext context) {
//   return GestureDetector(
//       child: Card(
//         margin: const EdgeInsets.symmetric(
//             vertical: 10, horizontal: 10),
//         elevation: 1,
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Row(
//                   children: [
//                     Padding(padding: const EdgeInsets.only(
//                         top: 10, bottom: 10, left: 10, right: 15),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child:list![position].imageListB.isEmpty?
//                         Image.asset( "assets/images/main_logo.jpg",width: 100, height: 100, fit: BoxFit.cover) :
//                         Image.network(list![position].imageListB[0], width: 100, height: 100, fit: BoxFit.cover),
//                       ),
//                     ),
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(list![position]
//                                       .sellingTitle!,
//                                       style: const TextStyle(
//                                           fontSize: 20),
//                                       overflow: TextOverflow
//                                           .ellipsis),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                       "등록 일자: ${list![position]
//                                           .uploadDate ?? ""}",
//                                       style: const TextStyle(
//                                           fontSize: 10),
//                                       overflow: TextOverflow
//                                           .ellipsis),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text("가격: ${f.format(list![position].sellingPrice!)}원",
//                                       style: const TextStyle(fontSize: 10),
//                                       overflow: TextOverflow.ellipsis),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 //isQucikSell이 true라면 표시
//                 list![position].itemStatus == ItemStatus.USERFASTSELL?
//                 Positioned(
//                   right: 10,
//                   bottom: 10,
//                   child: Container(
//                     width: 60,
//                     height: 25,
//                     decoration: BoxDecoration(
//                       color: postechRed,
//                       borderRadius: const BorderRadius.all(
//                           Radius.circular(10.0)),
//                     ),
//                     child: const Align(
//                       alignment: Alignment.center,
//                       child: Text("급처분",
//                         style: TextStyle(color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ) : const SizedBox(width: 0, height: 0),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 100,
//                   height: 25,
//                   decoration: BoxDecoration(
//                     color: Colors.yellow[200],
//                     borderRadius: const BorderRadius.all(
//                         Radius.circular(10.0)),
//                   ),
//                   child: MaterialButton(
//                     onPressed: () async {
//                       final newData = await Navigator.push(context, MaterialPageRoute(
//                           builder: (context) =>
//                               SubSellingPageModifyPage(item: list![position])));
//                       setState(() {
//                         if (newData.returnType == "modified") {
//                           //userName 여기서 등록
//                           list?[position].itemDetail =
//                           newData.itemDetail!;
//                           list?[position].sellingTitle =
//                           newData.sellingTitle!;
//                           list?[position].itemQuality =
//                           newData.itemQuality!;
//                           list?[position].itemQuality =
//                           newData.itemQuality!;
//                           list?[position].itemStatus =
//                               newData.itemStatus;
//                           list?[position].itemType =
//                               newData.itemType;
//                           list?[position].sellingPrice =
//                               newData.sellingPrice;
//                           list?[position].itemType =
//                               newData.itemType;
//                           list?[position].imageListB =
//                               newData.imagePath;
//                           //수정하면 시간도 방금전 업데이트
//                           list?[position].uploadDate = "방금 전";
//                           list?[position].uploadDateForCompare =
//                               DateTime.now();
//                         }
//                       });
//                     },
//                     child: const Text("수정하기",
//                       style: TextStyle(color: Colors.black45,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   width: 100,
//                   height: 25,
//                   decoration: BoxDecoration(
//                     color: postechRed,
//                     borderRadius: const BorderRadius.all(
//                         Radius.circular(10.0)),
//                   ),
//                   child: MaterialButton(
//                     onPressed: () {
//                       setState(() {
//                         list?.removeAt(position);
//                         myUserInfo.userItemNum = (myUserInfo.userItemNum! - 1)!;
//                         //instance delete는 나중에 생각해보자
//                       });
//                     },
//                     child: const Text("삭제하기",
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(
//             builder: (context) =>
//                 SubHomePage(item: list![position], user: fetchUserInfo(list![position]))));
//       }
//   );
// }