class ZoneResponseModel {
  bool _isSuccess;
  List<int> _zoneIds;
  String _message;
  ZoneResponseModel(this._isSuccess, this._message, this._zoneIds);

  String get message => _message;
  List<int> get zoneIds => _zoneIds;
  bool get isSuccess => _isSuccess;
}