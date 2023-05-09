import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_yaiverse_mobile/services/api_service.dart';
import 'package:studio_yaiverse_mobile/views/home_view.dart';

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
  String? _username;
  XFile? _image;
  String? result_thumb;
  bool loading = false;
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
        body: loading
            ? const Center(
                child: CircularProgressIndicator(
                    color: Color.fromRGBO(223, 97, 127, 1)))
            : Column(
                children: [
                  // Preview
                  if (result_thumb == null)
                    Container(
                      height: 224,
                      decoration: const BoxDecoration(color: Colors.grey),
                    )
                  else
                    (Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(result_thumb!),
                              fit: BoxFit.cover)),
                      height: 224,
                    )),
                  if (result_thumb == null)
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
                  if (result_thumb == null)
                    // Tab Contents
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          //Text Contents
                          Container(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
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
                                          loading = true;
                                        });
                                        final response =
                                            await ApiService.GenThreeDbyText(
                                                _username!,
                                                textcontroller.text,
                                                namecontroller.text);
                                        final imageThumbnail =
                                            response.thumbnail_uri;
                                        setState(
                                          () {
                                            result_thumb =
                                                "http://studio-yaiverse.kro.kr$imageThumbnail";
                                            loading = false;
                                          },
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xffBB2649))),
                                    child: const Text("Continue"),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Image Pick Contents
                          _image == null
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          child: Image.file(File(_image!.path)),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _image = null;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.cancel_outlined,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color(
                                                            0xffBB2649))),
                                            child: const Text("Continue"),
                                          ),
                                        ),
                                      ]),
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
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const StudioYaiverseHome(
                                              title: "Studio YAIverse")),
                                  (route) => false);
                            },
                            child: const CircleAvatar(
                              radius: 42,
                              backgroundColor: Color(0xffBB2649),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
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
                                setState(() {
                                  loading = true;
                                });
                                final response =
                                    await ApiService.GenThreeDbyText(
                                        _username!,
                                        textcontroller.text,
                                        namecontroller.text);
                                final imageThumbnail = response.thumbnail_uri;
                                setState(
                                  () {
                                    result_thumb =
                                        "http://studio-yaiverse.kro.kr$imageThumbnail";
                                    loading = false;
                                  },
                                );
                              },
                              child: const CircleAvatar(
                                radius: 34,
                                backgroundColor:
                                    Color.fromRGBO(223, 97, 127, 1),
                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 38,
                                ),
                              ),
                            ),
                            const CircleAvatar(
                              radius: 34,
                              backgroundColor: Color.fromRGBO(223, 97, 127, 1),
                              child: Icon(
                                Icons.brush,
                                color: Colors.white,
                                size: 38,
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
