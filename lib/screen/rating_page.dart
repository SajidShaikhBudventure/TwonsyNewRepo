import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:marketplace/commonview/MyBehavior.dart';
import 'package:marketplace/commonview/background.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';
import 'package:marketplace/injection/dependency_injection.dart';
import 'package:marketplace/model/Reviews.dart';
import 'package:marketplace/model/rating.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  bool isLoading = true;
  int page = 1;

  bool hasMorePages = true;

  List<RatingData> ratingList = List();
  List<Reviews> reviewList = new List<Reviews>();
  TextEditingController reviewText = TextEditingController();
  int totalRating;
  double avrageRating = 0;

  final _formKey = GlobalKey<FormState>();

  List<int> totalPerson = List();
  List<int> totalRatings = List();

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading != null && isLoading) {
//      callApi();
      return Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitThreeBounce(
            color: ColorRes.black,
            size: Utils.getDeviceWidth(context) / 20,
          )
        ],
      ));
    }
    return widgetsLayout();
  }

  Widget widgetsLayout() {
    return InkResponse(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(Utils.getDeviceWidth(context) / 28),
        children: <Widget>[
          ratingShowFirst(),
          ratingShowAllLine(),
          ratingCount(),
          rateUserDescription(),
        ],
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Future callApi() async {
    await ratingCountsApi();
    await reviewsApi(false);
  }

  ratingShowFirst() {
    return Container(
      margin: EdgeInsets.only(
          top: Utils.getDeviceHeight(context) / 80, left: 3, right: 2),
      alignment: Alignment(0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Utils.getDeviceWidth(context) / 2.55,
            child: Container(
              margin: EdgeInsets.only(right: 5),
              child: Text(
                StringRes.yourRating,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: Utils.getDeviceWidth(context) / 30,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          Container(
            width: Utils.getDeviceWidth(context) / 3,
            child: Align(
              //alignment: Alignment.center,
              child: RatingBarIndicator(
                rating: avrageRating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: ColorRes.ratingLine,
                ),
                itemCount: 5,
                itemSize: Utils.getDeviceWidth(context) / 16,
                direction: Axis.horizontal,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                "$avrageRating ($totalRating)",
                style: TextStyle(
                    fontSize: Utils.getDeviceWidth(context) / 30,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<int> ratingCount1 = [1, 1, 100, 1000, 1000];

  ratingShowAllLine() {
    return Container(
        height: Utils.getDeviceHeight(context) / 2.75,
        padding: EdgeInsets.only(
            top: Utils.getDeviceWidth(context) / 22,
            bottom: Utils.getDeviceWidth(context) / 20,
            right: 0),
        child: ListView.builder(
            itemCount: ratingList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              int ratNumber = ratingList[index].rating != null
                  ? ratingList[index].rating
                  : 0;
              double ratPer = ratingList[index].totalRatings != null
                  ? ratingList[index].totalRatings /
                      (totalRating != 0 ? totalRating : 1)
                  : 0;
              int ratePerson = ratingList[index].totalRatings != null
                  ? ratingList[index].totalRatings
                  : 0;
              return ratingShow(ratNumber, ratPer, ratePerson);
            }));
  }

  ratingShow(int ratNumber, double ratPer, int ratePerson) {
    double countRating = ratePerson / 1000;
    print("your-persontange" + ratPer.toString());

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("$ratNumber",
                  style:
                      TextStyle(fontSize: Utils.getDeviceWidth(context) / 22)),
              SizedBox(width: 4.0),
              Image(
                  height: Utils.getDeviceHeight(context) / 22,
                  width: Utils.getDeviceWidth(context) / 22,
                  image: AssetImage(Utils.getAssetsImg("onestar"))),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: StepProgressIndicator(
                totalSteps: 1,
                currentStep: ratPer.round(),
                size: Utils.getDeviceHeight(context) / 22,
                padding: 0,
                selectedColor: ColorRes.ratingLine,
                roundedEdges: Radius.circular(0),
              ),
            ),
          ),
          Container(
            width: Utils.getDeviceWidth(context) / 9,
            child: Text(
                ratePerson <= 999 ? "$ratePerson" : "$countRating" + "k",
                // "$ratePerson",
                style: TextStyle(fontSize: Utils.getDeviceWidth(context) / 22)),
          )
        ],
      ),
    );
  }

  ratingCount() {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(reviewList.length.toString(),
                style: TextStyle(
                    fontSize: Utils.getDeviceWidth(context) / 20,
                    fontWeight: FontWeight.w500)),
          ),
          Container(
            child: Text(
              StringRes.reviews,
              style: TextStyle(
                  fontSize: Utils.getDeviceWidth(context) / 20,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  rateUserDescription() {
    return Container(
        child: ListView.builder(
            itemCount: reviewList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return reviewListData(reviewList[index], index);
            }));
  }

  Widget reviewListData(Reviews reviewListModel, int index) {
    return Container(
      padding: EdgeInsets.only(left: 5, top: 10, right: 5, bottom: 5),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 5),
              Expanded(
                //width: Utils.getDeviceWidth(context) / 3.5,
                child: Text(
                  reviewListModel.author,
                  style: TextStyle(
                      fontSize: Utils.getDeviceWidth(context) / 25,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 5),
              Container(
                //flex: 6,
                width: Utils.getDeviceWidth(context) / 2.75,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RatingBarIndicator(
                    rating: double.parse(reviewListModel.rating.toString()),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: ColorRes.ratingLine,
                    ),
                    itemCount: 5,
                    itemSize: Utils.getDeviceWidth(context) / 20,
                    direction: Axis.horizontal,
                  ),
                ),
              ),
              Container(
                  child: Text(
                reviewListModel.commentedAt,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: ColorRes.cancelGreyText,
                    fontSize: Utils.getDeviceWidth(context) / 33,
                    fontWeight: FontWeight.w500),
              ))
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            //height: 60,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: Utils.getDeviceWidth(context),
            decoration: BoxDecoration(
              border: Border.all(color: ColorRes.rateBoxBorder, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Text(
              reviewListModel.content,
              //overflow: TextOverflow.ellipsis,
              //maxLines: 2,
              style: TextStyle(
                  color: ColorRes.cancelGreyText,
                  fontSize: Utils.getDeviceWidth(context) / 27,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          Container(
            //height: 20,
            width: Utils.getDeviceWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                reviewListModel.replies != null &&
                        reviewListModel.replies.length > 0
                    ? InkResponse(
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          //height: 20,
                          child: Text(
                            reviewListModel.isViewRepliesSheetOpen
                                ? StringRes.hideReplies
                                : StringRes.viewReplies,
                            style: Theme.of(context).textTheme.body2.copyWith(
                                color: ColorRes.rateReplay,
                                fontSize: Utils.getDeviceWidth(context) / 28),
                          ),
                        ),
                        onTap: () {
                          if (reviewListModel.isViewRepliesSheetOpen) {
                            reviewListModel.isViewRepliesSheetOpen =
                                !reviewListModel.isViewRepliesSheetOpen;
                          } else {
                            for (int i = 0; i < reviewList.length; i++) {
                              reviewList[i].isViewRepliesSheetOpen = false;
                            }
                            reviewListModel.isViewRepliesSheetOpen =
                                !reviewListModel.isViewRepliesSheetOpen;
                          }
                          setState(() {});
                        },
                      )
                    : Container(),
                InkResponse(
                  child: Container(
                    //height: 20,
                    padding: EdgeInsets.only(right: 5),
                    child: Text(StringRes.reply,
                        style: Theme.of(context).textTheme.body2.copyWith(
                            color: ColorRes.rateReplay,
                            fontSize: Utils.getDeviceWidth(context) / 28)),
                  ),
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < reviewList.length; i++) {
                        reviewList[i].isReplaySheetOpen = false;
                      }
                      reviewListModel.isReplaySheetOpen =
                          !reviewListModel.isReplaySheetOpen;
                    });
                  },
                )
              ],
            ),
          ),
          reviewListModel.isViewRepliesSheetOpen != null &&
                  reviewListModel.isViewRepliesSheetOpen
              ? viewRepliesList(reviewListModel, index)
              : Container(),
          reviewListModel.isReplaySheetOpen != null &&
                  reviewListModel.isReplaySheetOpen
              ? bottomViewShow(reviewListModel, index)
              : Container(),
        ],
      ),
    );
  }

  Widget viewRepliesList(Reviews reviewListModel, int index) {
    if (reviewListModel.replies != null && reviewListModel.replies.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: reviewListModel.replies.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(reviewListModel.replies[index].content),
                  trailing: Text(
                    reviewListModel.replies[index].commentedAt,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: ColorRes.lightGrey,
                  margin: EdgeInsets.all(8.0),
                )
              ],
            );
          });
    } else {
      return Container();
    }
  }

  bottomViewShow(Reviews reviewListModel, int index) {
    return Column(
      children: <Widget>[
        new SizedBox(height: 8),
        Form(
          key: _formKey,
          child: new Theme(
            data: ThemeData(primaryColor: ColorRes.black),
            child: TextFormField(
              controller: reviewText,
              maxLines: 4,
              style: TextStyle(height: 1.0),
              cursorColor: ColorRes.black,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                  hintText: StringRes.writeHint),
              validator: (value) {
                if (value.isEmpty) {
                  return StringRes.requiredFiled;
                }
                return null;
              },
            ),
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: MaterialButton(
                onPressed: () {
                  reviewListModel.isReplaySheetOpen =
                      !reviewListModel.isReplaySheetOpen;
                  setState(() {});
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: ColorRes.productBgSubCat)),
                child: Text(
                  StringRes.cancel,
                  style: TextStyle(color: ColorRes.cancelGreyText),
                ),
              ),
            ),
            Container(
              child: MaterialButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    callApiForPostReview(
                        reviewListModel.id, reviewText.text.toString(), index);
                  }
                },
                color: ColorRes.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  StringRes.done,
                  style: TextStyle(color: ColorRes.white),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  ratingCountsApi() async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      WebApi()
          .callAPI(Const.get, WebApi.rating, null, Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          baseResponse.data.forEach((v) {
            ratingList.add(RatingData.fromJson(v));
          });
          print(ratingList.toString());

          ratingList.sort((a, b) {
            return a.rating.compareTo(b.rating);
          });

          print(ratingList);
          totalRating = ratingList[0].totalRatings +
              ratingList[1].totalRatings +
              ratingList[2].totalRatings +
              ratingList[3].totalRatings +
              ratingList[4].totalRatings;

          for (int i = 0; i < ratingList.length; i++) {
            totalRatings.add(ratingList[i].rating * ratingList[i].totalRatings);
            totalPerson.add(ratingList[i].totalRatings);
          }

          int totalRatingsSum = 0;
          int totalPersonSum = 0;
          totalRatings.forEach((Iterable) {
            totalRatingsSum += Iterable;
          });
          totalPerson.forEach((Iterable) {
            totalPersonSum += Iterable;
          });

          if (totalPersonSum != 0) {
            double totalAvgRating =
                (totalRatingsSum / totalPersonSum).toDouble();
            avrageRating = double.parse(totalAvgRating.toStringAsFixed(1));
          } else {
            avrageRating = (totalRatingsSum / 1).toDouble();
          }

          setState(() {});
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
      });
    }
  }

  reviewsApi(bool param0) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      if (hasMorePages) {
        WebApi()
            .callAPI(Const.get, WebApi.reviews + page.toString(), null,
                Injector.accessToken)
            .then((baseResponse) async {
          if (baseResponse.success) {
            hasMorePages = baseResponse.meta.hasMorePages;

            baseResponse.data.forEach((v) {
              reviewList.add(Reviews.fromJson(v));
            });

            if (baseResponse.data != null) {
              setState(() {
                isLoading = false;
              });
            }
          }
        }).catchError((e) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  callApiForPostReview(int id, String string, int index) async {
    bool isConnected = await Utils.isInternetConnectedWithAlert();
    if (isConnected) {
      CommonView.progressDialog(true, context);

      Map<String, dynamic> map = {'content': string.toString()};

      WebApi()
          .callAPI(Const.postWithAccess, WebApi.reviewReplay + id.toString(),
              map, Injector.accessToken)
          .then((baseResponse) async {
        if (baseResponse.success) {
          for (int i = 0; i < reviewList.length; i++) {
            reviewList[i].isReplaySheetOpen = false;
          }
          CommonView.progressDialog(false, context);
          Utils.showToast(baseResponse.message);

          Replies reviews = new Replies();
          reviews.content = string;
          reviews.commentedAt = DateTime.now().day.toString() +
              "/" +
              DateTime.now().month.toString() +
              "/" +
              DateTime.now().year.toString();
          reviewList[index].replies.add(reviews);
          setState(() {});
        }
      }).catchError((e) {
        CommonView.progressDialog(false, context);
      });
    }
  }
}
