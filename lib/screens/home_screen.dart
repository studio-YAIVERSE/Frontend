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
  Future<List<ThreeDModel>> threedmodels = ApiService.getThreeDModels();

  final Future<SharedPreferences> _id = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    // Future<List<GetThreeDList>> threedList =
    //     ApiService.getThreeDList(widget.username);
  }

  void removeId() async {
    final SharedPreferences prefs = await _id;
    await prefs.remove("ID");
  }

  void _logOut() {
    removeId();
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            const StudioYaiverseHome(title: "Studio YAIverse"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        actions: [
          IconButton(onPressed: _logOut, icon: const Icon(Icons.logout_rounded))
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
        title: const Center(
            child: Text(
          "Studio YAIVERSE",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        )),
      ),
      body: FutureBuilder(
        future: threedmodels,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [Expanded(child: makeList(snapshot))],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

GridView makeList(AsyncSnapshot<List<ThreeDModel>> snapshot) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // 1개의 행에 항목을 3개씩
      crossAxisSpacing: 10,
      childAspectRatio: 1 / 2,
    ),
    scrollDirection: Axis.vertical,
    itemCount: snapshot.data!.length,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemBuilder: (context, index) {
      var webtoon = snapshot.data![index];
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ThreeDModelViewer(file: webtoon.thumb)),
              );
            },
            child: CircleAvatar(
                radius: 60, // MediaQuery.of(context).size.width / 9,
                backgroundImage: NetworkImage(webtoon.thumb, headers: const {
                  "User-Agent":
                      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                })),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            webtoon.title,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      );
    },
    //separatorBuilder: (context, index) => const SizedBox(width: 40),
  );
}
