import 'package:calcutta_psapp/mainhome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  Future<void> loginuser() async {
    final uri = Uri.parse('https://cpsgtinst.org/app/login.php?');
    try {
      final response = await http.post(
        uri,
        body: {'ph': phonecontroller.text, 'pass': passwordcontroller.text},
      );
      if (response.statusCode == 200) {
        final data = response.body;
        if(data.contains('success')){
 final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('phone', phonecontroller.text);
            print('Login successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(phone: phonecontroller.text),
          ),
        );
      } else {
        print('Login failed with status: ${response.statusCode}');
      }
        }

       

    
    } catch (e) {
      print('Error during login: $e');
    }
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final phone = prefs.getString('phone') ?? '';

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(phone: phone)),

        //  HomePage(phone: phone)
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
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
              height: 300,
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
                children: [
                  const Text(
                    "WELCOME!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset("lib/assets/images/cpsgts.png", height: 90),
                ],
              ),
            ),
        
            const SizedBox(height: 30),
        
            // 🔷 INPUT FIELDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _inputField(
                    "registered PhoneNumber",
                    controller: phonecontroller,
                    
                  ),
                  const SizedBox(height: 15),
                  _inputField(
                    "Password",
                    controller: passwordcontroller,
                    isPassword: true,
                  ),
                ],
              ),
            ),
        
            const SizedBox(height: 25),
        
            // 🔷 LOGIN BUTTON
            Container(
              width: 160,
              height: 45,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D3B66), Color(0xFF1C5A99)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    loginuser();
                  },
                  child: Text(
                    "L O G I N",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 3,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        
            const SizedBox(height: 20),
        
            // 🔷 SIGN UP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("New to CPSI App? "),
                Icon(Icons.arrow_right_alt, color: Colors.green),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // // 🔷 BOTTOM NAV BAR
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   selectedItemColor: const Color(0xFF0D3B66),
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.login),
      //       label: "Login",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: "",
      //     ),
      //   ],
      // ),
    );
  }

  // 🔷 TEXT FIELD
  Widget _inputField(
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller, // ✅ IMPORTANT
      obscureText: isPassword,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0D3B66)),
        ),
      ),
    );
  }
}
