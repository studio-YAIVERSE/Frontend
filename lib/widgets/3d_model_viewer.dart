import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDModelViewer extends StatelessWidget {
  final String name, username;
  const ThreeDModelViewer(
      {super.key, required this.username, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("3D Model Viewer"),
        ),
        body: Stack(
          children: [
            ModelViewer(
              src: "http://studio-yaiverse.kro.kr/main/get/$username/$name",
              //'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
              alt: "A 3D model of an astronaut",
              ar: false,
              autoRotate: true,
              cameraControls: true,
              backgroundColor: Colors.black,
            ),
            const Positioned(
                top: 18,
                right: 18,
                child: Icon(
                  size: 32,
                  Icons.delete_forever,
                  color: Colors.white,
                )),
          ],
        ));
  }
}
