import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkingService {
  final INavigationUtil _navigationUtil;
  Uri? initialUri;
  String? initialLink;
  Uri? currentUri;
  StreamSubscription? sub;

  DeepLinkingService({required INavigationUtil navigationUtil})
      : _navigationUtil = navigationUtil;

  void getInitialLink() async {
    try {
      initialUri = await getInitialUri();
      debugPrint("\n\nititUrI: $initialUri\n\n");
      if (initialUri != null) {
        if (initialUri!.pathSegments.isNotEmpty) {
          debugPrint(
              "\nparsed shit: ${Uri.parse(initialUri.toString()).pathSegments}\n"
              "parsed shit 0: ${Uri.parse(initialUri.toString()).pathSegments[0]}");
          var parsedRoute = Uri.parse(initialUri.toString()).pathSegments[0];
          if (parsedRoute == "plants") {
            _navigationUtil.navigateTo(routePlantsDetails, data: {
              'text': Uri.parse(currentUri.toString()).pathSegments[0]
            });
          } else {
            _navigationUtil.navigateTo(routePlantsHome, data: {
              'text': Uri.parse(currentUri.toString()).pathSegments[0]
            });
          }
        } else {
          debugPrint("uri empty");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getLinkStream() {
    sub = uriLinkStream.listen((Uri? uri) {
      if (uri!.pathSegments.isNotEmpty) {
        currentUri = uri;
        debugPrint(
            "\nparsed shit 0: ${Uri.parse(currentUri.toString()).pathSegments[0]}\n"
            "parsed shit: ${Uri.parse(currentUri.toString()).pathSegments}");
        var parsedRoute = Uri.parse(currentUri.toString()).pathSegments[0];
        if (parsedRoute == "plants") {
          _navigationUtil.navigateTo(routePlantsDetails,
              data: {'text': Uri.parse(currentUri.toString()).pathSegments[0]});
        } else {
          _navigationUtil.navigateTo(routePlantsHome,
              data: {'text': Uri.parse(currentUri.toString()).pathSegments[0]});
        }
      } else {
        debugPrint("uri empty");
      }
    }, onError: (err) {
      debugPrint(err.toString());
    });
  }
}
