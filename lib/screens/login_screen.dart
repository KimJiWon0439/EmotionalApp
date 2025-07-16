import 'package:flutter/material.dart';
import 'nickname_screen.dart'; // 별명 입력화면

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: '이메일')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: '비밀번호'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('로그인 성공!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => NicknameScreen()),
                          );
                        },
                        child: Text('확인'),
                      )
                    ],
                  ),
                );
              },
              child: Text('로그인'),
            )
          ],
        ),
      ),
    );
  }
}
