
import 'dart:math';
import 'package:calcutta_psapp/verifyotppage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class sendotppage extends StatefulWidget {
  const sendotppage({super.key});

  @override
  State<sendotppage> createState() => _sendotppageState();
}

class _sendotppageState extends State<sendotppage> {
  

  bool isLoading = false;

  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController demoPasswordController = TextEditingController();

  String generateOtp() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString(); // 4 digit OTP
  }

  Future<void> sendotp() async {
    final phone = phonecontroller.text.trim();
      // 🔥 DEMO NUMBER FLOW
  if (phone == '7870672231') {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            verifyotppage(phone: phone, otp: '123'),
      ),
    );
    return; // ⛔ OTP / API yahin stop
  }
    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid 10 digit mobile number')),
      );
      return;
    }

    setState(() => isLoading = true);

    final otp = generateOtp();
    final uri = Uri.parse('https://cpsgtinst.org/app/otp.php');
    try {
      final responce = await http.post(
        uri,
        //  headers: {"Content-Type": "application/json"},
        body: {'ph': phone, 'otp': otp},
      );
      if (responce.statusCode == 200) {
       // final data = jsonDecode(responce.body);
        if (responce.body.toLowerCase().contains('otp sent')) {
          print('Otp:$otp');
          print('Api responce:$responce');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  verifyotppage(phone: phonecontroller.text, otp: otp),
            ),
          );
        }else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$phone is not registered')));
        }

        print("🔽 VERIFY RESPONSE: ${responce.body}");
      }
       else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$phone is not registered')));
        }
    } catch (e) {
      print('Error:$e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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

            const SizedBox(height: 50),
            Center(child: Text('Enter Your Mobile Number')),
            SizedBox(height: 15),
            // 🔷 INPUT FIELDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    controller: phonecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_android_outlined),
                      label: Text('Mobile Number'),

                      //  labelText: 'Enter Mobile No.',
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),

            //  const SizedBox(height: 20),

            // 🔷 LOGIN BUTTON
            Container(
              width: 180,
              height: 45,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D3B66), Color(0xFF1C5A99)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () => sendotp(),
                        child: Text(
                          " G E T  O T P",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 3,
                            fontSize: 14,
                          ),
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
