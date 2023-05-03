class ThreeDModel {
  final String title, thumb, id; //description;
  ThreeDModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
  //description = json['description'];
}

class GetThreeDList {
  final String name, description, file, thumbnail;
  GetThreeDList.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        thumbnail = json['thumbnail'],
        file = json['file'];
}

class Gen3D {
  final String name, description, text;
  Gen3D.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        text = json['text'];
}
