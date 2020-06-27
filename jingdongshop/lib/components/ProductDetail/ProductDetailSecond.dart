import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ProductDetailSecond extends StatefulWidget {
  var productDetailData;

  ProductDetailSecond(this.productDetailData);
  @override
  _ProductDetailSecondState createState() => _ProductDetailSecondState();
}

class _ProductDetailSecondState extends State<ProductDetailSecond> with AutomaticKeepAliveClientMixin{
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrl: "http://jd.itying.com/pcontent?id=${widget.productDetailData.sId}",
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )
              ),
              onProgressChanged: (InAppWebViewController controller, int progress) {

              },
            ),
          )
        ],
      ),
    );
  }
}
