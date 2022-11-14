class RecordLocationBody {
  String token;
  double longitude;
  double latitude;
  String location;

  RecordLocationBody({this.token, this.longitude, this.latitude, this.location});

  RecordLocationBody.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    longitude = json['longitude'].toDouble();
    latitude = json['latitude'].toDouble();
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['location'] = this.location;
    return data;
  }
}
