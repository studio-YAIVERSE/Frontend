import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:studio_yaiverse_mobile/services/api_service.dart';

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
                bottom: 28,
                right: 80,
                child: GestureDetector(
                  onTap: () {
                    ApiService.delete(username, name);
                  },
                  child: ClipRect(
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: const Text("Delete"),
                    ),
                  ),
                )),
          ],
        ));
  }
}
