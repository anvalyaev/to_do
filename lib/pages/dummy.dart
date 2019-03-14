import 'package:flutter/material.dart';

class Dummy extends StatelessWidget {
  final String name;
  
  Dummy(this.name);
  @override
  Widget build(BuildContext context){
      return Scaffold(
        body: Container(
          child:Center(child:Text(name))
        ),
      ); 
  }


  }