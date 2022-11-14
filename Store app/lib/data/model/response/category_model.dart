class CategoryModel {
  int _id;
  String _name;
  String _image;

  CategoryModel(
      {int id,
        String name,
        int parentId,
        int position,
        int status,
        String createdAt,
        String updatedAt,
        String image}) {
    this._id = id;
    this._name = name;
    this._image = image;
  }

  int get id => _id;
  String get name => _name;
  String get image => _image;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['image'] = this._image;
    return data;
  }
}
