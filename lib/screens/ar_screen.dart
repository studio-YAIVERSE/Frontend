import 'dart:io' show Platform;
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:studio_yaiverse_mobile/models/3d_model.dart';
import 'package:studio_yaiverse_mobile/services/api_service.dart';
import 'package:vector_math/vector_math_64.dart';
//import 'dart:math';

class ObjectGesturesWidget extends StatefulWidget {
  final String username;
  const ObjectGesturesWidget({Key? key, required this.username})
      : super(key: key);
  @override
  _ObjectGesturesWidgetState createState() => _ObjectGesturesWidgetState();
}

class _ObjectGesturesWidgetState extends State<ObjectGesturesWidget> {
  late String username = widget.username;
  int selected_idx = 0;
  late String model_glb;
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      List<GetThreeDList> response = await ApiService.getThreeDList(username);
      model_glb = response[0].file;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<List<GetThreeDList>> threedmodels =
        ApiService.getThreeDList(username);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Studio YAIVERSE AR'),
        ),
        body: Container(
            child: Stack(children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: threedmodels,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Container();
                    }

                    return modelMenu(snapshot);
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(223, 97, 127, 1),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onRemoveEverything,
              child: const Icon(
                Icons.delete_forever,
                size: 24,
              ),
            ),
          ),
        ])));
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          customPlaneTexturePath: "./images/triangle.png",
          showPlanes: true,
          showWorldOrigin: true,
          handleTaps: true,
          handlePans: true,
          handleRotation: true,
        );
    this.arObjectManager!.onInitialize();
    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;
  }

  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
  }

  ListView modelMenu(AsyncSnapshot<List<GetThreeDList>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 20,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        //사용자가 보는 아이템만 빌드-> 메모리 최적화됨
        var threedmodel = snapshot.data![index];
        return Column(
          children: [
            GestureDetector(
              onTap: () => {
                setState(() {
                  selected_idx = index;
                  model_glb = threedmodel.file;
                })
              },
              child: CircleAvatar(
                radius: 26,
                backgroundColor: (index == selected_idx)
                    ? const Color.fromRGBO(223, 97, 127, 1)
                    : const Color.fromARGB(0, 0, 0, 0),
                child: CircleAvatar(
                    radius: 24, // MediaQuery.of(context).size.width / 9,
                    backgroundImage: NetworkImage(
                      threedmodel.thumbnail,
                      headers: const {
                        "User-Agent":
                            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                      },
                    )),
              ),
            )
          ],
        );
      },
      separatorBuilder: ((context, index) => const SizedBox(width: 8)),
    );
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    if (hitTestResults.isEmpty ||
        hitTestResults
            .where((e) => e.type == ARHitTestResultType.plane)
            .isEmpty) {
    } else {
      var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane,
      );
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri: model_glb,
            scale: Vector3(0.5, 0.5, 0.5) * (Platform.isIOS? 62.5: 1.0),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor =
            await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          nodes.add(newNode);
        } else {
          arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  onPanStarted(String nodeName) {}

  onPanChanged(String nodeName) {}

  onPanEnded(String nodeName, Matrix4 newTransform) {
    final pannedNode = nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {}

  onRotationChanged(String nodeName) {}

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    final rotatedNode = nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }
}
