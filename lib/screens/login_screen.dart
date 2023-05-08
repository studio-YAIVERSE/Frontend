// use local storage
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_yaiverse_mobile/services/api_service.dart';
import 'package:studio_yaiverse_mobile/views/home_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idController = TextEditingController();

  void _login(idValue) {
    _storeId(idValue);
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            const StudioYaiverseHome(title: "Studio YAIverse"),
      ),
    );
  }

  Future<void> _storeId(idValue) async {
    ApiService().registerAccount(idValue);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("ID", idValue);
    // TODO
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const [
                Text(
                  "Studio",
                  style: TextStyle(fontSize: 48),
                ),
                Text(
                  "YAIVERSE",
                  style: TextStyle(fontSize: 48),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID',
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: () => {
              idController.text.isEmpty
                  ? showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                              content: const Text('ID를 입력해주세요'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    '확인',
                                    style: TextStyle(color: Color(0xffBB2649)),
                                  ),
                                )
                              ]))
                  : _login(idController.text)
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xffBB2649))),
            child: const Text("NEXT"),
          )
        ],
      ),
    );
  }
}
