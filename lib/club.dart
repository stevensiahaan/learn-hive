import 'package:hive/hive.dart';
part 'club.g.dart';

@HiveType(typeId: 0)
class Club {
  @HiveField(0)
  String name;
  @HiveField(1)
  int championship;

  Club(this.name, this.championship);
}
