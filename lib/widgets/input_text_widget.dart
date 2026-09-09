import 'package:flutter/material.dart';

class InputTextWidget extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isPassword;
  final Size size;
  final TextEditingController controller;
  final String? errorMessage;

  const InputTextWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.isPassword,
    required this.size,
    this.errorMessage,
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool get _hasError =>
      widget.errorMessage != null && widget.errorMessage!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && _hasError) {
      _showErrorBubble();
    } else {
      _removeErrorBubble();
    }
  }

  void _showErrorBubble() {
    _removeErrorBubble();

    final overlay = Overlay.of(context);
    if (!_hasError) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: IgnorePointer(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 66),
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 260),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.errorMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeErrorBubble() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void didUpdateWidget(covariant InputTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_focusNode.hasFocus) {
      _removeErrorBubble();
      return;
    }

    if (_hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNode.hasFocus) {
          _showErrorBubble();
        }
      });
    } else {
      _removeErrorBubble();
    }
  }

  @override
  void dispose() {
    _removeErrorBubble();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(
      Radius.circular(widget.size.width * 0.035),
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        autofocus: false,
        obscureText: widget.isPassword,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.placeholder,
          errorText: null,
          labelStyle: TextStyle(
            color: _hasError ? Colors.red : Colors.grey,
            fontSize: widget.size.height * 0.03,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: _hasError ? Colors.red : Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: _hasError ? Colors.red : const Color(0xFF3EA75F),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
