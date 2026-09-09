import 'package:insulog/states/custom_button_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButtonWidget extends StatefulWidget {
  final String? text;
  final double? textSize;
  final Color? textColor;
  final Color? onpressTextColor;
  final Color? bgColor;
  final Color? onpressBgColor;
  final IconData? icon;
  final IconData? inverseIcon;
  final Color? iconColor;
  final Color? onpressIconColor;
  final double? iconSize;
  final Border? border;
  final BorderRadius? borderRadius;
  final bool? inversePosition;
  final Gradient? colorGradient;
  final Gradient? onpressColorGradient;
  final bool? selected;
  final bool? isSelectedUnlocked;
  final bool? isColumn;
  final BoxShadow? boxShadow;
  final BoxShadow? onpressBoxShadow;
  final bool? isFontBold;
  final bool? isfont;
  final bool? isLoading;
  final Color? loadingColor;
  final Function()? onPressed;
  final Function()? onTapDown;
  final Function()? onTapUp;
  final Function()? onTapCancel;
  final Color? onpressBorderColor;
  final String? svgPath;
  final String? imagePath;

  const CustomButtonWidget({
    super.key,
    this.icon,
    this.iconSize,
    this.onPressed,
    this.iconColor,
    this.text,
    this.textSize,
    this.textColor,
    this.bgColor,
    this.onpressBgColor,
    this.border,
    this.borderRadius,
    this.onpressIconColor,
    this.onpressTextColor,
    this.inverseIcon,
    this.inversePosition,
    this.selected,
    this.isFontBold,
    this.colorGradient,
    this.isColumn,
    this.boxShadow,
    this.onpressBoxShadow,
    this.isfont,
    this.onpressColorGradient,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.isLoading,
    this.loadingColor,
    this.isSelectedUnlocked,
    this.onpressBorderColor,
    this.svgPath,
    this.imagePath,
  });

  @override
  State<CustomButtonWidget> createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget> {
  final CustomButtonState _state = CustomButtonState();

  @override
  void initState() {
    super.initState();
    _state.addListener(handleNotifier);
  }

  void handleNotifier() {
    setState(() {});
  }

  @override
  void dispose() {
    _state.removeListener(handleNotifier);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading == true) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.colorGradient != null ? null : _getBackgroundColor(),
          border: Border.all(
            color: _getBorderColor(),
            width: widget.border?.top.width ?? 1.0,
          ),
          borderRadius: widget.borderRadius,
          gradient: _getGradient(),
          boxShadow: _getBoxShadow(),
        ),
        child: SizedBox(
          height: 22.0,
          width: 22.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.loadingColor ??
                  widget.iconColor ??
                  Colors.green,
            ),
          ),
        ),
      );
    }

    Widget? iconWidget;

    if (widget.svgPath != null) {
      iconWidget = SvgPicture.asset(
        widget.svgPath!,
        width: widget.iconSize ?? 24.0,
        height: widget.iconSize ?? 24.0, 
      );
    } else if (widget.imagePath != null) {
      iconWidget = Image.asset(
        widget.imagePath!,
        width: widget.iconSize ?? 24.0,
        height: widget.iconSize ?? 24.0, 
      );
    } else if (widget.icon != null) {
      iconWidget = Icon(
        widget.selected == false ? widget.inverseIcon ?? widget.icon : widget.icon,
        size: widget.iconSize ?? 24.0,
        color: _getIconColor(),
      );
    }

    return GestureDetector(
      onTapDown: (_) {
        if (widget.selected == true &&
            (widget.isSelectedUnlocked == false ||
                widget.isSelectedUnlocked == null)) {
          return;
        }
        _state.handleTapDown();
        widget.onTapDown?.call();
      },
      onTapUp: (_) {
        if (widget.selected == true &&
            (widget.isSelectedUnlocked == false ||
                widget.isSelectedUnlocked == null)) {
          return;
        }
        _state.handleTapUp();
        widget.onTapUp?.call();
      },
      onTapCancel: () {
        if (widget.selected == true &&
            (widget.isSelectedUnlocked == false ||
                widget.isSelectedUnlocked == null)) {
          return;
        }
        _state.handleTapCancel();
        widget.onTapCancel?.call();
      },
      onTap: () {
        if (widget.selected == true &&
            (widget.isSelectedUnlocked == false ||
                widget.isSelectedUnlocked == null)) {
          return;
        }
        if (widget.onPressed != null) widget.onPressed!();
        _state.handleTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.colorGradient != null
              ? null
              : widget.colorGradient != null
                  ? null
                  : _getBackgroundColor(),
          border: Border.all(
            color: _getBorderColor(),
            width: widget.border?.top.width ?? 1.0,
          ),
          borderRadius: widget.borderRadius,
          gradient: _getGradient(),
          boxShadow: _getBoxShadow(),
        ),
        child:
            widget.isColumn == null
                ? Row(
                    textDirection:
                        widget.inversePosition == true
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (iconWidget != null) iconWidget,
                      SizedBox(width: (iconWidget != null && widget.text != null) ? 6.0 : 0.0),
                      if (widget.text != null)
                        Text(
                          maxLines: 2,
                          widget.text ?? '',
                          style: TextStyle(
                            fontWeight: widget.isFontBold == true
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: widget.isfont == true ? 'Greyhound' : null,
                            fontSize: widget.textSize ?? 14.0,
                            color: _getTextColor(),
                          ),
                        ),
                    ],
                  )
                : Column(
                    verticalDirection: widget.inversePosition == true
                        ? VerticalDirection.up
                        : VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (iconWidget != null) iconWidget,
                      SizedBox(height: (iconWidget != null && widget.text != null) ? 8.0 : 0.0),
                      if (widget.text != null)
                        Text(
                          maxLines: 2,
                          widget.text ?? '',
                          style: TextStyle(
                            fontWeight: widget.isFontBold == true
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: widget.isfont == true ? 'Greyhound' : null,
                            fontSize: widget.textSize ?? 16.0,
                            color: _getTextColor(),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }

  List<BoxShadow>? _getBoxShadow() {
    // Se o botão for selecionável (selected != null)
    if (widget.selected != null) {
      // Se estiver pressionado e selecionado
      if (_state.isPressed && widget.selected == true) {
        return widget.boxShadow != null ? [widget.boxShadow!] : null;
      }
      // Se NÃO estiver pressionado e estiver selecionado
      else if (!_state.isPressed && widget.selected == true) {
        return widget.onpressBoxShadow != null 
            ? [widget.onpressBoxShadow!] 
            : widget.boxShadow != null 
                ? [widget.boxShadow!] 
                : null;
      }
      // Se estiver pressionado e NÃO estiver selecionado
      else if (_state.isPressed && widget.selected == false) {
        return widget.onpressBoxShadow != null 
            ? [widget.onpressBoxShadow!] 
            : widget.boxShadow != null 
                ? [widget.boxShadow!] 
                : null;
      }
      // Se NÃO estiver pressionado e NÃO estiver selecionado
      else if (!_state.isPressed && widget.selected == false) {
        return widget.boxShadow != null ? [widget.boxShadow!] : null;
      }
    } else {
      // Se não for selecionável
      if (_state.isPressed) {
        return widget.onpressBoxShadow != null 
            ? [widget.onpressBoxShadow!] 
            : widget.boxShadow != null 
                ? [widget.boxShadow!] 
                : null;
      } else {
        return widget.boxShadow != null ? [widget.boxShadow!] : null;
      }
    }
    return widget.boxShadow != null ? [widget.boxShadow!] : null;
  }

  Gradient? _getGradient() {
    // Se o botão for selecionável (selected != null)
    if (widget.selected != null) {
      // Se estiver pressionado e selecionado
      if (_state.isPressed && widget.selected == true) {
        return widget.colorGradient;
      }
      // Se NÃO estiver pressionado e estiver selecionado
      else if (!_state.isPressed && widget.selected == true) {
        return widget.onpressColorGradient ?? widget.colorGradient;
      }
      // Se estiver pressionado e NÃO estiver selecionado
      else if (_state.isPressed && widget.selected == false) {
        return widget.onpressColorGradient ?? widget.colorGradient;
      }
      // Se NÃO estiver pressionado e NÃO estiver selecionado
      else if (!_state.isPressed && widget.selected == false) {
        return widget.colorGradient;
      }
    } else {
      // Se não for selecionável
      if (_state.isPressed) {
        // Se pressionado, usa onpressBgColor se existir, senão transparente
        return widget.onpressColorGradient ?? widget.colorGradient;
      } else {
        return widget.colorGradient;
      }
    }
    return widget.colorGradient;
  }

  Color _getBackgroundColor() {
    // Se o botão for selecionável (selected != null)
    if (widget.selected != null) {
      // Se estiver pressionado e selecionado
      if (_state.isPressed && widget.selected == true) {
        return widget.bgColor ?? Colors.transparent;
      }
      // Se NÃO estiver pressionado e estiver selecionado
      else if (!_state.isPressed && widget.selected == true) {
        return widget.onpressBgColor ?? Colors.transparent;
      }
      // Se estiver pressionado e NÃO estiver selecionado
      else if (_state.isPressed && widget.selected == false) {
        return widget.onpressBgColor ?? Colors.transparent;
      }
      // Se NÃO estiver pressionado e NÃO estiver selecionado
      else if (!_state.isPressed && widget.selected == false) {
        return widget.bgColor ?? Colors.transparent;
      }
    } else {
      // Se não for selecionável
      if (_state.isPressed) {
        // Se pressionado, usa onpressBgColor se existir, senão transparente
        return widget.onpressBgColor ?? Colors.transparent;
      } else {
        return widget.bgColor ?? Colors.transparent;
      }
    }
    return Colors.transparent;
  }

  Color _getTextColor() {
    // Se o botão for selecionável (selected != null)
    if (widget.selected != null) {
      // Se estiver pressionado e selecionado
      if (_state.isPressed && widget.selected == true) {
        return widget.textColor ?? Colors.transparent;
      }
      // Se NÃO estiver pressionado e estiver selecionado
      else if (!_state.isPressed && widget.selected == true) {
        return widget.onpressTextColor ?? Colors.transparent;
      }
      // Se estiver pressionado e NÃO estiver selecionado
      else if (_state.isPressed && widget.selected == false) {
        return widget.onpressTextColor ?? Colors.transparent;
      }
      // Se NÃO estiver pressionado e NÃO estiver selecionado
      else if (!_state.isPressed && widget.selected == false) {
        return widget.textColor ?? Colors.transparent;
      }
    } else {
      // Se não for selecionável
      if (_state.isPressed) {
        // Se pressionado, usa bgColor se existir, senão transparente
        return widget.onpressTextColor ?? Colors.transparent;
      } else {
        return widget.textColor ?? Colors.transparent;
      }
    }
    return Colors.transparent;
  }

  Color _getIconColor() {
    // Se o botão for selecionável (selected != null)
    if (widget.selected != null) {
      // Se estiver pressionado e selecionado
      if (_state.isPressed && widget.selected == true) {
        return widget.iconColor ?? Colors.white;
      }
      // Se NÃO estiver pressionado e estiver selecionado
      else if (!_state.isPressed && widget.selected == true) {
        return widget.onpressIconColor ?? widget.iconColor ?? Colors.white;
      }
      // Se estiver pressionado e NÃO estiver selecionado
      else if (_state.isPressed && widget.selected == false) {
        return widget.onpressIconColor ?? widget.iconColor ?? Colors.white;
      }
      // Se NÃO estiver pressionado e NÃO estiver selecionado
      else if (!_state.isPressed && widget.selected == false) {
        return widget.iconColor ?? Colors.white;
      }
    } else {
      // Se não for selecionável
      if (_state.isPressed) {
        // Se pressionado, usa bgColor se existir, senão transparente
        return widget.onpressIconColor ?? widget.iconColor ?? Colors.white;
      } else {
        return widget.iconColor ?? Colors.white;
      }
    }
    return Colors.white;
  }

    Color _getBorderColor() {
    // Se o botão for selecionável (selected != null)
    if (widget.selected != null) {
      // Se estiver pressionado e selecionado
      if (_state.isPressed && widget.selected == true) {
        return widget.border?.top.color ?? Colors.transparent;
      }
      // Se NÃO estiver pressionado e estiver selecionado
      else if (!_state.isPressed && widget.selected == true) {
        return widget.onpressBorderColor ?? widget.border?.top.color ?? Colors.transparent;  // ✅ Corrigido
      }
      // Se estiver pressionado e NÃO estiver selecionado
      else if (_state.isPressed && widget.selected == false) {
        return widget.onpressBorderColor ?? widget.border?.top.color ?? Colors.transparent;
      }
      // Se NÃO estiver pressionado e NÃO estiver selecionado
      else if (!_state.isPressed && widget.selected == false) {
        return widget.border?.top.color ?? Colors.transparent;
      }
    } else {
      // Se não for selecionável
      if (_state.isPressed) {
        return widget.onpressBorderColor ?? widget.border?.top.color ?? Colors.transparent;
      } else {
        return widget.border?.top.color ?? Colors.transparent;
      }
    }
    return Colors.transparent;
  }
}
