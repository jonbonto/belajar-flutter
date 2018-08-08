import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/component.dart';
import 'package:flame/game.dart';

void main()  async {
  Flame.util.enableEvents();
  Flame.audio.disableLog();
  var dimensions = await Flame.util.initialDimensions();
  new MyGame(dimensions).start();
}

class MyGame extends Game {
  Size dimensions;
  Crate crate;

  MyGame(this.dimensions) {
    this.crate = new Crate();
    this.crate.x = dimensions.width / 2;
    this.crate.y = 200.0;
  }
  @override
  void render(Canvas canvas) {
    crate.render(canvas);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

}

class Crate extends SpriteComponent {
  Crate(): super.square(128.0, 'crate.png') {
    this.angle = 0.0;
  }

}
