import 'package:flutter/widgets.dart';

class GetController {
  Set<State> states = {};

  void update() {
    states.where((state) => state.mounted).forEach((state) {
      state.setState(() {});
    });
  }
}

class GetBuilder<T extends GetController> extends StatefulWidget {
  Widget Function(T) builder;
  GetBuilder({
    this.builder,
  });

  @override
  _GetBuilderState createState() => _GetBuilderState();
}

class _GetBuilderState extends State<GetBuilder> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
