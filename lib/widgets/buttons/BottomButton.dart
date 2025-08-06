import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/widgets/shared/ballBeatLoading.dart';
import 'package:flutter/material.dart';

class BottomButtonItem {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool disabled;
  final int? buttonType;
  final Widget? customChild;
  final double? width;
  final double? height;

  BottomButtonItem({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.buttonType,
    this.disabled = false,
    this.customChild,
    this.width,
    this.height,
  });
}

// Mantener la clase anterior para compatibilidad hacia atrás
class BottombuttonParams {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool disabled;
  final int? buttonType;

  BottombuttonParams({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.buttonType,
    this.disabled = false,
  });
}

enum BottomButtonLayout { row, column, wrap }

class BottomButton extends StatelessWidget {
  // Para compatibilidad hacia atrás
  final BottombuttonParams? params;
  
  // Nueva API
  final List<BottomButtonItem>? buttons;
  final BottomButtonLayout layout;
  final double gap;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets? padding;
  final bool expandButtons;
  final int? maxButtonsPerRow; // Para layout wrap

  const BottomButton({
    super.key,
    this.params,
    this.buttons,
    this.layout = BottomButtonLayout.row,
    this.gap = 12.0,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding,
    this.expandButtons = true,
    this.maxButtonsPerRow = 2,
  }) : assert(params != null || buttons != null, 'Either params or buttons must be provided');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Apptheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), 
            offset: Offset(0, -2), // Solo hacia arriba
            blurRadius: 8,
            spreadRadius: 0,
          )
        ]
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: _buildButtonLayout(),
      ),
    );
  }

  Widget _buildButtonLayout() {
    // Compatibilidad hacia atrás
    if (params != null) {
      return _buildSingleButton(BottomButtonItem(
        text: params!.text,
        onPressed: params!.onPressed,
        isLoading: params!.isLoading,
        disabled: params!.disabled,
        buttonType: params!.buttonType,
      ));
    }

    if (buttons == null || buttons!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (buttons!.length == 1) {
      return _buildSingleButton(buttons!.first);
    }

    switch (layout) {
      case BottomButtonLayout.row:
        return _buildRowLayout();
      case BottomButtonLayout.column:
        return _buildColumnLayout();
      case BottomButtonLayout.wrap:
        return _buildWrapLayout();
    }
  }

  Widget _buildSingleButton(BottomButtonItem button) {
    return CustomButton(
      button.width ?? double.infinity,
      button.height ?? 46,
      button.customChild ?? (button.isLoading
          ? BallBeatLoading()
          : Text(button.text, style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ))),
      button.isLoading || button.disabled ? null : button.onPressed,
      type: button.buttonType ?? 1,
    );
  }

  Widget _buildRowLayout() {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildButtonList(
        (index, button) => expandButtons 
            ? Expanded(child: _buildSingleButton(button))
            : _buildSingleButton(button),
        Axis.horizontal,
      ),
    );
  }

  Widget _buildColumnLayout() {
    return Column(
      mainAxisAlignment: mainAxisAlignment == MainAxisAlignment.spaceEvenly 
          ? MainAxisAlignment.center 
          : mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment == CrossAxisAlignment.center
          ? CrossAxisAlignment.stretch
          : crossAxisAlignment,
      children: _buildButtonList(
        (index, button) => _buildSingleButton(button),
        Axis.vertical,
      ),
    );
  }

  Widget _buildWrapLayout() {
    List<Widget> rows = [];
    List<BottomButtonItem> currentRow = [];
    
    for (int i = 0; i < buttons!.length; i++) {
      currentRow.add(buttons![i]);
      
      if (currentRow.length == maxButtonsPerRow || i == buttons!.length - 1) {
        rows.add(
          Row(
            mainAxisAlignment: mainAxisAlignment,
            children: currentRow.asMap().entries.map((entry) {
              final button = entry.value;
              Widget buttonWidget = expandButtons 
                  ? Expanded(child: _buildSingleButton(button))
                  : _buildSingleButton(button);
              
              if (entry.key < currentRow.length - 1) {
                return Padding(
                  padding: EdgeInsets.only(right: gap),
                  child: buttonWidget,
                );
              }
              return buttonWidget;
            }).toList(),
          ),
        );
        currentRow.clear();
      }
    }
    
    return Column(
      children: rows.asMap().entries.map((entry) {
        Widget row = entry.value;
        if (entry.key < rows.length - 1) {
          return Padding(
            padding: EdgeInsets.only(bottom: gap),
            child: row,
          );
        }
        return row;
      }).toList(),
    );
  }

  List<Widget> _buildButtonList(
    Widget Function(int index, BottomButtonItem button) buttonBuilder,
    Axis direction,
  ) {
    List<Widget> widgets = [];
    
    for (int i = 0; i < buttons!.length; i++) {
      widgets.add(buttonBuilder(i, buttons![i]));
      
      if (i < buttons!.length - 1) {
        widgets.add(
          direction == Axis.horizontal 
              ? SizedBox(width: gap)
              : SizedBox(height: gap),
        );
      }
    }
    
    return widgets;
  }
}
