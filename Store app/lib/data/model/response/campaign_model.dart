class CampaignModel {
  int id;
  String title;
  String image;
  String description;
  String createdAt;
  String updatedAt;
  String startTime;
  String endTime;
  String availableDateStarts;
  String availableDateEnds;
  bool isJoined;

  CampaignModel(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.startTime,
        this.endTime,
        this.availableDateStarts,
        this.availableDateEnds,
        this.isJoined});

  CampaignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    availableDateStarts = json['available_date_starts'];
    availableDateEnds = json['available_date_ends'];
    isJoined = json['is_joined'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['available_date_starts'] = this.availableDateStarts;
    data['available_date_ends'] = this.availableDateEnds;
    data['is_joined'] = this.isJoined;
    return data;
  }
}
