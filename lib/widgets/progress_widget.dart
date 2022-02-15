import '../index.dart';

class DProgress extends StatelessWidget {
  final int entryQte;
  final int leaveQte;
  // ignore: use_key_in_widget_constructors
  DProgress({this.entryQte, this.leaveQte});

  @override
  Widget build(BuildContext context) {
    double n = (1 - (leaveQte / entryQte) * 100) * 100;
    return LinearPercentIndicator(
        animation: true,
        lineHeight: 5.0,
        trailing: Text("$n %"),
        animationDuration: 2000,
        backgroundColor: Colors.grey[200],
        percent: 1 - (leaveQte / entryQte) * 100,
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: (n <= 10)
            ? Colors.red[800]
            : (n <= 20)
                ? Colors.red[400]
                : (n <= 40)
                    ? Colors.orange[700]
                    : (n <= 60)
                        ? Colors.lightGreen[600]
                        : (n <= 70)
                            ? Colors.green[400]
                            : (n <= 80)
                                ? Colors.green[600]
                                : Colors.green[800]);
  }
}
