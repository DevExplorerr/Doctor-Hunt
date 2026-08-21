class AddressModel {
  final String name;
  final String address;
  final String phoneNumber;

  AddressModel({
    required this.name,
    required this.address,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'address': address,
    'phoneNumber': phoneNumber,
  };

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          address == other.address &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => name.hashCode ^ address.hashCode ^ phoneNumber.hashCode;
}
