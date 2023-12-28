import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

// class ChattingRooms extends StatelessWidget {
//   const ChattingRooms({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Stack(
//         children: [
//           Card(
//             elevation: 0,
//             margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 7, bottom: 7, left: 7, right: 10),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(50.0),
//                     child: Image.asset("assets/images/icons/product.png",
//                         width: 65, height: 65, fit: BoxFit.contain),
//                   ),
//                 ),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               "김포닉스",
//                               style: const TextStyle(
//                                   fontSize: 25, fontWeight: FontWeight.bold),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "방금 전",
//                                 style: const TextStyle(fontSize: 13),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 7),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 "안녕하세요",
//                                 style: const TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.normal,
//                                     overflow: TextOverflow.ellipsis),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class ExpandImage extends StatelessWidget {
  final String recieveUrl;
  const ExpandImage(this.recieveUrl, {Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // 여기에 원하는 배경색을 설정하세요
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 3.0,
                child: Container(

                  child:
                  Image.network(
                    recieveUrl,
                    fit: BoxFit.contain,
                  ),
                ))
            ,
            // X 버튼을 가진 AppBar
            Positioned(
              top: 40.0,
              left: 10.0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}