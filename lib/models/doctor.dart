class Doctor {
  final int docId;
  final String name;
  final String? speciality;
  final String? email;
  final String? phone;
  //final String region;
  final String? address;

  Doctor({
    required this.docId,
    required this.name,
    this.speciality,
    this.phone,
    this.email,
    //required this.region,
    this.address,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      docId: json['doc_id'],
      name: json['name'],
      speciality: json['speciality'] == false ? null : json['speciality'],
      address: json['address'] == false ? null : json['address'],
      //region: json['region'],
      phone: json['phone'] == false ? null : json['phone'],
      email: json['email'] == false ? null : json['email'],
    );
  }
  @override
  String toString() {
    return 'Doctor{docId: $docId, name: $name, speciality: $speciality, address: $address, phone: $phone, email: $email}';
  }
}
