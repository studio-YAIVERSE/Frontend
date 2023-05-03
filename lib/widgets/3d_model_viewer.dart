import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

//TODO
// 삭제 요청
// 3D view
class ThreeDModelViewer extends StatelessWidget {
  final String file;
  const ThreeDModelViewer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("3D Model Viewer"),
      ),
      body: ModelViewer(
        src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        alt: "A 3D model of an astronaut",
        ar: false,
        autoRotate: true,
        cameraControls: true,
        backgroundColor: Colors.black,
      ),
    );
  }
}
