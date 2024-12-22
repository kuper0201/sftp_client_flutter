class EntryData {
  String name;
  Type type;
  int? modifyTime;
  int? accesstime;
  int? size;

  EntryData({required this.name, required this.type, this.size, this.modifyTime, this.accesstime});
}

enum Type {
  file,
  directory,
}