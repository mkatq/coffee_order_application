import 'package:flutter/material.dart';

class Verification extends StatelessWidget {
  Verification({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    Text('Verification',
                        style: TextStyle(
                            fontFamily: 'sans-serif',
                            fontSize: 28,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    Text('Enter the OTP code we sent you',
                        style: TextStyle(
                          color: Color.fromARGB(255, 163, 163, 163),
                          fontFamily: 'sans-serif',
                          fontSize: 16,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    VerificationCodeDigit(),
                    VerificationCodeDigit(),
                    VerificationCodeDigit(),
                    VerificationCodeDigit(),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFF2B2D2F))),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Confirm',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}

class VerificationCodeDigit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
