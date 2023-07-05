import 'package:flutter/material.dart';
import 'chatting_page.dart';
import 'log_in_page.dart';
import 'my_page.dart';


class CategoryPage extends StatefulWidget{
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryButton(context, Colors.greenAccent, "냉장고", const Icon(Icons.kitchen_outlined, size: 40)),
              CategoryButton(context, Colors.blueGrey, "의류", const Icon(Icons.checkroom_outlined, size: 40)),
              CategoryButton(context, Colors.pinkAccent, "자취방", const Icon(Icons.maps_home_work_outlined, size: 40)),
              CategoryButton(context, Colors.yellow, "모니터", const Icon(Icons.desktop_windows_outlined, size: 40)),
              ]
          ),
           SizedBox(height: 30.0),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               CategoryButton(context, Colors.brown, "책", const Icon(Icons.menu_book_outlined, size: 40)),
               CategoryButton(context, Colors.blueGrey, "기타", const Icon(Icons.more_horiz_outlined, size: 40)),
             ],
           ),
          SizedBox(height: 30.0),
           // Expanded(
           //     child: Card(
           //         shape: const RoundedRectangleBorder(
           //             borderRadius: BorderRadius.all(Radius.circular(100))
           //         ),
           //         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
           //         elevation: 2,
           //         child: Container(height: 400, color:Colors.yellow)
           //     ),
           // )
        ],
      ),
    );
  }
}



Widget CategoryCard(Color color, String text){
  return Card(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30))
    ),
    color : color,
    child: SizedBox(
      width: 150, height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, textAlign: TextAlign.center, textScaleFactor: 2),
        ],
      ),
    ),
  );
}



Widget CategoryButton(BuildContext context, Color color, String text, Icon icon){
  return Column(
    children: [
      MaterialButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => LogInPage()),
        );
      },
        //동그라미만 클릭되게
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50.0)),
          child: icon,
        ),
      ),
      const SizedBox(height: 5),
      Text(text),
    ],
  );
}