<?php
require_once 'config.php';

// Function to send JSON response
function sendResponse($status, $message) {
    header('Content-Type: application/json');
    $response = array('status' => $status, 'message' => $message);
    echo json_encode($response);
    exit;
}

// Check if the request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validate and sanitize inputs
    $payment_id = isset($_POST['payment_id']) ? $_POST['payment_id'] : '';
    $mem_id = isset($_POST['mem_id']) ? $_POST['mem_id'] : '';
    $amount = isset($_POST['amount']) ? $_POST['amount'] / 100 : 0; // Assuming amount is in cents
    $name = isset($_POST['name']) ? $_POST['name'] : '';
    $ph = isset($_POST['ph']) ? $_POST['ph'] : '';
    $email = isset($_POST['email']) ? $_POST['email'] : '';
    $status = isset($_POST['status']) ? $_POST['status'] : '';
    $order_id = isset($_POST['order_id']) ? $_POST['order_id'] : '';
   
    // Insert into database
    $insert_transaction = $link->prepare("INSERT INTO `all_transaction_tbl` (`payment_id`, `mem_id`, `amount`, `name`, `ph`, `email`, `status`, `order_id`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $insert_transaction->bind_param("ssdsssss", $payment_id, $mem_id, $amount, $name, $ph, $email, $status, $order_id);

    if ($insert_transaction->execute()) {
        if ($status === 'success') {
            // Update due status
            $update_due = $link->prepare("UPDATE `all_mem` SET `due` = '0' WHERE `mem_id` = ?");
            $update_due->bind_param("s", $mem_id);
            
            if ($update_due->execute()) {
                // Sending SMS
                $msg = "Your amount: ".$amount." is successfully paid. Your tracking id is: ".$payment_id.". Thank you for choosing CALCUTTA POLICE SERGEANT'S INSTITUTE payment system. REGARDS : GS CPSI";
                $encodedMsg = rawurlencode($msg);                  
                $url = 'http://sms.bulksmsind.in/v2/sendSMS?username=cpsgtinst&message='.$encodedMsg.'&sendername=CPSIGS&smstype=TRANS&numbers='.$ph.'&apikey=0cd08f73-def2-4072-8dc3-8fc10e1aeacd&peid=1701161605309086220&templateid=1707172085556522033';
                
                $ch = curl_init($url);
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($ch, CURLOPT_POST, 1);
                curl_setopt($ch, CURLOPT_POSTFIELDS, "");
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                $sms_response = curl_exec($ch);
                curl_close($ch);

                // Sending Email
                $to = "cpsi.subscription@gmail.com"; // Change to recipient's email address
                $subject = "Payment Status";
                $msg = "<table width='569' border='0' align='center' cellpadding='0' cellspacing='0' style='font-family:Arial, Helvetica, sans-serif; font-size:10pt; border:1px solid #ccc;'> ";
                $msg .= "<tr>";
                $msg .= "<td colspan='4'>-------------------------------------------------------------------------------------------------------------------------------<br> <center><b>-: Payment Status :-</b></center> <br>-------------------------------------------------------------------------------------------------------------------------------<br></td>";
                $msg .= "</tr>";
                $msg .= "<tr>";
                $msg .= "<td height='25'>&nbsp;</td>";
                $msg .= "<td height='25'>Full Name </td>";
                $msg .= "<td width='50' height='25'><strong>:</strong></td>";
                $msg .= "<td height='25'>$name</td>";
                $msg .= "</tr>";
                $msg .= "<tr>";
                $msg .= "<td height='25'>&nbsp;</td>";
                $msg .= "<td height='25'>Email ID </td>";
                $msg .= "<td width='50' height='25'><strong>:</strong></td>";
                $msg .= "<td height='25'>$email</td>";
                $msg .= "</tr>";
                $msg .= "<tr>";
                $msg .= "<td height='25'>&nbsp;</td>";
                $msg .= "<td height='25'>CONTACT NO.</td>";
                $msg .= "<td width='50' height='25'><strong>:</strong></td>";
                $msg .= "<td height='25'>$ph</td>";
                $msg .= "</tr>";
                $msg .= "<tr>";
                $msg .= "<td height='25'>&nbsp;</td>";
                $msg .= "<td height='25'>Amount</td>";
                $msg .= "<td width='50' height='25'><strong>:</strong></td>";
                $msg .= "<td height='25'>$amount</td>";
                $msg .= "</tr>";
                $msg .= "<tr>";
                $msg .= "<td height='25'>&nbsp;</td>";
                $msg .= "<td height='25'>Payment Ref.</td>";
                $msg .= "<td width='50' height='25'><strong>:</strong></td>";
                $msg .= "<td height='25'>$payment_id</td>";
                $msg .= "</tr>";
                $msg .= "</table>";

                $headers = "From: www.cpsgtinst.org\r\n";
                $headers .= "Content-Type: text/html; charset=UTF-8\r\n"; 

                // Send email
                if (mail($to, $subject, $msg, $headers)) {
                    sendResponse('success', 'Payment successful. Confirmation email sent.');
                } else {
                    sendResponse('error', 'Payment successful. Failed to send confirmation email.');
                }
            } else {
                sendResponse('error', 'Failed to update due status.');
            }
        } else {
            sendResponse('error', 'Payment status is not success.');
        }
    } else {
        sendResponse('error', 'Failed to insert transaction details.');
    }

    // Close prepared statements and database connection
    $insert_transaction->close();
    $update_due->close();
    $link->close();
} else {
    sendResponse('error', 'Invalid request method.');
}
?>
