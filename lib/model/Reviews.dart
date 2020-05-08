class Reviews {
  int id;
  String author;
  String content;
  int rating;
  String commentedAt;
  List<Replies> replies;
  bool isReplaySheetOpen = false;
  bool isViewRepliesSheetOpen = false;

  Reviews(
      {this.id,
      this.author,
      this.content,
      this.rating,
      this.commentedAt,
      this.replies});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    content = json['content'];
    rating = json['rating'];
    commentedAt = json['commented_at'];
    if (json['replies'] != null) {
      replies = new List<Replies>();
      json['replies'].forEach((v) {
        replies.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author'] = this.author;
    data['content'] = this.content;
    data['rating'] = this.rating;
    data['commented_at'] = this.commentedAt;
    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Replies {
  int id;
  int reviewId;
  String content;
  String commentedAt;

  Replies({this.id, this.reviewId, this.content, this.commentedAt});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviewId = json['review_id'];
    content = json['content'];
    commentedAt = json['commented_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review_id'] = this.reviewId;
    data['content'] = this.content;
    data['commented_at'] = this.commentedAt;
    return data;
  }
}

