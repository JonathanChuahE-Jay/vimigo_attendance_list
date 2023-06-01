import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Vimigo attendance lists'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Container(
        margin: EdgeInsets.all(50.0),
        child: Image.network('https://vimigotech.com/wp-content/uploads/2021/06/vimigoTechnologies_partner_vimigo_colour@2x.png'),


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('you clicked me');
        },
        child: Text('click'),
        backgroundColor: Colors.red[400],
      ),
    );

  }
}
