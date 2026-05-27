class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatar = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? 'Unknown User',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone, 'avatar': avatar};
  }
}
