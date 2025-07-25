class UserModel {
  final String userId;
  final String name;
  final String username;
  final String email;

  UserModel({
    required this.userId,
    required this.name,
    required this.username,
    required this.email,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      userId: id,
      name: data['name'],
      username: data['username'],
      email: data['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'username': username,
      'email': email,
    };
  }
}
