class CoinRate {
  int _status;
  String _message;
  CoinRateData _data;

  int get status => _status;

  String get message => _message;

  CoinRateData get data => _data;

  CoinRate({int status, String message, CoinRateData data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  CoinRate.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _data = json["data"] != null ? CoinRateData.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }
}

class CoinRateData {
  int _coinRateId;
  String _usdRate;
  String _createdAt;
  String _updatedAt;

  int get coinRateId => _coinRateId;

  String get usdRate => _usdRate;

  String get createdAt => _createdAt;

  String get updatedAt => _updatedAt;

  CoinRateData(
      {int coinRateId, String usdRate, String createdAt, String updatedAt}) {
    _coinRateId = coinRateId;
    _usdRate = usdRate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  CoinRateData.fromJson(dynamic json) {
    _coinRateId = json["coin_rate_id"];
    _usdRate = json["usd_rate"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["coin_rate_id"] = _coinRateId;
    map["usd_rate"] = _usdRate;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
