
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawrapet/utils/constants.dart';

class XHeartWithImageButton extends StatefulWidget {
  ImageProvider? iconL, iconR;
  double height;
  double? gap;
  VoidCallback onTap;
  XHeartWithImageButton({Key? key, this.iconL, this.iconR, required this.height, this.gap , required this.onTap}) : super(key: key);
  @override
  State<XHeartWithImageButton> createState() => _XHeartWithImageButtonState();
}

class _XHeartWithImageButtonState extends State<XHeartWithImageButton> with TickerProviderStateMixin{
  late AnimationController _pulseAnimationController, _lottieAnimationController;
  @override
  void initState() {
    // lottie animation in bg
    _lottieAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000), lowerBound: 0.5, upperBound: 1);
    // setting up animation controller to create a pulse effect
    _pulseAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // Reverse the animation when it's completed
    _pulseAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseAnimationController.animateBack(0, duration: Duration(milliseconds: 100));
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    _pulseAnimationController.dispose();
    _lottieAnimationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -widget.height,
            left: -widget.height,
            child: SizedBox(
                height: widget.height*3,
                child: Lottie.asset("assets/lotties/exploding_heart.json", controller: _lottieAnimationController, repeat: false)),
          ),
          SizedBox(
            height: widget.height,
            child: GestureDetector(
              onTap: (){
                _pulseAnimationController.forward();
                if(widget.iconL==null&&widget.iconR!=null)_lottieAnimationController.forward();
                widget.onTap();
              },
              child: AnimatedBuilder(
                animation: _pulseAnimationController,
                  builder: (context,child){
                  return XHeartWithImage(height: widget.height+widget.height/7*(_pulseAnimationController.value), gap: widget.gap, iconL: widget.iconL, iconR: widget.iconR,);
                  }),
            )
          ),
        ],
      ),
    );
  }
}

class XHeartWithImage extends StatefulWidget {
  ImageProvider? iconL, iconR;
  double height;
  double? gap;
  XHeartWithImage({Key? key, this.iconL, this.iconR, required this.height, this.gap }) : super(key: key);

  @override
  State<XHeartWithImage> createState() => _XHeartWithImageState();
}

