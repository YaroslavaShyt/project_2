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
          List<String> parsedRoute =
              Uri.parse(initialUri.toString()).pathSegments;
          if (parsedRoute.length == 2) {
            if (parsedRoute[0] == uriPlantsDetailsCategory) {
              _navigationUtil.navigateTo(routePlantsDetails,
                  data: parsedRoute[1]);
            } else {
              _navigationUtil.navigateTo(routePlantsHome);
            }
          } else {
            _navigationUtil.navigateTo(routePlantsHome);
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

        List<String> parsedRoute =
            Uri.parse(currentUri.toString()).pathSegments;

        if (parsedRoute.length == 2) {
          if (parsedRoute[0] == uriPlantsDetailsCategory) {
            _navigationUtil.navigateTo(routePlantsDetails,
                data: parsedRoute[1]);
          } else {
            _navigationUtil.navigateTo(routePlantsHome);
          }
        } else {
          _navigationUtil.navigateTo(routePlantsHome);
        }
      } else {
        debugPrint("uri empty");
      }
    }, onError: (err) {
      debugPrint(err.toString());
    });
  }
}
