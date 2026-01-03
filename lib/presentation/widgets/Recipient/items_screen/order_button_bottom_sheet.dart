import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/Recipient/request_screen_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';

class OrderRequestBottomSheet extends StatefulWidget {
  final String itemId;

  const OrderRequestBottomSheet({super.key, required this.itemId});

  @override
  State<OrderRequestBottomSheet> createState() =>
      _OrderRequestBottomSheetState();
}

class _OrderRequestBottomSheetState extends State<OrderRequestBottomSheet> {
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();
  final requestService = RequestServices();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors().primaryColor;

    return SingleChildScrollView(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 25,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ▬▬▬▬ السحب ▬▬▬▬
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ▬▬▬▬ عنوان + أيقونة ▬▬▬▬
              Row(
                children: [
                  Icon(
                    Icons.volunteer_activism_outlined,
                    size: 26,
                    color: primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "اطلب هذا العنصر",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ▬▬▬▬ رفع الصورة ▬▬▬▬
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera_outlined,
                              size: 40,
                              color: primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "تحميل صورة (اختياري)",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // ▬▬▬▬ سبب الطلب ▬▬▬▬
              Text(
                "سبب الطلب",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              Form(
                key: _formKey,
                child: TextFormField(
                  cursorColor: Colors.black,
                  validator: validated,
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(162, 224, 224, 224),
                    hintText: "اكتب لماذا تريد هذا العنصر...",
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ▬▬▬▬ زر إرسال ▬▬▬▬
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final reason = reasonController.text.trim();

                  final success = await requestService.sendRequest(
                    itemId: widget.itemId,
                    reason: reason,
                    attachment: selectedImage,
                  );

                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Request sent successfully!"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to send request")),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "إرسال الطلب",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
