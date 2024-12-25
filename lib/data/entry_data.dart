class EntryData {
  String name;
  Type type;
  int? modifyTime;
  int? accesstime;
  int? size;

  bool isSelected;

  EntryData({required this.name, required this.type, this.size, this.modifyTime, this.accesstime, this.isSelected = false});
}

enum Type {
  file,
  directory,
}