class Autogenerated {
  String? label;
  double? score;

  Autogenerated({this.label, this.score});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['score'] = this.score;
    return data;
  }
}