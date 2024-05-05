import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/sized_box.dart';

void showNotConnectedOverlayEntry(BuildContext context,
    {required String errorDescription, required String errorText}) {
  late OverlayEntry notConnectedOverlayEntry;
  notConnectedOverlayEntry = OverlayEntry(
    builder: (context) => SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ).copyWith(top: 120),
          child: Container(
            height: 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey,
                ),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 8,
                      spreadRadius: -2,
                      offset: Offset(0, 4),
                      color: Color.fromARGB(58, 24, 40, 15))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _Beat(color: Colors.red, size: 40),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          notConnectedOverlayEntry.remove();
                        },
                      )
                    ],
                  ),
                  h7,
                  Text(
                    errorText,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                  h7,
                  Text(
                    errorDescription,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  Overlay.of(context).insert(notConnectedOverlayEntry);
}

class _Ring extends CustomPainter {
  final Color _color;
  final double _strokeWidth;

  _Ring(
    this._color,
    this._strokeWidth,
  );

  static Widget draw({
    required Color color,
    required double size,
    required double strokeWidth,
  }) =>
      SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _Ring(
            color,
            strokeWidth,
          ),
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Beat extends StatefulWidget {
  final double size;
  final Color color;

  const _Beat({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  _BeatState createState() => _BeatState();
}

class _BeatState extends State<_Beat> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final Color color = widget.color;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            const Icon(
              Icons.info_outline,
              color: Colors.red,
            ),
            Visibility(
              visible: _animationController.value <= 0.7,
              child: Transform.scale(
                scale: Tween<double>(begin: 0.15, end: 1.0)
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.0,
                          0.7,
                          curve: Curves.easeInCubic,
                        ),
                      ),
                    )
                    .value,
                child: Opacity(
                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.0, 0.2),
                        ),
                      )
                      .value,
                  child: _Ring.draw(
                    color: color,
                    size: size,
                    strokeWidth: Tween<double>(begin: size / 50, end: size / 30)
                        .animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.0, 0.7),
                          ),
                        )
                        .value,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value <= 0.7,
              child: _Ring.draw(
                color: color,
                size: size,
                strokeWidth: size / 30,
              ),
            ),
            Visibility(
              visible: _animationController.value <= 0.8 &&
                  _animationController.value >= 0.7,
              child: Transform.scale(
                scale: Tween<double>(begin: 1.0, end: 1.15)
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.7,
                          0.8,
                        ),
                      ),
                    )
                    .value,
                child: _Ring.draw(
                  color: color,
                  size: size,
                  strokeWidth: size / 40,
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value >= 0.8,
              child: Transform.scale(
                scale: Tween<double>(begin: 1.15, end: 1.0)
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(
                          0.8,
                          0.9,
                        ),
                      ),
                    )
                    .value,
                child: _Ring.draw(
                  color: color,
                  size: size,
                  strokeWidth: size / 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
