import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery/layout.dart';
import 'package:fluttery/gestures.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Radial Menu',
      theme: new ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildMenu() {
    return IconButton(
      icon: Icon(Icons.cancel),
      onPressed: () {},
    );
  }

  Widget _buildCenterMenu() {
    return AnchoredRadialMenu(
      child: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildMenu(),
        actions: <Widget>[_buildMenu()],
      ),
      body: Center(
          child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: _buildCenterMenu(),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildMenu(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildMenu(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _buildMenu(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _buildMenu(),
          ),
        ],
      )),
    );
  }
}

class AnchoredRadialMenu extends StatefulWidget {
  final Widget child;
  AnchoredRadialMenu({this.child});
  @override
  _AnchoredRadialMenuState createState() => _AnchoredRadialMenuState();
}

class _AnchoredRadialMenuState extends State<AnchoredRadialMenu> {
  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      child: widget.child,
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return RadialMenu(
          anchor: offset,
        );
      },
    );
  }
}

class RadialMenu extends StatefulWidget {
  final Offset anchor;
  final double radius;
  RadialMenu({this.anchor, this.radius = 75.0});
  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  static const Color openBubbleColor = Color(0xFFAAAAAA);
  static const Color expandedBubbleColor = const Color(0xFF666666);
  RadialMenuController _menuController;
  @override
  void initState() {
    super.initState();

    _menuController = RadialMenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    Timer(
      Duration(seconds: 2),
      () {
        _menuController.open();
      },
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    super.dispose();
  }

  Widget buildCenter() {
    IconData icon;
    Color bubbleColor;
    double scale = 1.0;
    switch (_menuController.state) {
      case RadialMenuState.closed:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 0.0;
        break;
      case RadialMenuState.opening:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = _menuController.progress;
        break;
      case RadialMenuState.closing:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 1 - _menuController.progress;
        break;
      case RadialMenuState.open:
        icon = Icons.menu;
        bubbleColor = openBubbleColor;
        scale = 1.0;
        break;
      default:
        icon = Icons.clear;
        bubbleColor = expandedBubbleColor;
        scale = 1.0;
        break;
    }
    return CenterAbout(
      position: widget.anchor,
      child: Transform(
        transform: Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        child: IconBubble(
          icon: icon,
          diameter: 50.0,
          iconColor: Colors.black,
          bubbleColor: bubbleColor,
        ),
      ),
    );
  }

  Widget buildRadialBubble(
      {IconData icon, Color iconColor, Color bubbleColor, double angle}) {
    if (_menuController.state == RadialMenuState.closed ||
        _menuController.state == RadialMenuState.closing ||
        _menuController.state == RadialMenuState.open ||
        _menuController.state == RadialMenuState.opening ||
        _menuController.state == RadialMenuState.dissipating) {
      return Container();
    }
    return PolarPosition(
        origin: widget.anchor,
        coord: PolarCoord(angle, widget.radius),
        child: IconBubble(
          diameter: 50.0,
          icon: icon,
          iconColor: iconColor,
          bubbleColor: bubbleColor,
        ));
  }

  Widget buildActivation() {
    return CenterAbout(
      position: widget.anchor,
      child: CustomPaint(
        painter: ActivationPainter(
            radius: widget.radius,
            thickness: 50.0,
            color: Colors.blue,
            startAngle: -pi / 2,
            endAngle: -pi / 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildCenter(),
        buildRadialBubble(
            icon: Icons.home,
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            angle: -pi / 2),
        buildRadialBubble(
            icon: Icons.search,
            iconColor: Colors.white,
            bubbleColor: Colors.green,
            angle: -pi / 2 + (1 * 2 * pi / 5)),
        buildRadialBubble(
            icon: Icons.alarm,
            iconColor: Colors.white,
            bubbleColor: Colors.red,
            angle: -pi / 2 + (2 * 2 * pi / 5)),
        buildRadialBubble(
            icon: Icons.settings,
            iconColor: Colors.white,
            bubbleColor: Colors.purple,
            angle: -pi / 2 + (3 * 2 * pi / 5)),
        buildRadialBubble(
            icon: Icons.location_on,
            iconColor: Colors.white,
            bubbleColor: Colors.orange,
            angle: -pi / 2 + (4 * 2 * pi / 5)),
        buildActivation()
      ],
    );
  }
}

class ActivationPainter extends CustomPainter {
  final double radius;
  final double thickness;
  final Color color;
  final double startAngle;
  final double endAngle;
  var activationPaint;

  ActivationPainter(
      {this.radius, this.thickness, this.color, this.startAngle, this.endAngle})
      : activationPaint = new Paint()
          ..color = color
          ..strokeWidth = thickness
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(Rect.fromLTWH(-radius, -radius, radius * 2, radius * 2),
        startAngle, endAngle - startAngle, false, activationPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class IconBubble extends StatelessWidget {
  final IconData icon;
  final double diameter;
  final Color iconColor;
  final Color bubbleColor;

  IconBubble({this.icon, this.diameter, this.iconColor, this.bubbleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bubbleColor,
      ),
      child: Icon(icon, color: iconColor),
    );
  }
}

class PolarPosition extends StatelessWidget {
  final Offset origin;
  final PolarCoord coord;
  final Widget child;

  PolarPosition({this.origin = const Offset(0.0, 0.0), this.coord, this.child});

  @override
  Widget build(BuildContext context) {
    final Offset offset = Offset(origin.dx + cos(coord.angle) * coord.radius,
        origin.dy + sin(coord.angle) * coord.radius);
    return CenterAbout(
      position: offset,
      child: child,
    );
  }
}

class RadialMenuController extends ChangeNotifier {
  final AnimationController _progress;
  RadialMenuState _state = RadialMenuState.closed;
  RadialMenuController({@required TickerProvider vsync})
      : _progress = AnimationController(vsync: vsync) {
    _progress
      ..addListener(_onProgressListener)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _onTransitionCompleted();
        }
      });
  }

