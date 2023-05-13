import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_yaiverse_mobile/models/3d_model.dart';
import 'package:studio_yaiverse_mobile/services/api_service.dart';
import 'package:studio_yaiverse_mobile/views/home_view.dart';
import 'package:studio_yaiverse_mobile/widgets/3d_model_viewer.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String username = widget.username;

  final Future<SharedPreferences> _id = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  void removeId() async {
    final SharedPreferences prefs = await _id;
    await prefs.remove("ID");
  }

  void _logOut() {
    removeId();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const StudioYaiverseHome(title: "Studio YAIverse"),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Future<List<GetThreeDList>> threedList = ApiService.getThreeDList(username);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        actions: [
          IconButton(onPressed: _logOut, icon: const Icon(Icons.logout_rounded))
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
        centerTitle: true,
        title: const Center(
            child: Text(
          "Studio YAIVERSE",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        )),
      ),
      body: RefreshIndicator(
        color: const Color.fromRGBO(223, 97, 127, 1),
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: threedList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                    child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .4),
                    const Text("3D 모델을 만들어보세요!"),
                  ],
                ));
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [Expanded(child: makeList(snapshot))],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(223, 97, 127, 1)),
            );
          },
        ),
      ),
    );
  }

  GridView makeList(AsyncSnapshot<List<GetThreeDList>> snapshot) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 1개의 행에 항목을 3개씩
        crossAxisSpacing: 1,
        childAspectRatio: 1,
        mainAxisSpacing: 1,

        /// 2,
      ),
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      itemBuilder: (context, index) {
        var models = snapshot.data![index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ThreeDModelViewer(
                            username: username,
                            name: models.name,
                            isPreview: false,
                          )),
                );
              },
              child: ClipRect(

                  // backgroundColor: const Color(0xffBB2649),
                  // radius: 60, // MediaQuery.of(context).size.width / 9,
                  child: Image.network(models.thumbnail, headers: const {
                "User-Agent":
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
              })),
            ),
            // const SizedBox(
            //   height: 2,
            // ),
            // Text(
            //   models.name,
            //   style: const TextStyle(
            //     fontSize: 12,
            //   ),
            // ),
          ],
        );
      },
      //separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }
}
