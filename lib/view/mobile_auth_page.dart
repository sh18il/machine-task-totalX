import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:totalx/controller/mobile_auth.dart';
import 'package:totalx/view/otp_page.dart';
import 'package:totalx/view/widget/auth_page.dart';

class MobileAuthPage extends StatelessWidget {
  MobileAuthPage({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController phoneCtrl = TextEditingController();
    final provider = Provider.of<PhoneOtpAuth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Gap(100),
                Center(
                  child: Container(
                    child:
                        Image(image: AssetImage("assets/images/OBJECTS.png")),
                  ),
                ),
                Gap(30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Enter Phone Number",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Gap(10),
                          TextFormField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.length != 10)
                                return "invalid phone number";
                              return null;
                            },
                            decoration: InputDecoration(
                                prefix: Text("+91"),
                                hintText: "Enter Phone Number",
                                border: OutlineInputBorder()),
                          ),
                          Gap(10),
                          Text(
                              """By Continuing, I agree to TotalX’s Terms and condition & privacy policy""")
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(20),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                        fixedSize: WidgetStatePropertyAll(Size.fromWidth(300))),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        provider.sentOtp(
                            phone: phoneCtrl.text,
                            errorStep: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "Error in sending otp ",
                                ))),
                            nextStep: () {
                              Get.to(() => OtpPage(),
                                  transition: Transition.downToUp);
                            });
                      }
                    },
                    child: Text(
                      "Get OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
