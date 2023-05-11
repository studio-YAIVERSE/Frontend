import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:studio_yaiverse_mobile/services/api_service.dart';
import 'package:studio_yaiverse_mobile/views/home_view.dart';

class ThreeDModelViewer extends StatelessWidget {
  final String name, username;
  bool isPreview;
  ThreeDModelViewer(
      {super.key,
      required this.username,
      required this.name,
      required this.isPreview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isPreview
            ? null
            : AppBar(
                title: const Text("3D Model Viewer"),
              ),
        body: Stack(
          children: [
            ModelViewer(
              src: "http://studio-yaiverse.kro.kr/main/get/$username/$name",
              alt: "A 3D model of an astronaut",
              ar: true,
              autoRotate: true,
              cameraControls: true,
              backgroundColor: Colors.black,
            ),
            if (isPreview)
              Positioned(
                  top: 32,
                  left: 24,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 32,
                    ),
                  )),
            Positioned(
                bottom: 16,
                right: 80,
                child: GestureDetector(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                content: const Text('모델을 삭제할까요?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => {
                                      ApiService.delete(username, name),
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const StudioYaiverseHome(
                                                    title: "Studio YAIverse"),
                                          ),
                                          (route) => false)
                                    },
                                    child: const Text(
                                      '확인',
                                      style:
                                          TextStyle(color: Color(0xffBB2649)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ]));
                  },
                  child: Container(
                    //margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        border: Border.all(width: 2, color: Colors.white)),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
          ],
        ));
  }
}
