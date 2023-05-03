class Accounts {
  final String username;
  Accounts.fromJson(Map<String, dynamic> json) : username = json['username'];
}
