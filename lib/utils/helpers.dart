import "package:flutter/material.dart";
import "package:kioku_navi/widgets/custom_loader.dart";

Future<T> apiCallWithLoader<T>(
    BuildContext context, Future<T> Function() apiCall,
    {String? message}) async {
  try {
    CustomLoader.showLoader(context, message);
    final T result = await apiCall();
    return result;
  } finally {
    CustomLoader.hideLoader();
  }
}