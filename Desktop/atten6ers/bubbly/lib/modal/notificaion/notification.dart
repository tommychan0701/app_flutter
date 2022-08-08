class UserNotifications {
  int _status;
  String _message;
  List<NotificationData> _data;

  int get status => _status;

  String get message => _message;

  List<NotificationData> get data => _data;

  UserNotifications({int status, String message, List<NotificationData> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserNotifications.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class NotificationData {
  String _fullName;
  String _userName;
  String _userProfile;
  int _senderUserId;
  int _receivedUserId;
  int _itemId;
  int _notificationType;
  String _message;

  String get fullName => _fullName;

  String get userName => _userName;

  String get userProfile => _userProfile;

  int get senderUserId => _senderUserId;

  int get receivedUserId => _receivedUserId;

  int get itemId => _itemId;

  int get notificationType => _notificationType;

  String get message => _message;

  NotificationData(
      {String fullName,
      String userName,
      String userProfile,
      int senderUserId,
      int receivedUserId,
      int itemId,
      int notificationType,
      String message}) {
    _fullName = fullName;
    _userName = userName;
    _userProfile = userProfile;
    _senderUserId = senderUserId;
    _receivedUserId = receivedUserId;
    _itemId = itemId;
    _notificationType = notificationType;
    _message = message;
  }

  NotificationData.fromJson(dynamic json) {
    _fullName = json["full_name"];
    _userName = json["user_name"];
    _userProfile = json["user_profile"];
    _senderUserId = json["sender_user_id"];
    _receivedUserId = json["received_user_id"];
    _itemId = json["item_id"];
    _notificationType = json["notification_type"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["full_name"] = _fullName;
    map["user_name"] = _userName;
    map["user_profile"] = _userProfile;
    map["sender_user_id"] = _senderUserId;
    map["received_user_id"] = _receivedUserId;
    map["item_id"] = _itemId;
    map["notification_type"] = _notificationType;
    map["message"] = _message;
    return map;
  }
}
