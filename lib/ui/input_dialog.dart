import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  final String hintText;
  final String initialText;

  InputDialog({
    Key key,
    @required this.hintText,
    @required this.onSubmit,
    this.initialText,
  }) : super(key: key);

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  bool canSubmit = false;
  TextEditingController textController;
  String error;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      shape: theme.bottomSheetTheme.shape,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: TextField(
          controller: textController,
          onChanged: (value) {
            final hasText = value.isNotEmpty;

            if (canSubmit != hasText) {
              setState(() {
                error = null;
                canSubmit = hasText;
              });
            } else if (error != null) {
              setState(() {
                error = null;
              });
            }
          },
          autofocus: true,
          onSubmitted: (value) => _onSubmit(),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.hintText,
            errorText: error,
            suffixIcon: canSubmit
                ? IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () => _onSubmit(),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final text = textController.text;

    try {
      widget.onSubmit(text);
      Navigator.pop(context);
    } on Exception catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }
}
