class RegisterRequestModel {
  RegisterRequestModel({
    required this.lastname,
    required this.firstname,
    required this.username,
    required this.email,
    required this.password,
  });
  late final String lastname;
  late final String firstname;
  late final String username;
  late final String email;
  late final String password;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    lastname = json['lastname'];
    firstname = json['firstname'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lastname'] = lastname;
    data['firstname'] = firstname;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
