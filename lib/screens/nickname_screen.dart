import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/calendar_screen.dart';


class NicknameScreen extends StatefulWidget {
  @override
  _NicknameScreenState createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('뭐라고 부를까요?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: '별명을 입력해보세요'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String nickname = _controller.text.trim();
                if (nickname.isNotEmpty) {
                  // CalendarScreen으로 이동 + 별명 전달
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(nickname: nickname),
                    ),
                  );
                }
              },
              child: Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}
