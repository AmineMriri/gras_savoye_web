class User {
  //final int id;
  final String login;

  User({
    //required this.id,
    required this.login,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      //id: json['id'],
      login: json['login'],
    );
  }
}