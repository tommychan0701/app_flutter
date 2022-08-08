class RewardingActions {
  int _status;
  String _message;
  List<RewardingActionData> _data;

  int get status => _status;

  String get message => _message;

  List<RewardingActionData> get data => _data;

  RewardingActions(
      {int status, String message, List<RewardingActionData> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  RewardingActions.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(RewardingActionData.fromJson(v));
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

class RewardingActionData {
  int _rewardingActionId;
  String _actionName;
  int _coin;
  String _createdAt;
  dynamic _updatedAt;

  int get rewardingActionId => _rewardingActionId;

  String get actionName => _actionName;

  int get coin => _coin;

  String get createdAt => _createdAt;

  dynamic get updatedAt => _updatedAt;

  RewardingActionData(
      {int rewardingActionId,
      String actionName,
      int coin,
      String createdAt,
      dynamic updatedAt}) {
    _rewardingActionId = rewardingActionId;
    _actionName = actionName;
    _coin = coin;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  RewardingActionData.fromJson(dynamic json) {
    _rewardingActionId = json["rewarding_action_id"];
    _actionName = json["action_name"];
    _coin = json["coin"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["rewarding_action_id"] = _rewardingActionId;
    map["action_name"] = _actionName;
    map["coin"] = _coin;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
