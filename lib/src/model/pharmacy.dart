class Pharmacy {
  final String name;
  final String phone;
  final String city;
  final String drugName;

  Pharmacy({
    this.name,
    this.phone,
    this.city,
    this.drugName,
  });

  Pharmacy.fromJson(Map<String, Object> parsedJson)
      : name = parsedJson['name'],
        phone = parsedJson['phone'],
        city = parsedJson['city'],
        drugName = parsedJson['drugName'];
}
