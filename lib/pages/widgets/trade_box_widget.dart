import '../../index.dart';

class TradeBox extends StatelessWidget {
  const TradeBox({Key key, this.color, this.title, this.value})
      : super(key: key);

  final Color color;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 12,
            offset: const Offset(0, 3),
          )
        ],
        color: Colors.grey[100],
        borderRadius: BorderRadius.zero,
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
                color: Colors.grey[200], borderRadius: BorderRadius.zero),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  color: Colors.black87,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  fontSize: 20.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
