import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCodeField extends StatefulWidget {
  const VerificationCodeField(
      {Key? key,
      this.fieldContentAlignment = MainAxisAlignment.spaceBetween,
      this.fieldSize,
      this.fieldCount = 6,
      required this.onFinished,
      this.debugLogs = false})
      : super(key: key);

  /// the alignment in which the text fields stack (it's just like a row)
  final MainAxisAlignment fieldContentAlignment;

  /// the size of each individual input field
  final Size? fieldSize;

  final int fieldCount;

  final Function(String numericCode) onFinished;

  final bool debugLogs;

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
    return SizedBox(
      height: size.height,
      width: size.width,
      child: TextFormField(
        key: Key("$indexOfThisField"),
        onChanged: (v) {
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
        },
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(textBaseline: TextBaseline.ideographic),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: "0",
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
