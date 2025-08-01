/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app-icon.png
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app-icon.png');

  /// File path: assets/images/comprehensive.png
  AssetGenImage get comprehensive =>
      const AssetGenImage('assets/images/comprehensive.png');

  /// File path: assets/images/fire_icon.png
  AssetGenImage get fireIcon =>
      const AssetGenImage('assets/images/fire_icon.png');

  /// File path: assets/images/gem_icon.png
  AssetGenImage get gemIcon =>
      const AssetGenImage('assets/images/gem_icon.png');

  /// File path: assets/images/japan_icon.png
  AssetGenImage get japanIcon =>
      const AssetGenImage('assets/images/japan_icon.png');

  /// File path: assets/images/language_icon.png
  AssetGenImage get languageIcon =>
      const AssetGenImage('assets/images/language_icon.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/question_answer_placeholder.webp
  AssetGenImage get questionAnswerPlaceholder =>
      const AssetGenImage('assets/images/question_answer_placeholder.webp');

  /// File path: assets/images/science_icon.png
  AssetGenImage get scienceIcon =>
      const AssetGenImage('assets/images/science_icon.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    appIcon,
    comprehensive,
    fireIcon,
    gemIcon,
    japanIcon,
    languageIcon,
    logo,
    questionAnswerPlaceholder,
    scienceIcon,
  ];
}

class $AssetsLocalesGen {
  const $AssetsLocalesGen();

  /// File path: assets/locales/en_US.json
  String get enUS => 'assets/locales/en_US.json';

  /// File path: assets/locales/ja_JP.json
  String get jaJP => 'assets/locales/ja_JP.json';

  /// List of all assets
  List<String> get values => [enUS, jaJP];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/learning.json
  String get learning => 'assets/lottie/learning.json';

  /// List of all assets
  List<String> get values => [learning];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLocalesGen locales = $AssetsLocalesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
