import 'package:hive_flutter/hive_flutter.dart';

part 'sync_models.g.dart';

@HiveType(typeId: 1, adapterName: 'SyncTypeAdapter')
class SyncType extends HiveObject {
  @HiveField(0)
  String synckey;
  @HiveField(1)
  dynamic syncValue;

  SyncType({required this.synckey, required this.syncValue});

  factory SyncType.fromList(List<dynamic> value) {
    return SyncType(synckey: value[0], syncValue: value[1]);
  }

  List<dynamic> toList() {
    return [synckey, syncValue];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncType &&
        other.synckey == synckey &&
        other.syncValue == syncValue;
  }

  @override
  int get hashCode {
    return synckey.hashCode ^ syncValue.hashCode;
  }
}
