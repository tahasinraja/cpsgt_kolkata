import 'package:calcutta_psapp/mainhome.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class verifyotppage extends StatefulWidget {
  final String phone;
  final String otp;
  const verifyotppage({super.key, required this.phone, required this.otp});

  @override
  State<verifyotppage> createState() => _verifyotppageState();
}

class _verifyotppageState extends State<verifyotppage> {
  bool islodding = false;
  final TextEditingController otpcontroller = TextEditingController();

  Future<void> savelogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('phone', widget.phone);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔷 TOP GRADIENT SECTION
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D3B66), Color(0xFF123F6A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "WELCOME!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset("lib/assets/images/cpsgts.png", height: 100),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(child: Text('OTP Generated For:${widget.phone}')),
            const SizedBox(height: 50),
            Center(child: Text('Enter OTP')),
            SizedBox(height: 15),
            // 🔷 INPUT FIELDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: otpcontroller,
                    keyboardType: TextInputType.number,
                    // obscureText: true,
                    animationType: AnimationType.fade,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 55,
                      fieldWidth: 55,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.grey.shade200,
                      inactiveFillColor: Colors.grey.shade100,
                      activeColor: Colors.blue,
                      selectedColor: Colors.blueAccent,
                      inactiveColor: Colors.grey,
                    ),
                    onChanged: (value) {},
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),

            //const SizedBox(height: 35),

            // 🔷 LOGIN BUTTON
            Container(
              width: 160,
              height: 45,
              decoration: BoxDecoration(
                // gradient: const LinearGradient(
                //   colors: [Color(0xFF0D3B66), Color(0xFF1C5A99)],
                // ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: islodding
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0D3B66),
                        ),
                        onPressed: () async {
                          if (otpcontroller.text.trim() == widget.otp) {
                            await savelogin();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MainPage(phone: widget.phone),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Wrong OTP")),
                            );
                          }
                        },
                        child: const Text(
                          "   VERIFY   ",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
