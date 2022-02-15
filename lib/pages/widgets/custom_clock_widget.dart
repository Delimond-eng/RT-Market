import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

import '../../index.dart';

class ClockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
      return Text(
        getSystemTime,
        style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w800),
      );
    });
  }

  String get getSystemTime {
    var now = DateTime.now();
    return DateFormat("HH:mm:ss").format(now);
  }
}
