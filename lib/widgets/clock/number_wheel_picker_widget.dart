import 'package:flutter/material.dart';

class NumberWheelPickerWidget extends StatefulWidget {
  final int value;
  final int minimum;
  final int maximum;
  final ValueChanged<int> onChanged;
  final double width;
  final double height;

  const NumberWheelPickerWidget({
    super.key,
    required this.value,
    required this.minimum,
    required this.maximum,
    required this.onChanged,
    required this.width,
    required this.height,
  });

  @override
  State<NumberWheelPickerWidget> createState() =>
      _NumberWheelPickerWidgetState();
}

class _NumberWheelPickerWidgetState extends State<NumberWheelPickerWidget> {
  late final FixedExtentScrollController _controller;

  int get _itemCount => widget.maximum - widget.minimum + 1;
  int get _selectedIndex => widget.value - widget.minimum;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void didUpdateWidget(covariant NumberWheelPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value &&
        _controller.hasClients &&
        _controller.selectedItem != _selectedIndex) {
      _controller.animateToItem(
        _selectedIndex,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemExtent = widget.height / 3;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: itemExtent,
            decoration: BoxDecoration(
              color: const Color(0xFF3EA75F).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF3EA75F), width: 1.5),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: itemExtent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 1.35,
            perspective: 0.003,
            overAndUnderCenterOpacity: 0.35,
            onSelectedItemChanged: (index) {
              final newValue = widget.minimum + index;

              if (newValue != widget.value) {
                widget.onChanged(newValue);
              }
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: _itemCount,
              builder: (context, index) {
                final number = widget.minimum + index;

                return Center(
                  child: Text(
                    number.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: number == widget.value
                          ? const Color(0xFF171717)
                          : const Color(0xFF6B6B6B),
                      fontSize: widget.width * 0.36,
                      fontWeight: number == widget.value
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
