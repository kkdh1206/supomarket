// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../infra/my_info_data.dart';
//
// //final dio= Dio();
//
// enum AuthStatus { // 임의로 만들어준 상태
//   registerSuccess,
//   registerFail,
//   loginSuccess,
//   loginFail,
//   verifySuccess,
//   verifyFail,
//   checkingEmail
// }
//
// bool checkForArrive = false;
// bool isPressed = false;
//
// class FirebaseAuthProvider with ChangeNotifier {
//   FirebaseAuth firebaseAuth;
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   FirebaseAuthProvider({auth}) : firebaseAuth = auth ?? FirebaseAuth.instance;
//
//   Future<AuthStatus> signInWithEmailAndPassword(String id, String password) async {
//     try {
//       final credential = await firebaseAuth.signInWithEmailAndPassword(
//           email: id,
//           password: password
//       );
//       if(credential.user != null){
//         myUserInfo.isUserLogin = true;
//         checkForArrive =  true;
//         prefs.setBool('isLogin', true);
//         prefs.setString('email', id);
//         prefs.setString('password', password);
//
//         return AuthStatus.loginSuccess;
//       }
//       else{
//         myUserInfo.isUserLogin = false;
//         return AuthStatus.loginFail;
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         //_notUserPopUp();
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         //_wrongPasswordPopUp();
//         print('Wrong password provided for that user.');
//       }
//     }
//
//     checkForArrive = false;
//     return AuthStatus.loginFail;
//   }
//
//   Future<void> logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isLogin', false);
//     prefs.setString('email', '');
//     prefs.setString('password', '');
//     user = null;
//     await authClient.signOut(); // 로그아웃 시키는 코드
//   }