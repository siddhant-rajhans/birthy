class Birthday {
  final String name;
  final DateTime dateOfBirth;
  final int id; // Assuming auto-incrementing ID

  Birthday({required this.name, required this.dateOfBirth, int? id}) : this.id = id ?? DateTime.now().millisecondsSinceEpoch;

  factory Birthday.fromJson(Map<String, dynamic> json) => Birthday(
    name: json['name'] as String,
    dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
    id: json['id'] as int, // Assuming 'id' field exists in JSON
  ); 

  Map<String, dynamic> toJson() => {
    'name': name,
    'dateOfBirth': dateOfBirth.toString(),
    'id': id, // Add 'id' to JSON if needed for serialization/deserialization
  };

  // Getter for unique key (assuming ID is unique)
  int get key => id;

  Birthday copyWith({String? name, DateTime? dateOfBirth, int? id}) {
    return Birthday(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      id: id ?? this.id,
    );
  }
}
