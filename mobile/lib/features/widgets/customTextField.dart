import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool showToggleIcon;
  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.showToggleIcon = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;
  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12)
      ),
      child: Row(
          children: [
             Icon(widget.icon, color: const Color(0xFF1E293B)),
             const SizedBox(width: 12),
             Expanded(
              child: TextFormField(
                  controller: widget.controller,
                  
                  obscureText: _obscure,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(color: Colors.black45),
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
              )
              ), 
              if (widget.showToggleIcon)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF1E293B)

                  )
                )
          ],
      ),
    );
  }
}
