import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCodeField extends StatefulWidget {
  const VerificationCodeField({
    Key? key,
    this.fieldContentAlignment = MainAxisAlignment.spaceBetween,
    this.fieldSize,
    this.fieldCount = 6,
    required this.onFinished,
    this.debugLogs = false,
    this.ios = false,
    this.leftOnly = false,
    this.styleIos,
  }) : super(key: key);

  /// the alignment in which the text fields stack (it's just like a row)
  final MainAxisAlignment fieldContentAlignment;

  /// the size of each individual input field
  final Size? fieldSize;

  final int fieldCount;

  final Function(String numericCode) onFinished;

  final bool debugLogs;

  final bool ios;
  final bool leftOnly;
  final TextStyle? styleIos;

  @override
  State<VerificationCodeField> createState() => _VerificationCodeFieldState();
}

class _VerificationCodeFieldState extends State<VerificationCodeField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _inputArray = [];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: widget.fieldContentAlignment,
          children: List.generate(
              widget.fieldCount,
              (index) => _generateSingleDigitTextFormField(context,
                  size: widget.fieldSize ?? const Size(48, 64),
                  indexOfThisField: index)),
        ));
  }

  Widget _generateSingleDigitTextFormField(BuildContext context,
      {required Size size, required int indexOfThisField}) {
    void onChanged(v) {
      if (v.isNotEmpty) {
        FocusScope.of(context).nextFocus();
        _inputArray.add(v);
      } else {
        _inputArray.removeLast();

        FocusScope.of(context).previousFocus();
      }

      // prints result
      if (widget.debugLogs) debugPrint(_inputArray.toString());

      // when it's the last square
      if (_inputArray.length == widget.fieldCount) {
        widget.onFinished(_inputArray.join());
      }
    }

    const decoration = InputDecoration(
      alignLabelWithHint: true,
      hintText: "0",
    );

    final format = [
      LengthLimitingTextInputFormatter(1),
      FilteringTextInputFormatter.digitsOnly
    ];

    return SizedBox(
      height: size.height,
      width: size.width,
      child: widget.ios
          ? CupertinoTextField(
              key: Key("$indexOfThisField"),
              onChanged: onChanged,
              style: widget.styleIos ?? TextStyle(fontSize: 20),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              placeholder: "0",
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: CupertinoColors.systemGrey, width: 1.0))),
              inputFormatters: format,
            )
          : TextFormField(
              key: Key("$indexOfThisField"),
              onChanged: onChanged,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(textBaseline: TextBaseline.ideographic),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: decoration,
              inputFormatters: format,
            ),
    );
  }
}
