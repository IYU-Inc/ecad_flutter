import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ecadは広告販売プラットフォーム『EC-AD』の広告配信と販売促進を行うためのWidgetです。
/// このWidgetを使う前に、『EC-AD』に登録して広告枠を作成しておく必要があります。
/// idは必須パラメータです。
class Ecad extends StatefulWidget {
  /// 広告枠IDを設定してください。
  final String id;

  /// 広告サイズの横幅を設定することができます。
  /// デフォルト値は広告の最大サイズです。
  /// square = 150px, landscape_6_1 = 300px
  /// 高さは横幅によって自動で設定されます。
  final double? width;

  /// 広告枠の販売を募集する画像を表示するかどうか設定することができます。
  /// デフォルト値（false）の場合、まだ購入されていない広告枠なら購入募集の広告が表示され、すでに購入されている広告なら、他の広告と同じ確率で購入募集の広告が表示されます。
  /// trueの場合、まだ購入されていない広告枠ならWidget自体が非表示となり、すでに購入されている広告なら、購入された広告のみ表示されます。
  /// デフォルトの設定値は、falseです。
  final bool hiddenSaleImage;

  const Ecad({super.key, required this.id, this.width, this.hiddenSaleImage = false});

  @override
  State<Ecad> createState() => _EcadState();
}

class _EcadState extends State<Ecad> {

  bool visible = true;

  /// URLの前半部分
  final prefix = 'https://access.ec-ad.tech/api/v1/request/';

  /// 広告データをHTTPリクエストで取得
  Future<Map<String, dynamic>?> fetchData() async {
    var httpClient = HttpClient();
    var uri = Uri.parse('$prefix?type=fromVue&id=${widget.id}&visibleSaleImage=${widget.hiddenSaleImage ? '0' : '1'}');

    try {
      var request = await httpClient.getUrl(uri);
      var response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        var responseBody = await response.transform(utf8.decoder).join();
        return json.decode(responseBody);

      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (exception) {
      if (kDebugMode) {
        print('Failed to fetch data: $exception');
      }
    } finally {
      httpClient.close();
    }
    return null;
  }

  /// widthが設定されていない場合は、typeによってサイズを決定
  double setWidth(String type) {
    switch(type) {
      case 'square': {
        const double defaultSize = 150;
        if(widget.width != null) {
          if(widget.width! > defaultSize / 2) {
            return widget.width!;
          } else {
            return defaultSize / 2;
          }
        } else {
          return defaultSize;
        }
      }
      case 'landscape_6_1': {
        const double defaultSize = 300;
        if(widget.width != null) {
          if(widget.width! > defaultSize / 2) {
            return widget.width!;
          } else {
            return defaultSize / 2;
          }
        } else {
          return defaultSize;
        }
      }
      default: {
        return 150;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState != ConnectionState.done) return const SizedBox();

          if(visible) {
            return Container(
              color: Colors.white,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(snapshot.data['url']));
                    },
                    child: Container(
                        width: setWidth(snapshot.data['type']),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5)
                        ),
                        child: Image.network(
                          snapshot.data['image'],
                          color: visible ? null : Colors.transparent,
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        visible = false;
                      });
                    },
                    child: Container(
                        margin: const EdgeInsets.all(1),
                        padding: const EdgeInsets.all(3),
                        color: Colors.white,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('広告', style: TextStyle(fontSize: 10),),
                            Icon(Icons.cancel_outlined, size: 15,)
                          ],
                        )
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              width: setWidth(snapshot.data['type']),
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('広告を非表示にしました', style: TextStyle(fontSize: 10),),
              )
            );
          }
        }
    );
  }
}
