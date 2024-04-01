import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkHandler {
  Uri? initialUri;
  Uri? currentUri;
  StreamSubscription? sub;
  final INavigationUtil _navigationUtil;

  DeepLinkHandler({required INavigationUtil navigationUtil})
      : _navigationUtil = navigationUtil;

  void getInitialLink() async {
    try {
      initialUri = await getInitialUri();
      debugPrint("\n\n ititUrI: $initialUri \n\n");
      if (initialUri != null) {
        if (initialUri!.pathSegments.isNotEmpty) {
          Map<String, String> data = parseLink(initialUri.toString());
          _navigationUtil.navigateTo(data["route"]!, data: data["data"]);
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
        Map<String, String> data = parseLink(currentUri.toString());
        _navigationUtil.navigateTo(data["route"]!, data: data["data"]);
      } else {
        debugPrint("uri empty");
      }
    }, onError: (err) {
      debugPrint(err.toString());
    });
  }

  Map<String, String> parseLink(String uri) {
    List<String> parsedRoute = Uri.parse(uri).pathSegments;
    if (parsedRoute.length == 2) {
      if (parsedRoute[0] == uriPlantsDetailsCategory) {
        return {"route": routePlantsDetails, "data": parsedRoute[1]};
      } else {
        return {"route": routeHome, "data": ""};
      }
    } else {
      return {"route": routeHome, "data": ""};
    }
  }
}
