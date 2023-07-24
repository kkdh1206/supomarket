import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../entity/user_entity.dart';

List<UserCredential> allUserIDPWList = List.empty(growable: true);

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

final firebaseStorage = FirebaseStorage.instance;