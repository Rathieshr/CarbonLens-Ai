import 'package:intl/intl.dart';

extension NumberFormatting on num {
  String get withCommas {
    final format = NumberFormat("#,##0", "en_US");
    return format.format(this);
  }
}
