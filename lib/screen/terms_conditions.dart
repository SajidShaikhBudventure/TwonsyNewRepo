
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:marketplace/commonview/background.dart';
import 'package:marketplace/helper/constant.dart';
import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/helper/web_api.dart';

class TermsConditions extends StatefulWidget {
  final int type;

  const TermsConditions({Key key, this.type}) : super(key: key);

  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  bool isLoading = false;

  String htmlData = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    termsConditions();
  }

  checkTitleShow() {
    if (widget.type == 1) {
      return StringRes.terms;
    } else if (widget.type == 2) {
      return StringRes.privacy;
    } else if (widget.type == 3) {
      return StringRes.guidelines;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(checkTitleShow()),
      ),
      body: ListView(
        shrinkWrap: false,
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(top: 5, bottom: 20),
              decoration: BoxDecoration(
            color: ColorRes.productBgSubCat,
            border: Border.all(width: 1.0, color: ColorRes.greyText)),
              child: Html(
                data: """ $htmlData  """,
                //Optional parameters:
                padding: EdgeInsets.all(8.0),
                linkStyle: const TextStyle(
                  color: Colors.redAccent,
                  decorationColor: Colors.redAccent,
                  decoration: TextDecoration.underline,
                ),
                onLinkTap: (url) {
                  print("Opening $url...");
                },
                onImageTap: (src) {
                  print(src);
                },
                //Must have useRichText set to false for this to work
                customRender: (node, children) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "custom_tag":
                        return Column(children: children);
                    }
                  }
                  return null;
                },
              ),
            ),
        ],
      ),

    );
  }

  //terams and condition URL: -

  termsConditions() async {
    print("businessUserData function call");
    bool isConnected = await Utils.isInternetConnectedWithAlert();

    if (isConnected) {
      setState(() {
        isLoading = true;
      });

      CommonView.progressDialog(true, context);

      String req;
      if (widget.type == 1) {
        setState(() {
          req = WebApi.terms;
        });
      } else if (widget.type == 2) {
        setState(() {
          req = WebApi.privacy;
        });
      } else if (widget.type == 3) {
        setState(() {
          req = WebApi.guidelines;
        });
      }

      WebApi()
          .callAPI(Const.getReqNotToken, req, null, null)
          .then((baseResponse) async {
        CommonView.progressDialog(false, context);

        if (baseResponse.success) {
          setState(() {
            htmlData = baseResponse.data;
          });
        }
      }).catchError((e) {
        print("login_" + e.toString());
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