  void _onProgressListener() {
    notifyListeners();
  }

  void _onTransitionCompleted() {
    switch (_state) {
      case RadialMenuState.closing:
        _state = RadialMenuState.closed;
        break;
      case RadialMenuState.opening:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.expanding:
        _state = RadialMenuState.expanded;
        break;
      case RadialMenuState.collapsing:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.activating:
        _state = RadialMenuState.dissipating;
        _progress.duration = Duration(milliseconds: 500);
        _progress.forward(from: 0.0);
        break;
      case RadialMenuState.dissipating:
        _state = RadialMenuState.open;
        break;
      case RadialMenuState.closed:
      case RadialMenuState.open:
      case RadialMenuState.expanded:
        throw Exception('Invalid state during a transition: $_state');
        break;
    }

    notifyListeners();
  }

  RadialMenuState get state => _state;

  double get progress => _progress.value;

  void open() {
    if (_state == RadialMenuState.closed) {
      _state = RadialMenuState.opening;
      _progress.duration = Duration(milliseconds: 250);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  void close() {
    if (_state == RadialMenuState.open) {
      _state = RadialMenuState.closing;
      _progress.duration = Duration(milliseconds: 250);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  void expand() {
    if (_state == RadialMenuState.open) {
      _state = RadialMenuState.expanding;
      _progress.duration = Duration(milliseconds: 150);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  void collapse() {
    if (_state == RadialMenuState.expanded) {
      _state = RadialMenuState.collapsing;
      _progress.duration = Duration(milliseconds: 150);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }

  void activate(String menuItemId) {
    if (_state == RadialMenuState.expanded) {
      _state = RadialMenuState.activating;
      _progress.duration = Duration(milliseconds: 500);
      _progress.forward(from: 0.0);
      notifyListeners();
    }
  }
}

enum RadialMenuState {
  closed,
  closing,
  opening,
  open,
  expanding,
  collapsing,
  expanded,
  activating,
  dissipating
}
