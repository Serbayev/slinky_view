import 'package:flutter/material.dart';
import 'package:slinky_view/slinky_view.dart';

typedef OnPointerUp = void Function();

/// SlinkyPanel is a scrollable panel.
class SlinkyPanel extends StatefulWidget {
  const SlinkyPanel({
    super.key,
    required this.panelParameter,
    required this.scrollAnimationParameter,
    required this.onPointerUp,
    required this.controller,
    required this.scrollToTopStream,
  });

  /// SlinkyPannelParameter is a class that handles panel parameters.
  final SlinkyPanelParameter panelParameter;

  /// SlinkyScrollParameter is a class that scroll animation parameters.
  final SlinkyScrollParameter scrollAnimationParameter;

  /// Called when a pointer is no longer in contact with the screen.
  final OnPointerUp onPointerUp;

  ///  A controller that can be used to programmatically control this panel.
  final SlinkyController controller;

  /// This Stream is for scrolling to Top.
  final Stream<void> scrollToTopStream;

  @override
  SlinkyPannelState createState() => SlinkyPannelState();
}

class SlinkyPannelState extends State<SlinkyPanel> {
  late ScrollController _scrollController;
  late double _currentPosition; // Текущее положение панели

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _currentPosition = widget.panelParameter.minSize;

    widget.scrollToTopStream.listen((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: widget.scrollAnimationParameter.duration,
          curve: widget.scrollAnimationParameter.curve,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) {
        widget.onPointerUp();
        _continueFlingIfNeeded();
      },
      child: DraggableScrollableSheet(
        controller: widget.controller,
        maxChildSize: widget.panelParameter.maxSize,
        minChildSize: widget.panelParameter.minSize,
        initialChildSize: widget.panelParameter.minSize,
        builder: (context, scrollController) {
          _scrollController = scrollController;

          return ClipRRect(
            borderRadius: widget.panelParameter.borderRadius,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  _currentPosition = widget.controller.size;
                }
                return false;
              },
              child: CustomScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  widget.panelParameter.appBar,
                  ...widget.panelParameter.contents,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _continueFlingIfNeeded() {
    // Продолжаем скролл, если была инерция
    final velocity = _scrollController.position.activity?.velocity ?? 0.0;
    if (velocity != 0.0) {
      final targetPosition = _calculateFlingTarget(velocity);
      widget.controller.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  double _calculateFlingTarget(double velocity) {
    // Рассчитываем конечную позицию панели на основе скорости
    const threshold = 0.5; // Порог для "среднего" положения
    if (velocity > 0) {
      // Если движение вверх
      return _currentPosition > threshold
          ? widget.panelParameter.maxSize
          : widget.panelParameter.minSize;
    } else {
      // Если движение вниз
      return _currentPosition > threshold
          ? widget.panelParameter.maxSize
          : widget.panelParameter.minSize;
    }
  }
}