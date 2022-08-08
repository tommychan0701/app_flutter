import 'dart:async';

import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/const.dart';
import 'package:flutter/material.dart';

class SendCoinsResult extends StatefulWidget {
  final bool isSuccess;

  SendCoinsResult(this.isSuccess);

  @override
  _SendCoinsResultState createState() => _SendCoinsResultState();
}

class _SendCoinsResultState extends State<SendCoinsResult>
    with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      _controller.dispose();
      Navigator.pop(context);
    });
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          height: 160,
          width: 160,
          decoration: BoxDecoration(
            color: widget.isSuccess ? Colors.green : Colors.red,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isSuccess
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 35,
                    )
                  : Image(
                      image: AssetImage(icSad),
                      color: Colors.white,
                      height: 50,
                    ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.isSuccess ? 'Sent Successfully' : 'Insufficient Balance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fNSfUiSemiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
