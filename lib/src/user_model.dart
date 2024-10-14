class User {
  String id;
  String name;
  String email;
  // String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    //required this.password
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name, 'email': email,
      //'password': password
    };
  }

  User.fromMap(Map<String, dynamic> map, String id)
      : id = id,
        name = map['name'],
        email = map['email'];
  //password = map['password'];
}
