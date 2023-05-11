class GetThreeDList {
  final String name, description, file, thumbnail;
  GetThreeDList.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        thumbnail = json['thumbnail'],
        file = json['file'];
}

class Gen3D {
  final String name, description, text, thumbnail;
  Gen3D.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        text = json['text'],
        thumbnail = json['thumbnail'];
}

class Toggle {
  final toggle, thumbnail;
  Toggle.fromJson(Map<String, dynamic> json)
      : toggle = json['toggle'],
        thumbnail = json['thumbnail'];
}
