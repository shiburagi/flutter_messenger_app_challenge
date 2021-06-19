import 'package:intl/intl.dart';
import 'package:localization/localization.dart';

extension IntFormatterExt on int {
  DateTime toDateTime() => DateTime.fromMillisecondsSinceEpoch(this);

  String get userTimeOrDate => this.toDateTime().userTimeOrDate;
  String get userShortDate => this.toDateTime().userShortDate;
  String get userTime => this.toDateTime().userTime;
}

extension DateTimeFormatterExt on DateTime {
  String get userTimeOrDate {
    final now = DateTime.now();
    if (now.difference(this).inDays < 1) {
      return this.userTime;
    }

    return this.userShortDate;
  }

  String get userShortDate {
    final now = DateTime.now();
    if (now.difference(this).inDays < 1) {
      return S.current.today;
    } else if (now.difference(this).inDays < 2) {
      return S.current.yesterday;
    }

    return this.userDate;
  }

  String get userTime => DateFormat.jm().format(this);
  String get userDate => DateFormat("dd/MM/yyyy").format(this);
}
