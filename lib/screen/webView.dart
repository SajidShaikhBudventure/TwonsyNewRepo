import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:marketplace/helper/res.dart';
//import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String webUrl;

  const WebViewPage({Key key, this.webUrl}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.webUrl,
      appBar: AppBar(
        title: Text(StringRes.viewOnTownsy),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
    );

  }
}
