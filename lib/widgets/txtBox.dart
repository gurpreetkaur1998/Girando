import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class txtBox extends StatelessWidget {
  String hintText;

  IconData? icon;

  bool isObscure;

  TextEditingController txtcontroller;

  bool isRequired;

  TextInputType keyboardType;

  txtBox({
    Key? key,
    required this.txtcontroller,
    required this.hintText,
    required this.icon,
    this.isObscure = false,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        style: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 100),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            top: 13,
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: hintText,
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  color: Colors.black,
                )
              : null,
          hintStyle: const TextStyle(
            fontSize: 15.0,
            color: Colors.grey,
          ),
        ),
        textInputAction: TextInputAction.next,
        maxLines: 1,
        controller: txtcontroller,
        obscureText: isObscure,
      ),
    );
  }
}
