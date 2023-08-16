import 'dart:io';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supo_market/entity/user_entity.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/util_function.dart';
import '../../entity/item_entity.dart';
import 'package:flutter/services.dart';



class SubPicturePage extends StatelessWidget {
  final url;

  const SubPicturePage({super.key, this.url});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children: [
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 3,
                child: Container(
                  child: Image.network(url, width: 500, height: 500, fit:BoxFit.cover),
                ),
              ),
              Positioned(
                  left: 10, top: 10,
                  child: IconButton(onPressed: () {
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.arrow_back, color: Colors.black45),
                      iconSize: 30)
              ),
            ],
          ),
        ),
    );
  }

}