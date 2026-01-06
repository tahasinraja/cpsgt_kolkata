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
Future<String> createOrder(int amount) async {
  final uri = Uri.parse('https://api.razorpay.com/v1/orders');

  // Basic Auth (Test mode)
  String key = 'rzp_live_JlDOXuPCT5TpID';
  String secret = 'i7tKY7Xtz8JngaV1k2eLj7U9';
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

  final res = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
      'Content-Type': 'application/json'
    },
    body: jsonEncode({
      'amount': amount * 100, // paise me
      'currency': 'INR',
      'receipt': 'rcpt_${DateTime.now().millisecondsSinceEpoch}'
    }),
  );

  if (res.statusCode == 200 || res.statusCode == 201) {
    final data = jsonDecode(res.body);
    print("✅ Order created: $data");
    return data['id']; // order_id
  } else {
    print("❌ Order creation failed: ${res.body}");
    throw Exception("Order creation failed");
  }
}


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
print("📝 User: ${paymentlist!['name']}, Phone: ${widget.phone}, mem_id:${paymentlist!['mem_id']}");

    }
  }

  // ================= OPEN RAZORPAY =================

 // var orderId = "ORD_${DateTime.now().millisecondsSinceEpoch}";
void openRazorpay(
  String orderId,
  int amount,
  String name,
  String email,
  String contact,
) {
  var options = {
    'key': 'rzp_live_JlDOXuPCT5TpID',
    'amount': amount * 100,
    'currency': 'INR',
    'name': 'Calcutta Police Sergeant\'s Institute',
    'description': 'Membership Fee',
    'order_id': orderId,
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
    response.paymentId!,
    response.orderId!,
    response.signature!,
    "success",
    
  );
    print("✅ PaymentId: ${response.paymentId}");
  print("✅ OrderId: ${response.orderId}");
  print("✅ Signature: ${response.signature}");

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

  // Form fields (not JSON)
  final body = {
    'payment_id': paymentId ?? '',
    'order_id': orderId ?? '',
    'signature': signature ?? '',
    'mem_id': paymentlist!['mem_id'],
    'amount': paymentlist!['due'],
    'name': paymentlist!['name'],
    'ph': paymentlist!['ph'],
    'email': paymentlist!['email'] ?? '',
    'status': status, // must be "success"
  };

  final res = await http.post(
    uri,
    body: body, // ✅ plain form POST
  );

  print("⬅️ SERVER: ${res.body}");
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
        iconTheme: IconThemeData(color: Colors.white),
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
                        Chip(label: Column(
children: [
     const Text(
                  "Payment Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
],
                        )),
                        SizedBox(height: 20,),
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
 onPressed: () async {
  try {
    int amount = int.parse(paymentlist!['due']);
    String orderId = await createOrder(amount);

    openRazorpay(
      orderId,
      amount,
      paymentlist!['name'],
      paymentlist!['email'] ?? '',
      paymentlist!['ph'],
    );
  } catch (e) {
    print("Error creating order: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order creation failed")),
    );
  }
},


                
                            child: const Text("PAY NOW",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ),
                          const SizedBox(height: 12),
                  Text(
                    "Secure payment via Razorpay",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
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
