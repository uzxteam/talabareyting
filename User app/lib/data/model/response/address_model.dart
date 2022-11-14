class AddressModel {
  int id;
  String addressType;
  String contactPersonNumber;
  String address;
  String additionalAddress;
  String latitude;
  String longitude;
  int zoneId;
  List<int> zoneIds;
  String method;
  String contactPersonName;
  String streetNumber;
  String house;
  String floor;

  AddressModel(
      {this.id,
      this.addressType,
      this.contactPersonNumber,
      this.address,
      this.additionalAddress,
      this.latitude,
      this.longitude,
      this.zoneId,
      this.zoneIds,
      this.method,
      this.contactPersonName,
      this.streetNumber,
      this.house,
      this.floor,
      });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    additionalAddress = json['additional_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    zoneIds = json['zone_ids'] != null ? json['zone_ids'].cast<int>() : null;
    method = json['_method'];
    contactPersonName = json['contact_person_name'];
    streetNumber = json['road'];
    house = json['house'];
    floor = json['floor'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_type'] = this.addressType;
    data['contact_person_number'] = this.contactPersonNumber;
    data['address'] = this.address;
    data['additional_address'] = this.additionalAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zone_id'] = this.zoneId;
    data['zone_ids'] = this.zoneIds;
    data['_method'] = this.method;
    data['contact_person_name'] = this.contactPersonName;
    data['road'] = this.streetNumber;
    data['house'] = this.house;
    data['floor'] = this.floor;
    return data;
  }
}
