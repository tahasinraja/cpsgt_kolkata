import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class paymentpage extends StatefulWidget {
  final String phone;
  const paymentpage({super.key, required this.phone});

  @override
  State<paymentpage> createState() => _paymentpageState();
}

class _paymentpageState extends State<paymentpage> {
  Map<String, dynamic>? paymentlist;
  late Razorpay _razorpay;

  // ================= FETCH DUE =================
  Future<void> fetchAmount() async {
    final uri =
        Uri.parse('https://cpsgtinst.org/app/due.php?ph=${widget.phone}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() => paymentlist = data['stock'][0]);
      print("💰 Paying amount: ${paymentlist!['due']} rupees");
print("📝 User: ${paymentlist!['name']}, Phone: ${widget.phone}");

    }
  }

  // ================= OPEN RAZORPAY =================

 // var orderId = "ORD_${DateTime.now().millisecondsSinceEpoch}";
void openRazorpay(String orderId, int amount, String name, String email, String contact) {
  var options = {
    'key':'rzp_live_JlDOXuPCT5TpID', // LIVE key
    'amount': amount * 100, // rupees → paise
    'currency': 'INR',
    'name': 'Calcutta Police Sergeant\'s Institute',
    'description': 'Payment for Order #$orderId',
   // 'order_id': orderId, // 🔥 MUST for server verification
    'prefill': {
      'email': email,
      'contact': contact,
    },
  };

  _razorpay.open(options);
}


  // ================= SUCCESS =================
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    updatePaymentStatus(
      response.paymentId,
      null,
      response.signature,
      "success",
    );
  print("Payment ID: ${response.paymentId}");
  print("Order ID: ${response.orderId}");
  print("Signature: ${response.signature}");
  
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful")),
    );
  }

  // ================= FAILED =================
  void _handlePaymentError(PaymentFailureResponse response) {
    updatePaymentStatus(null, null, null, "failed");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed")),
    );
  }

  // ================= UPDATE SERVER =================
Future<void> updatePaymentStatus(
  String? paymentId,
  String? orderId,
  String? signature,
  String status,
) async {
  final uri = Uri.parse('https://cpsgtinst.org/app/payment_insert.php');
  final body = jsonEncode({
    'payment_id': paymentId,
    'mem_id': paymentlist!['mem_id'],
    'amount': paymentlist!['due'], // make sure this matches the server
    'name': paymentlist!['name'],
    'ph': paymentlist!['ph'],
    'email': paymentlist!['email'] ?? '',
    'status': status,
    'order_id': orderId ?? 'NO_ORDER', // send something non-empty
  });

  print("🔹 Sending payment update to server:");
  print("URL: $uri");
  print("Body: $body");

  try {
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print("🔹 Server response status: ${res.statusCode}");
    print("🔹 Server response body: ${res.body}");

    if (res.statusCode == 200) {
      print("✅ Payment update successful!");
      fetchAmount(); // refresh UI
    } else {
      print("❌ Payment update failed!");
    }
  } catch (e) {
    print("⚠️ Error updating payment: $e");
  }
}



  @override
  void initState() {
    super.initState();
    fetchAmount();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Details",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D3B66),
        centerTitle: true,
      ),
      body: paymentlist == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                     
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        infoRow("Name", paymentlist!['name']),
                        infoRow("Member ID", paymentlist!['mem_id']),
                        infoRow("Phone", paymentlist!['ph']),
                        const SizedBox(height: 16),
                        Text(
                          "₹ ${paymentlist!['due']}",
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D3B66),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          onPressed: () {
                  openRazorpay(
                    "NO_ORDER", // or real orderId if generated from server
                    int.parse(paymentlist!['due']), // amount
                    paymentlist!['name'],           // name/description
                    paymentlist!['email'] ?? '',    // email
                    paymentlist!['ph'],             // contact
                  );
                },
                
                            child: const Text("PAY NOW",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget infoRow(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t, style: const TextStyle(color: Colors.grey)),
          Text(v,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        ],
      ),
    );
  }
}