class _XHeartWithImageState extends State<XHeartWithImage> {
  double ratioWh = 34.61/60;
  late double gap;
  @override
  void initState() {
    gap = widget.gap??xSize1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: ratioWh*widget.height*1.77,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            child: SizedBox(
              height: widget.height,
              width: ratioWh*widget.height,
              child: CustomPaint(
                painter: _RightClipperPainter(),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              height: widget.height-gap,
              width: ratioWh*(widget.height-gap),
              margin: EdgeInsets.symmetric(vertical: gap*0.4, horizontal: gap*0.3),
              child: ClipPath(
                clipper: _RightCustomClipper(),
                child: (widget.iconR==null)?null:Image(image: widget.iconR!, fit: BoxFit.cover,),
              ),
            ),
          ),

          Positioned(
            left: 0,
            child: SizedBox(
              height: widget.height,
              width: ratioWh*widget.height,
              child: CustomPaint(
                painter: _LeftClipperPainter(),
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Container(
              height: widget.height-gap,
              width: ratioWh*(widget.height-gap),
              margin: EdgeInsets.symmetric(vertical: gap*0.4, horizontal: gap*0.3),
              child: ClipPath(
                clipper: _LeftCustomClipper(),
                child: (widget.iconL==null)?null:Image(image: widget.iconL!, fit: BoxFit.cover,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _LeftClipperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double x = size.height;
    double y = size.width;
    Path path_0 = Path();
    path_0.moveTo(33.6129/60*x,29.3809/34.61*y);
    path_0.cubicTo(33.6129/60*x,38.7052/34.61*y,32.6292/60*x,49.1913/34.61*y,31.2715/60*x,57.9254/34.61*y);
    path_0.cubicTo(29.6483/60*x,56.3429/34.61*y,27.9081/60*x,54.7047/34.61*y,26.1106/60*x,53.0126/34.61*y);
    path_0.cubicTo(21.5686/60*x,48.7369/34.61*y,16.6612/60*x,44.1173/34.61*y,12.3544/60*x,39.1832/34.61*y);
    path_0.cubicTo(5.85317/60*x,31.7352/34.61*y,1/60*x,23.8605/34.61*y,1/60*x,15.8781/34.61*y);
    path_0.cubicTo(1/60*x,8.01476/34.61*y,5.87407/60*x,3.12358/34.61*y,11.9028/60*x,1.55023/34.61*y);
    path_0.cubicTo(17.977/60*x,-0.0349943/34.61*y,25.1654/60*x,1.7709/34.61*y,29.648/60*x,7.37413/34.61*y);
    path_0.cubicTo(31.0044/60*x,9.06957/34.61*y,32.0171/60*x,11.9959/34.61*y,32.676/60*x,15.879/34.61*y);
    path_0.cubicTo(33.3289/60*x,19.7262/34.61*y,33.6129/60*x,24.3724/34.61*y,33.6129/60*x,29.3809/34.61*y);
    path_0.close();

    // Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=xSize1/2;
    // paint_0_stroke.color=const Color(0xffE4E9DD).withOpacity(1.0);
    // paint_0_stroke.strokeCap = StrokeCap.round;
    // canvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = xOnPrimary.withOpacity(1);
    canvas.drawPath(path_0,paint_0_fill);

    // return canvas;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
class _LeftCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double x = size.height;
    double y = size.width;
    Path path_0 = Path();
    path_0.moveTo(33.6129/60*x,29.3809/34.61*y);
    path_0.cubicTo(33.6129/60*x,38.7052/34.61*y,32.6292/60*x,49.1913/34.61*y,31.2715/60*x,57.9254/34.61*y);
    path_0.cubicTo(29.6483/60*x,56.3429/34.61*y,27.9081/60*x,54.7047/34.61*y,26.1106/60*x,53.0126/34.61*y);
    path_0.cubicTo(21.5686/60*x,48.7369/34.61*y,16.6612/60*x,44.1173/34.61*y,12.3544/60*x,39.1832/34.61*y);
    path_0.cubicTo(5.85317/60*x,31.7352/34.61*y,1/60*x,23.8605/34.61*y,1/60*x,15.8781/34.61*y);
    path_0.cubicTo(1/60*x,8.01476/34.61*y,5.87407/60*x,3.12358/34.61*y,11.9028/60*x,1.55023/34.61*y);
    path_0.cubicTo(17.977/60*x,-0.0349943/34.61*y,25.1654/60*x,1.7709/34.61*y,29.648/60*x,7.37413/34.61*y);
    path_0.cubicTo(31.0044/60*x,9.06957/34.61*y,32.0171/60*x,11.9959/34.61*y,32.676/60*x,15.879/34.61*y);
    path_0.cubicTo(33.3289/60*x,19.7262/34.61*y,33.6129/60*x,24.3724/34.61*y,33.6129/60*x,29.3809/34.61*y);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _RightClipperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double x = size.height;
    double y = size.width;
    Path path_0 = Path();
    path_0.moveTo(1.47052/60*x,29.3809/34.61*y);
    path_0.cubicTo(1.47052/60*x,38.7052/34.61*y,2.4542/60*x,49.1913/34.61*y,3.81192/60*x,57.9254/34.61*y);
    path_0.cubicTo(5.43507/60*x,56.3429/34.61*y,7.1753/60*x,54.7047/34.61*y,8.97276/60*x,53.0126/34.61*y);
    path_0.cubicTo(13.5148/60*x,48.7369/34.61*y,18.4221/60*x,44.1173/34.61*y,22.729/60*x,39.1832/34.61*y);
    path_0.cubicTo(29.2302/60*x,31.7352/34.61*y,34.0834/60*x,23.8605/34.61*y,34.0834/60*x,15.8781/34.61*y);
    path_0.cubicTo(34.0834/60*x,8.01476/34.61*y,29.2093/60*x,3.12358/34.61*y,23.1806/60*x,1.55023/34.61*y);
    path_0.cubicTo(17.1064/60*x,-0.0349944/34.61*y,9.91796/60*x,1.7709/34.61*y,5.43536/60*x,7.37413/34.61*y);
    path_0.cubicTo(4.079/60*x,9.06957/34.61*y,3.06627/60*x,11.9959/34.61*y,2.40733/60*x,15.879/34.61*y);
    path_0.cubicTo(1.75447/60*x,19.7262/34.61*y,1.47052/60*x,24.3724/34.61*y,1.47052/60*x,29.3809/34.61*y);
    path_0.close();

    // Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=xSize1/2;
    // paint_0_stroke.color=const Color(0xffE4E9DD).withOpacity(1.0);
    // paint_0_stroke.strokeCap = StrokeCap.round;
    // canvas.drawPath(path_0,paint_0_stroke);

    Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
    paint_0_fill.color = xOnPrimary.withOpacity(1);
    canvas.drawPath(path_0,paint_0_fill);

    // return canvas;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
class _RightCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double x = size.height;
    double y = size.width;
    Path path_0 = Path();
    path_0.moveTo(1.47052/60*x,29.3809/34.61*y);
    path_0.cubicTo(1.47052/60*x,38.7052/34.61*y,2.4542/60*x,49.1913/34.61*y,3.81192/60*x,57.9254/34.61*y);
    path_0.cubicTo(5.43507/60*x,56.3429/34.61*y,7.1753/60*x,54.7047/34.61*y,8.97276/60*x,53.0126/34.61*y);
    path_0.cubicTo(13.5148/60*x,48.7369/34.61*y,18.4221/60*x,44.1173/34.61*y,22.729/60*x,39.1832/34.61*y);
    path_0.cubicTo(29.2302/60*x,31.7352/34.61*y,34.0834/60*x,23.8605/34.61*y,34.0834/60*x,15.8781/34.61*y);
    path_0.cubicTo(34.0834/60*x,8.01476/34.61*y,29.2093/60*x,3.12358/34.61*y,23.1806/60*x,1.55023/34.61*y);
    path_0.cubicTo(17.1064/60*x,-0.0349944/34.61*y,9.91796/60*x,1.7709/34.61*y,5.43536/60*x,7.37413/34.61*y);
    path_0.cubicTo(4.079/60*x,9.06957/34.61*y,3.06627/60*x,11.9959/34.61*y,2.40733/60*x,15.879/34.61*y);
    path_0.cubicTo(1.75447/60*x,19.7262/34.61*y,1.47052/60*x,24.3724/34.61*y,1.47052/60*x,29.3809/34.61*y);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
