class SessionStartEnd {
  String sessionStart;
  String sessionEnd;

  SessionStartEnd({this.sessionStart, this.sessionEnd});

  SessionStartEnd.fromJson(Map<String, dynamic> json) {
    sessionStart = json['session_start'];
    sessionEnd = json['session_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session_start'] = this.sessionStart;
    data['session_end'] = this.sessionEnd;
    return data;
  }
}
