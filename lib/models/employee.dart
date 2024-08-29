class Employee {
  int? id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String countryCode;
  double salary;
  bool isFulltime;
  String gender;
  String department;
  DateTime? createdAt;
  DateTime? updatedAt;

  Employee({
    this.id,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.countryCode = '',
    this.salary = 0.0,
    this.isFulltime = true,
    this.gender = '',
    this.department = '',
    this.createdAt,
    this.updatedAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      countryCode: json['country_code'],
      salary: json['salary'].toDouble(),
      isFulltime: json['is_fulltime'],
      gender: json['gender'],
      department: json['department'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      'salary': salary,
      'is_fulltime': isFulltime,
      'gender': gender,
      'department': department,
    };
  }
}
