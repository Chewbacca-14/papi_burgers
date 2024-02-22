import 'package:flutter/material.dart';
import 'package:papi_burgers/constants/color_palette.dart';

class AddressInfoTextField extends StatefulWidget {
  final TextEditingController addressController;
  final String hintText;
  final IconData iconData;
  final void Function(String)? onChanged;
  final TextInputType? keyBoardType;

  const AddressInfoTextField({
    super.key,
    required this.addressController,
    required this.hintText,
    required this.iconData,
    this.onChanged,
    this.keyBoardType,
  });

  @override
  State<AddressInfoTextField> createState() => _AddressInfoTextFieldState();
}

class _AddressInfoTextFieldState extends State<AddressInfoTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1.3, color: grey4),
      ),
      child: TextField(
        keyboardType: widget.keyBoardType,
        onChanged: widget.onChanged,
        controller: widget.addressController,
        decoration: InputDecoration(
            prefixIcon: Icon(widget.iconData),
            border: InputBorder.none,
            hintText: widget.hintText),
      ),
    );
  }
}
