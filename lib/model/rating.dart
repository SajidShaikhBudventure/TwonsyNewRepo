class RatingResponse {
  List<RatingData> ratingData;

  RatingResponse({this.ratingData});

  RatingResponse.fromJson(Map<String, dynamic> json) {
    if (json['ratingData'] != null) {
      ratingData = new List<RatingData>();
      json['ratingData'].forEach((v) {
        ratingData.add(new RatingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ratingData != null) {
      data['ratingData'] = this.ratingData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingData {
  int rating;
  int totalRatings;

  RatingData({this.rating, this.totalRatings});

  RatingData.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    totalRatings = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['total_ratings'] = this.totalRatings;
    return data;
  }

  compareTo(RatingData b) {

  }
}
