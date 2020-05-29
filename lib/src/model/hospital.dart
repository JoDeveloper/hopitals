class Hospital {
  final String name;
  final String phone;
  final String city;
  final String details;

  Hospital({
    this.name,
    this.phone,
    this.city,
    this.details,
  });

  Hospital.fromJson(Map<String, Object> parsedJson)
      : name = parsedJson['name'],
        phone = parsedJson['phone'],
        city = parsedJson['city'],
        details = parsedJson['details'];

  @override
  String toString() {
    return 'Hospital(name: $name, phone: $phone, city: $city, details: $details)';
  }
}
