import 'package:flutter/material.dart';
import 'customer_dialog.dart';
import 'dart:ui' as ui;
import 'dart:math';

class BottomBarCustom extends StatelessWidget {
  final constraints;
  final Function onPaymentPressed;

  const BottomBarCustom({Key key, this.constraints, this.onPaymentPressed})
      : super(key: key);

  _changeCustomer(context) {
    void onTap() {
      Navigator.of(context).pop(false);
      //   final snackBar = SnackBar(content: Text("Change Customer 2"));
      //   Scaffold.of(context).showSnackBar(snackBar);
    }

    return showDialog(
          context: context,
          builder: (context) {
            return CustomerDialog(onTap: onTap);
            // return AlertDialog(
            //   title: Text('Are you sure?'),
            //   content: Text('Unsaved data will be lost.'),
            //   actions: <Widget>[
            //     FlatButton(
            //       onPressed: () => Navigator.of(context).pop(false),
            //       child: Text('No'),
            //     ),
            //     FlatButton(
            //       onPressed: () =>
            //           Navigator.of(context).popUntil(ModalRoute.withName('/')),
            //       child: Text('Yes'),
            //     ),
            //   ],
            // );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final double bottomBarHeight = 80.0;
    final double radiusInner = 40.0;
    final double buttonConfirmHeight =
        50.0; //harus lebih kecil dari buttomBarHeight

    final double margin = 8.0;
    final double offsetX = -15.0;
    //harus lebih besar dari 0, atau gak ke potong diatas
    final double offsetY = 12.0;

    final double buttonConfirmOffsetY = bottomBarHeight - buttonConfirmHeight;

    final double circleX = offsetX + radiusInner;
    final double circleY = offsetY + radiusInner - buttonConfirmOffsetY;
    final double circleTopY = circleY - (radiusInner + margin);
    final double circleBottomY = circleY + radiusInner + margin;

    final double buttonConfirmWidth =
        MediaQuery.of(context).size.width - circleX;

    BoxDecoration _buildBox([int color]) {
      return BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.0, color: Color(0x00FFDFDFDF)),
          left: BorderSide(width: 0.0, color: Color(0x00FFDFDFDF)),
          right: BorderSide(width: 0.0, color: Color(0x00FFDFDFDF)),
          bottom: BorderSide(width: 0.0, color: Color(0x00FFDFDFDF)),
        ),
        // color: Color(0xFF8fe0fe), // !GANTI
        // color: Color(0xFF85eeb1), // !GANTI
        color: Color(0xff9197ff), // !GANTI
        // color: Color(0xdd5F90FE), // !GANTI
        // color: Color(0xff739efd), // !GANTI
        // shape: BoxShape.circle,Color(0xFFffa749)
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: bottomBarHeight,
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          Positioned(
            top: offsetY,
            left: offsetX,
            child: GestureDetector(
              onTap: () {
                _changeCustomer(context);
              },
              child: SizedBox(
                  width: radiusInner * 2.0,
                  child: ClipOval(
                    child: Image.asset('assets/images/employee.png'),
                  )),
            ),
          ),
          Positioned(
            top: buttonConfirmOffsetY,
            right: 0.0,
            child: GestureDetector(
              onTap: onPaymentPressed,
              child: SizedBox(
                  height: buttonConfirmHeight,
                  width: buttonConfirmWidth,
                  child: ClipPath(
                    child: Container(
                        decoration: _buildBox(),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 40.0, top: 5.0, bottom: 5.0),
                          child: Icon(
                            Icons.shopping_cart,
                            // color: Color(0xff9197ff), // !GANTI
                            color: Color(0xFF85eeb1), // !GANTI
                            // color: Colors.white, // !GANTI
                          ),
                        )),
                    clipper: ButtonConfirmClip(circleTopY, circleBottomY),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonConfirmClip extends CustomClipper<Path> {
  final double circleTopY;
  final double circleBottomY;
  ButtonConfirmClip(
    this.circleTopY,
    this.circleBottomY,
  );
  @override
  getClip(Size size) {
    var buttonRectangle = Path();
    buttonRectangle.moveTo(0.0, 0.0);
    buttonRectangle.lineTo(0.0, size.height);
    buttonRectangle.lineTo(size.width, size.height);
    buttonRectangle.lineTo(size.width, 0.0);
    buttonRectangle.close();

    var outerCircle = Path();
    var circleX = 0.0; //selalu 0, karena dipojok dari container button
    outerCircle.moveTo(circleX, circleTopY);
    outerCircle.arcToPoint(Offset(circleX, circleBottomY),
        radius: Radius.circular(1.0));
    outerCircle.arcToPoint(Offset(circleX, circleTopY),
        radius: Radius.circular(1.0));

    var pathCombine =
        Path.combine(ui.PathOperation.difference, buttonRectangle, outerCircle);

    return pathCombine;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class ButtonKeranjang extends CustomPainter {
  final double _width;
  final double buttonKeranjangX;
  final double buttonKeranjangY;

  final double circleX;
  final double circleY;

  final double circleTopY;
  final double circleBottomY;
  ButtonKeranjang(
    this.buttonKeranjangX,
    this.buttonKeranjangY,
    this.circleX,
    this.circleY,
    this.circleTopY,
    this.circleBottomY,
    this._width,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintPurple = Paint()..color = Color(0x00ffffff);

    var outerCircle = Path();
    outerCircle.moveTo(circleX, circleTopY);
    outerCircle.arcToPoint(Offset(circleX, circleBottomY),
        radius: Radius.circular(1.0));
    outerCircle.arcToPoint(Offset(circleX, circleTopY),
        radius: Radius.circular(1.0));

    var cartButton = Path();
    cartButton.moveTo(buttonKeranjangX, 0.0);
    cartButton.lineTo(buttonKeranjangX, -buttonKeranjangY);
    cartButton.lineTo(_width, -buttonKeranjangY);
    cartButton.lineTo(_width, 0.0);
    cartButton.close();

    canvas.drawPath(
        Path.combine(ui.PathOperation.difference, cartButton, outerCircle),
        paintPurple);
  }

  @override
  bool shouldRepaint(ButtonKeranjang oldDelegate) {
    return false;
  }
}

class ButtonCustomer extends CustomPainter {
  final double circleX;
  final double circleY;

  final double circleTopY;
  final double circleBottomY;
  ButtonCustomer(
    this.circleX,
    this.circleY,
    this.circleTopY,
    this.circleBottomY,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintBlue = Paint()..color = Colors.blue[200];
    var innerCircle = Path();
    innerCircle.moveTo(circleX, circleTopY);
    innerCircle.arcToPoint(Offset(circleX, circleBottomY),
        radius: Radius.circular(1.0));
    innerCircle.arcToPoint(Offset(circleX, circleTopY),
        radius: Radius.circular(1.0));

    canvas.drawPath(innerCircle, paintBlue);

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Paint line = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;

    canvas.drawCircle(center, radius, line);

    // double arcAngle = 2 * pi * (40 / 100);

    // canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
    //     arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(ButtonCustomer oldDelegate) {
    return false;
  }
}
