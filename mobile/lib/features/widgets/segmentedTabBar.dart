import 'dart:math';

import 'package:flutter/material.dart';

class SegmentedTabBar  extends StatelessWidget{
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;
  final bool isLoginActive;

  const SegmentedTabBar({
    required this.onLoginTap,
    required this.onRegisterTap,
    this.isLoginActive = true,  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
       height: 54,
       padding: const EdgeInsets.all(6),
       decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black12)),
          child: Row(
             children: [
                 Expanded(
                    child: GestureDetector(
                        onTap: onLoginTap,
                        child: Container(
                            decoration: BoxDecoration(
                              color: isLoginActive ? Colors.white : Colors.transparent, 
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: isLoginActive ? 
                                 const [
                                    BoxShadow(
                                       color: Colors.black12,
                                       blurRadius: 4,
                                       offset: Offset(0, 3),
                                    )
                                 ] : []
                              ), 
                              alignment: Alignment.center,
                              child: const Text(
                                'Login', 
                                style: TextStyle(
                                   fontWeight: FontWeight.w600,
                                )
                              ),
                        ),
                    ),
                 ),
                 Expanded(
                    child: GestureDetector(
                        onTap: onRegisterTap,
                        child: Container(
                            decoration: BoxDecoration(
                              color: !isLoginActive ? Colors.white : Colors.transparent, 
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: !isLoginActive ? 
                                 const [
                                    BoxShadow(
                                       color: Colors.black12,
                                       blurRadius: 4,
                                       offset: Offset(0, 3),
                                    )
                                 ] : []
                              ), 
                              alignment: Alignment.center,
                              child: const Text(
                                'Register', 
                                style: TextStyle(
                                   fontWeight: FontWeight.w600,
                                )
                              ),
                        ),
                    ),
                 ),
             ],
          ),
    );
  }

}