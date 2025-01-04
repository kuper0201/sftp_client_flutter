class EntryData {
  String name;
  String absolutePath;
  Type type;
  int? modifyTime;
  int? accesstime;
  int? size;

  bool isSelected;

  EntryData({required this.name, required this.absolutePath, required this.type, this.size, this.modifyTime, this.accesstime, this.isSelected = false});
}

enum Type {
  file,
  directory,
}