import 'package:flutter/material.dart';
import 'screens/nickname_screen.dart'; // 시작 화면

void main() {
  runApp(EmotionDiaryApp());
}

class EmotionDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '감정 다이어리',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard', // 있으면
      ),
      home: NicknameScreen(), // 첫 진입 화면
    );
  }
}
