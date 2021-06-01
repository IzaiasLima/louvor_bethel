class UserModel {
  String id;
  String name;
  String email;
  String password;
  String confirmPass;

  UserModel(
      {this.id = '', this.name = '', this.email = '', this.password = ''});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
    };
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    return data;
  }
}
