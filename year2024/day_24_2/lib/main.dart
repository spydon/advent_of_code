import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'common.dart';

void main() {
  runApp(GateApp());
}

class GateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advent of Code 2024 - Day 24, part 2 analyzer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    _inputText = text;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter your input',
                ),
                maxLines: null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(
                        game: GateGame(_inputText),
                      ),
                    ),
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GateGame extends FlameGame with ScrollDetector {
  GateGame(this.inputText) : super(world: GateWorld());

  final String inputText;

  final nodes = <NodeComponent>[];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final input = inputText.split('\n').splitWhere((l) => l.isEmpty);

    final inputs = input[0].map((l) {
      final parts = l.split(': ');
      return InputComponent(outputId: parts[0]);
    });

    final outputs = List.generate(
      int.parse(inputs.last.outputId.substring(1)) + 2,
      (i) {
        final id = i < 10 ? 'z0$i' : 'z$i';
        return OutputComponent(outputId: id);
      },
    );

    final gates = input[1].map((l) {
      final parts = l.split(' ');
      return GateComponent(
        type: OperationType.fromString(parts[1]),
        inputId1: parts[0],
        inputId2: parts[2],
        outputId: parts[4],
      );
    });

    nodes.addAll([...inputs, ...outputs, ...gates]);
    world.addAll(nodes);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    final zoom = camera.viewfinder.zoom + info.scrollDelta.global.y.sign * 0.1;
    camera.viewfinder.zoom = clampDouble(zoom, 0.1, 2.0);
  }
}

class GateWorld extends World with DragCallbacks {
  @override
  void onDragUpdate(DragUpdateEvent event) {
    (parent as FlameGame).camera.viewfinder.position -= event.localDelta;
  }
}

class GateComponent extends NodeComponent with DragCallbacks {
  GateComponent({
    required super.type,
    required super.outputId,
    required this.inputId1,
    required this.inputId2,
  }) : super(borderColor: Colors.grey.shade100);

  final String inputId1;
  final String inputId2;
  final List<NodeComponent> inputs = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    radius = 30;
    for (final gate in game.nodes) {
      if (gate.outputId == inputId1 || gate.outputId == inputId2) {
        inputs.add(gate);
        game.world.add(LineComponent(this, gate));
        gate.output.addListener(updateOutput);
      }
    }
    await Future.wait(inputs.map((e) => e.loaded));
    position =
        inputs.map((e) => e.position as Vector2).reduce((a, b) => a + b) / 2;
    position += switch (type) {
      OperationType.and => Vector2(100, 150),
      OperationType.or => Vector2(0, 150),
      OperationType.xor => Vector2(0, 150),
      OperationType.input => Vector2.zero(),
      OperationType.output => Vector2.zero(),
    };

    if (outputId.startsWith('z')) {
      position += Vector2(0, 60);
    }

    add(
      TextComponent(text: type.name, position: size / 2, anchor: Anchor.center),
    );
    updateOutput();
  }

  @override
  void updateOutput() {
    output.value = (switch (type) {
      OperationType.and => inputs[0].output.value && inputs[1].output.value,
      OperationType.or => inputs[0].output.value || inputs[1].output.value,
      OperationType.xor => inputs[0].output.value ^ inputs[1].output.value,
      OperationType.input => throw UnimplementedError(),
      OperationType.output => throw UnimplementedError(),
    });
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }
}

class InputComponent extends NodeComponent with TapCallbacks {
  InputComponent({required super.outputId})
      : super(
          type: OperationType.input,
          borderColor: Colors.grey.shade600,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final isX = outputId.startsWith('x');
    final numberId = int.parse(outputId.substring(1));
    position = Vector2(
      numberId * 300.0 + (!isX ? 100 : 0),
      numberId * 200.0,
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    output.value = !output.value;
  }

  @override
  void updateOutput() {
    // Do nothing, only triggered by user input.
  }
}

class OutputComponent extends NodeComponent {
  OutputComponent({required super.outputId})
      : super(
          type: OperationType.output,
          borderColor: Colors.grey.shade600,
        );

  late NodeComponent input;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    for (final gate in game.nodes) {
      if (gate.outputId == outputId && gate != this) {
        gate.output.addListener(updateOutput);
        input = gate;
        break;
      }
    }
    game.world.add(LineComponent(this, input));
    input.position.addListener(updatePosition);
    updatePosition();
    updateOutput();
  }

  void updatePosition() {
    position = input.position + Vector2(0, 200);
  }

  @override
  void updateOutput() {
    output.value = input.output.value;
  }
}

sealed class NodeComponent extends CircleComponent
    with HasGameReference<GateGame> {
  NodeComponent({
    required this.type,
    required this.outputId,
    required Color borderColor,
  }) : super(radius: 20, anchor: Anchor.center) {
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    paintLayers = [paint, borderPaint];
    output.addListener(updateColor);
    updateColor();
    add(Name(text: outputId, position: Vector2(0, 40)));
  }

  final OperationType type;
  final String outputId;
  ValueNotifier<bool> output = ValueNotifier(true);

  void updateColor() {
    paint.color = output.value ? Colors.green : Colors.red;
  }

  void updateOutput();
}

class LineComponent extends Component with HasPaint {
  LineComponent(this.output, this.input) : super(priority: -1) {
    paint.strokeWidth = 4;
  }

  final PositionComponent output;
  final PositionComponent input;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    paint.color = (input as HasPaint).paint.color;
    final outputOffset = output.position.toOffset();
    final inputOffset = input.position.toOffset();
    canvas.drawLine(outputOffset, inputOffset, paint);

    final midPoint = (outputOffset + inputOffset) / 2;

    final direction = (outputOffset - inputOffset).direction;
    final arrowLength = 10.0;
    final arrowAngle = 0.5;

    final arrowPoint1 =
        midPoint + Offset.fromDirection(direction + arrowAngle, -arrowLength);
    final arrowPoint2 =
        midPoint + Offset.fromDirection(direction - arrowAngle, -arrowLength);
    canvas.drawLine(midPoint, arrowPoint1, paint);
    canvas.drawLine(midPoint, arrowPoint2, paint);
  }
}

class Name extends TextComponent with HasPaint {
  Name({
    required super.text,
    super.position,
    super.anchor,
  });

  late final RRect background;
  final Vector2 backgroundPadding = Vector2.all(10);

  @override
  Future<void> onLoad() async {
    background = RRect.fromRectAndRadius(
      (size + backgroundPadding)
          .toRect()
          .translate(-backgroundPadding.x / 2, -backgroundPadding.y / 2),
      const Radius.circular(4),
    );
    paint = Paint()..color = Colors.purple.withValues(alpha: 0.6);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(background, paint);
    super.render(canvas);
  }
}

enum OperationType {
  input,
  output,
  and,
  or,
  xor;

  static OperationType fromString(String input) {
    return switch (input) {
      'AND' => OperationType.and,
      'OR' => OperationType.or,
      'XOR' => OperationType.xor,
      String() => throw UnimplementedError(),
    };
  }
}
