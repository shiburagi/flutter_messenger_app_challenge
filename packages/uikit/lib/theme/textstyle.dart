import 'package:flutter/material.dart';

class AppTextStyle extends TextStyle {
  AppTextStyle.regular() : super(fontWeight: FontWeight.normal);
  AppTextStyle.medium() : super(fontWeight: FontWeight.w500);
  AppTextStyle.semiBold() : super(fontWeight: FontWeight.w600);
  AppTextStyle.bold() : super(fontWeight: FontWeight.bold);
  AppTextStyle.extraBold() : super(fontWeight: FontWeight.w800);

  static TextStyle? bodyText2(BuildContext context) =>
      Theme.of(context).textTheme.bodyText1;
  static TextStyle? caption(BuildContext context) =>
      Theme.of(context).textTheme.caption;
}

extension TextStyleExt on TextStyle {
  TextStyle medium() => this.copyWith(fontWeight: FontWeight.w500);
  TextStyle semiBold() => this.copyWith(fontWeight: FontWeight.w600);
  TextStyle bold() => this.copyWith(fontWeight: FontWeight.bold);
  TextStyle extraBold() => this.copyWith(fontWeight: FontWeight.w800);

  TextStyle colorHint(BuildContext context) =>
      this.copyWith(color: Theme.of(context).hintColor);
  TextStyle colorDisabled(BuildContext context) =>
      this.copyWith(color: Theme.of(context).disabledColor);
}
