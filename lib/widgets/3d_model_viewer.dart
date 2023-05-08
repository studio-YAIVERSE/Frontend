import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

//TODO
// 삭제 요청
// 3D view
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
      body: ModelViewer(
        src: "http://studio-yaiverse.kro.kr/main/get/$username/$name",
        //"http://studio-yaiverse.kro.kr/media/Object3D/2023-05-04/377ec079f19d49b5b01114e26eb14157_20230504152208/car.glb", //'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        alt: "A 3D model of an astronaut",
        ar: false,
        autoRotate: true,
        cameraControls: true,
        backgroundColor: Colors.black,
      ),
    );
  }
}
