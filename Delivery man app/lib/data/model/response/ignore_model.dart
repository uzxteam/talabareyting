import 'package:intl/intl.dart';

class IgnoreModel {
  int id;
  DateTime time;

  IgnoreModel({this.id, this.time});

  IgnoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = DateFormat('dd-MM-yyyy HH:mm').parse(json['time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = DateFormat('dd-MM-yyyy HH:mm').format(this.time);
    return data;
  }
}
