import 'package:flutter/material.dart';
import 'package:slinky_view/slinky_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SlinkyView example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _controller = SlinkyController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlinkyView(
      controller: _controller,
      panelParameter: SlinkyPanelParameter(
        appBar: SliverAppBar(),
        child: SizedBox(),
      ),
      body: Container(
        color: Colors.blue.shade100,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
