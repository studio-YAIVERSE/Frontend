import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_yaiverse_mobile/services/api_service.dart';
import 'package:studio_yaiverse_mobile/views/home_view.dart';
import 'package:studio_yaiverse_mobile/widgets/3d_model_viewer.dart';

class GetThreeD extends StatefulWidget {
  const GetThreeD({super.key});

  @override
  State<GetThreeD> createState() => _GetThreeDState();
}

class _GetThreeDState extends State<GetThreeD>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final textcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final img_namecontroller = TextEditingController();
  String? _username;
  XFile? _image;
  String? result_thumb;
  bool loading = false;
  bool is_result = false;
  bool toggle_effect = false;
  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _loadUserId();
    super.initState();
  }

  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('ID');
    });
  }

  @override
  void dispose() {
    textcontroller.dispose();
    namecontroller.dispose();
    img_namecontroller.dispose();
    super.dispose();
  }

  Future getImageFromCam() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Studio"),
        ),
        body: Column(
          children: [
            // Preview
            if (result_thumb == null && !is_result)
              Container(
                height: 224,
                decoration: const BoxDecoration(color: Colors.grey),
              )
            else if (loading)
              Container(
                height: 256,
                decoration: const BoxDecoration(color: Colors.black),
                child: const Center(
                    child: CircularProgressIndicator(
                        color: Color.fromRGBO(223, 97, 127, 1))),
              )
            else
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      fullscreenDialog: true,
                      pageBuilder: (_, __, ___) => ThreeDModelViewer(
                            username: _username!,
                            name: namecontroller.text,
                            isPreview: true,
                          )));
                },
                child: (Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(result_thumb!),
                          fit: BoxFit.cover)),
                  height: 256,
                )),
              ),
            if (result_thumb == null && !is_result)
              // TabBar
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.black,
                    width: .5,
                  )),
                ),
                child: TabBar(
                  tabs: [
                    Container(
                      height: 32,
                      alignment: Alignment.center,
                      child: const Text(
                        'Text',
                      ),
                    ),
                    Container(
                      height: 32,
                      alignment: Alignment.center,
                      child: const Text(
                        'Camera',
                      ),
                    ),
                  ],
                  indicator: const BoxDecoration(
                      color: Color.fromRGBO(223, 97, 127, 1)),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  controller: _tabController,
                ),
              ),
            if (result_thumb == null && !is_result)
              // Tab Contents
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    //Text Contents
                    SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                "Title",
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: TextField(
                                    controller: namecontroller,
                                    decoration: const InputDecoration(
                                      labelText: 'The Object Name to Save',
                                    ))),
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(
                                "Text Prompt",
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: TextField(
                                    controller: textcontroller,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Prompt the text to generate a 3D Model',
                                    ))),
                            const SizedBox(
                              height: 48,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (textcontroller.text == "" ||
                                      namecontroller.text == "") {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                                content: const Text(
                                                    '이름과 텍스트를 모두 입력해주세요!'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text(
                                                      '확인',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xffBB2649)),
                                                    ),
                                                  )
                                                ]));
                                  } else {
                                    setState(() {
                                      is_result = true;
                                      loading = true;
                                    });
                                    final response =
                                        await ApiService.GenThreeDbyText(
                                            _username!,
                                            textcontroller.text,
                                            namecontroller.text);

                                    setState(
                                      () {
                                        result_thumb = response.thumbnail;
                                        loading = false;
                                      },
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xffBB2649))),
                                child: const Text("Continue"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Image Pick Contents
                    _image == null
                        ? Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: getImageFromCam,
                                  child: const CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                GestureDetector(
                                  onTap: getImageFromGallery,
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.grey,
                                    child: Container(
                                      child: const Icon(
                                        Icons.photo_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Text(
                                        "Title",
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: TextField(
                                          controller: img_namecontroller,
                                          decoration: const InputDecoration(
                                            labelText:
                                                'The Object Name to Save',
                                          ))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                    image: Image.file(
                                                            File(_image!.path))
                                                        .image,
                                                    fit: BoxFit.cover)),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .3,
                                          ),
                                          Positioned(
                                            top: 6,
                                            left: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _image = null;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.cancel_sharp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (img_namecontroller.text == "") {
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                    content: const Text(
                                                        '이름을 입력해주세요!'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: const Text(
                                                          '확인',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xffBB2649)),
                                                        ),
                                                      )
                                                    ]));
                                      } else {
                                        setState(() {
                                          is_result = true;
                                          loading = true;
                                        });
                                        final response =
                                            await ApiService.GenThreeDbyImage(
                                                _username!,
                                                _image!.path,
                                                img_namecontroller.text);

                                        setState(() {
                                          result_thumb = response.thumbnail;
                                          loading = false;
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xffBB2649))),
                                    child: const Text("Continue"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              )
            else
              Container(
                alignment: Alignment.center,
                child: Column(children: [
                  const SizedBox(height: 32),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        loading
                            ? null
                            : Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StudioYaiverseHome(
                                            title: "Studio YAIverse")),
                                (route) => false);
                      },
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: const Color.fromRGBO(187, 38, 73, 1),
                        child: Icon(
                          Icons.check,
                          color: loading ? Colors.white54 : Colors.white,
                          size: 54,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          loading
                              ? null
                              : setState(() {
                                  loading = true;
                                });
                          final response = await ApiService.GenThreeDbyText(
                              _username!,
                              textcontroller.text,
                              namecontroller.text);

                          setState(
                            () {
                              result_thumb = response.thumbnail;
                              loading = false;
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor:
                              const Color.fromRGBO(223, 97, 127, 1),
                          child: Icon(
                            Icons.refresh,
                            color: loading ? Colors.white54 : Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final response = await ApiService.gettoggle(
                              _username!, namecontroller.text);

                          setState(
                            () {
                              result_thumb = response.thumbnail;
                              toggle_effect = response.toggle;
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: !toggle_effect
                              ? const Color.fromRGBO(147, 149, 151, 1)
                              : const Color.fromRGBO(223, 97, 127, 1),
                          child: Icon(
                            Icons.brush,
                            color: loading ? Colors.white54 : Colors.white,
                            size: 38,
                          ),
                        ),
                      )
                    ],
                  )
                ]),
              )
          ],
        ),
      ),
    );
  }
}
