import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:file_picker/file_picker.dart';

class webachivementpage extends StatefulWidget {


  const webachivementpage({
    super.key,
 
  });

  @override
  State<webachivementpage> createState() => _webachivementpageState();
}

class _webachivementpageState extends State<webachivementpage> {
  InAppWebViewController? webController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
         const Color(0xFFe9e4de),

   appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B66),
        title: const Text("Achievements",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      
      ),

         
          
        
      

      body: InAppWebView(
  initialUrlRequest: 
  URLRequest(url: WebUri("https://cpsgtinst.org/appachivement.php")),
  onLoadStop: (controller, url) async {
  await controller.evaluateJavascript(source: """
    document.querySelectorAll("input[type=file]").forEach(inp => {
      inp.addEventListener("click", async (e) => {
        e.preventDefault();

        // Call Flutter handler
        const fileInfo = await window.flutter_inappwebview.callHandler("pickFile");

        if (!fileInfo) {
          console.log("NO FILE SELECTED");
          return;
        }

        // Convert Base64 to Blob
        function base64ToBlob(base64, type) {
          const byteCharacters = atob(base64);
          const byteNumbers = new Array(byteCharacters.length);
          for (let i = 0; i < byteCharacters.length; i++) {
            byteNumbers[i] = byteCharacters.charCodeAt(i);
          }
          const byteArray = new Uint8Array(byteNumbers);
          return new Blob([byteArray], { type });
        }

        const blob = base64ToBlob(fileInfo.data, "image/" + fileInfo.type);
        const file = new File([blob], fileInfo.name, { type: "image/" + fileInfo.type });

        // Create DataTransfer to set file input
        const dt = new DataTransfer();
        dt.items.add(file);

        inp.files = dt.files;

        console.log("FILE INSERTED SUCCESSFULLY!");
      });
    });
  """);
},

  onConsoleMessage: (_, msg) => print(msg),
  onWebViewCreated: (controller) {
    controller.addJavaScriptHandler(
      handlerName: "pickFile",
      callback: (args) async {
          print("FILE PICK STARTED");
      final result = await FilePicker.platform.pickFiles();

if (result != null && result.files.isNotEmpty) {
  final file = result.files.single;

  final bytes = await File(file.path!).readAsBytes();
  final base64File = base64Encode(bytes);

  print("FILE BASE64 READY, SIZE = ${bytes.length}");

  return {
    "name": file.name,
    "data": base64File,
    "type": file.extension ?? "jpg"
  };
}
return null;

      }
    );
  }
)
      


    );
  }
}
