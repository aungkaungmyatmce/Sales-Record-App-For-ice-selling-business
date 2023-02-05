import 'package:flutter/material.dart';
import 'colors.dart';

BoxDecoration boxDecorations(
    {double radius = 8,
    Color color = Colors.transparent,
    Color bgColor = Colors.white,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? [BoxShadow(color: sdShadowColor, blurRadius: 10, spreadRadius: 2)]
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

BoxDecoration boxDecoration(
    {double radius = 80.0,
    Color backGroundColor = primaryColor,
    double blurRadius = 8.0,
    double spreadRadius = 8.0,
    Color radiusColor = Colors.black12,
    required Gradient gradient}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: radiusColor,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    ],
    color: backGroundColor,
    gradient: gradient,
  );
}

/// rounded box decoration with shadow
Decoration boxDecorationRoundedWithShadow(
  int radiusAll, {
  Color backgroundColor = Colors.white,
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
  LinearGradient? gradient,
}) {
  return BoxDecoration(
    boxShadow: defaultBoxShadow(
      shadowColor: shadowColor ?? Colors.black12,
      blurRadius: blurRadius ?? 4,
      spreadRadius: spreadRadius ?? 1,
      offset: offset,
    ),
    color: backgroundColor,
    gradient: gradient,
    borderRadius: BorderRadius.circular(8),
  );
}

Decoration boxDecorationWithRoundedCorners({
  Color backgroundColor = Colors.white,
  BorderRadius? borderRadius,
  LinearGradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  DecorationImage? decorationImage,
  BoxShape boxShape = BoxShape.rectangle,
}) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: boxShape == BoxShape.circle
        ? null
        : (borderRadius ?? const BorderRadius.all(Radius.circular(8))),
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    image: decorationImage,
    shape: boxShape,
  );
}

/// default box shadow
List<BoxShadow> defaultBoxShadow({
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
}) {
  return [
    BoxShadow(
      color: shadowColor ?? Colors.grey.withOpacity(0.2),
      blurRadius: blurRadius ?? 4,
      spreadRadius: spreadRadius ?? 1,
      offset: offset,
    )
  ];
}

InputDecoration smallTextInputDecoration() {
  return InputDecoration(
    fillColor: Colors.white70,
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45),
      borderRadius: BorderRadius.circular(3.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black45),
      borderRadius: BorderRadius.circular(3.0),
    ),
  );
}
