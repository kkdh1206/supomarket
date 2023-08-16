import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

enum SortType{PRICEASCEND, PRICEDESCEND, DATEASCEND, DATEDESCEND}

Color postechRed = const Color(0xffac145a);

var f = NumberFormat('###,###,###,###'); //숫자 가격 콤마 표시