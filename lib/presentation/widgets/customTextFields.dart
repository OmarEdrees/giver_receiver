import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode focusNode;
  final int maxLines;
  final int minLines;
  final void Function() onTap;
  final bool readOnly;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    required this.validator,
    required this.focusNode,
    this.maxLines = 1,
    this.minLines = 1,
    this.onTap = _defaultOnTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.emailAddress,
    this.inputFormatters = const <TextInputFormatter>[],
  });

  static void _defaultOnTap() {}

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.minLines,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      maxLines: widget.maxLines,
      focusNode: widget.focusNode,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors().primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black, width: 3),
        ),

        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon),
              const SizedBox(width: 8),
              Container(
                height: 24,
                width: 1,
                color: Colors.grey, // الخط الفاصل
              ),
            ],
          ),
        ),
        prefixIconColor: AppColors().primaryColor,

        // إذا كان Password، بنضيف الأيقونة
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors().primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // قلب الحالة
                  });
                },
              )
            : null,
      ),
      cursorColor: Colors.black,
    );
  }
}
