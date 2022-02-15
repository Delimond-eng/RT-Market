import '../../index.dart';

class BigBtn extends StatelessWidget {
  final Function onPressed;
  final String title;
  final IconData icon;
  final Color color;
  final double height;
  final double radius;
  final double iconSize;
  final double fontSize;
  const BigBtn({
    this.onPressed,
    this.title,
    this.icon,
    this.color,
    this.height,
    this.radius,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (height == null) ? 70.0 : height,
      width: MediaQuery.of(context).size.width,
      // ignore: deprecated_member_use
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
            borderRadius: (radius == null)
                ? BorderRadius.zero
                : BorderRadius.circular(radius)),
        elevation: 15.0,
        color: color,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: iconSize ?? 15,
        ),
        label: Text(
          title,
          style: GoogleFonts.lato(
            color: Colors.white,
            letterSpacing: 1.0,
            fontSize: fontSize ?? 14.0,
          ),
        ),
      ),
    );
  }
}
