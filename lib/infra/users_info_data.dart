import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../entity/user_entity.dart';

List<UserCredential> allUserList = List.empty(growable: true);

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

int allQuicksellNum = 0;
