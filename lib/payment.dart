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
  //List<dynamic> paymentlist = [];
  Map<String, dynamic>? paymentlist;
  late Razorpay _razorpay;

  Future<void> fetchamount(String phone) async {
    final uri = Uri.parse('https://cpsgtinst.org/app/due.php?ph=$phone');
    try {
      final responce = await http.get(uri);

      if (responce.statusCode == 200) {
        final data = jsonDecode(responce.body);
        setState(() {
          paymentlist = data['stock'][0];
        });
        print('Amount fetched successfully');
      } else {
        print('Failed to fetch amount with status: ${responce.statusCode}');
      }
    } catch (e) {
      print('Error fetching amount: $e');
    }
  }

  void openRazorpay(int amount, String name) {
    var options = {
      'key': 'rzp_live_JlDOXuPCT5TpID', // 🔴 Your Razorpay Key
      'amount': amount * 100, // rupees → paise
      'name': 'CPSI Payment',
      'description': name,
      'prefill': {'contact': widget.phone},
    };

    _razorpay.open(options);
  }

  // 🔹 PAYMENT SUCCESS
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Payment Successful")));

    // 🔹 UPDATE SERVER
    updatePaymentStatus(
      response.paymentId!,
      response.orderId,
      response.signature,
      "success",
    );
  }

  // 🔹 PAYMENT FAILED
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Payment Failed")));

    updatePaymentStatus(null, null, null, "failed");
  }

  // 🔹 UPDATE SERVER API
  Future<void> updatePaymentStatus(
    String? paymentId,
    String? orderId,
    String? signature,
    String status,
  ) async {
    final uri = Uri.parse('https://cpsgtinst.org/app/update_payment.php');

    await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': widget.phone,
        'payment_id': paymentId,
        'order_id': orderId,
        'signature': signature,
        'status': status,
      }),
    );

    fetchamount(widget.phone); // refresh list
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchamount(widget.phone);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Payment Details",style: TextStyle(
        color: Colors.white
      ),),centerTitle: true,
      backgroundColor: const Color(0xFF0D3B66),
    ),
    body: paymentlist == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 HEADER
                    Row(
                      children: const [
                        Icon(Icons.receipt_long,
                            color: Color(0xFF0D3B66)),
                        SizedBox(width: 8),
                        Text(
                          "Payment Summary",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),

                    const Divider(height: 30),

                    // 🔹 DETAILS
                    _infoRow("Name", paymentlist!['name']),
                    _infoRow("Member ID", paymentlist!['mem_id']),
                    _infoRow("Phone", paymentlist!['ph']),

                    const SizedBox(height: 16),

                    // 🔹 DUE AMOUNT
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Due Amount",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "₹ ${paymentlist!['due']}",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 🔹 PAY BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D3B66),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(Icons.payments_outlined),
                        label: const Text(
                          "PAY NOW",
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 16,
                            color: Colors.white
                          ),
                        ),
                        onPressed: () {
                          openRazorpay(
                            int.parse(paymentlist!['due']),
                            paymentlist!['name'],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
  );
}
Widget _infoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

}
