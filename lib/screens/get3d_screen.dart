import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetThreeD extends StatefulWidget {
  const GetThreeD({super.key});

  @override
  State<GetThreeD> createState() => _GetThreeDState();
}

class _GetThreeDState extends State<GetThreeD>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PickedFile? _image;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  Future getImageFromCam() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future getImageFromGallery() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

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
            Container(
              height: 200,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
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
                indicator:
                    const BoxDecoration(color: Color.fromRGBO(223, 97, 127, 1)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                controller: _tabController,
              ),
            ),
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
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Title",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                                decoration: InputDecoration(
                              labelText: 'The Object Name to Save',
                            ))),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Text Prompt",
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                                decoration: InputDecoration(
                              labelText:
                                  'Prompt the text to generate a 3D Model',
                            ))),
                        SizedBox(
                          height: 48,
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
                          child: Stack(children: [
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
                                ))
                          ]),
                        ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => {
                  //TODO
                  // POST Generation 3D Model
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffBB2649))),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
