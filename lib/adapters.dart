import 'package:hive/hive.dart';
import 'birthday_model.dart'; // Import birthday model


class BirthdayAdapter extends TypeAdapter<Birthday> {
  @override
  final int typeId = 1;

  @override
  Birthday read(BinaryReader reader) {
    final name = reader.readString();
    final dateOfBirth = DateTime.parse(reader.readString());
    final id = reader.readInt(); // Assuming 'id' is a required field
    return Birthday(name: name, dateOfBirth: dateOfBirth, id: id);
  }

  @override
  void write(BinaryWriter writer, Birthday obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.dateOfBirth.toString());
    writer.writeInt(obj.id); // Assuming 'id' is a required field
  }
}
