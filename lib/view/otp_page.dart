import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:totalx/controller/mobile_auth.dart';
import 'package:totalx/view/widget/auth_page.dart';

class OtpPage extends StatelessWidget {
  final phonenbr;
  final maskphonenbr;
  OtpPage({super.key, required this.maskphonenbr, this.phonenbr});
  final formKey1 = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Consumer<PhoneOtpAuth>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Gap(100),
                    Container(
                      child: Image.asset("assets/images/Group.png"),
                    ),
                    Gap(30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "OTP Verification",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          """Enter the verification code we just sent to your number +91$maskphonenbr."""),
                    ),
                    Form(
                      key: formKey1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 50,
                            child: TextFormField(
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              controller: _otpControllers[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.length == 1 && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    Gap(20),
                    Text(
                      "${provider.remainingTime} sec",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Gap(7),
                    TextButton(
                      onPressed: provider.remainingTime == 0
                          ? () {
                              provider.resendOtp(
                                phone: maskphonenbr,
                                errorStep: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Failed to resend OTP")),
                                  );
                                },
                                nextStep: () {
                                  provider.resendOtp(
                                      phone: phonenbr,
                                      errorStep: () =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                            "Error in sending otp ",
                                          ))),
                                      nextStep: () {
                                        Get.to(
                                            () => OtpPage(
                                                  maskphonenbr: maskphonenbr,
                                                ),
                                            transition: Transition.downToUp);
                                      });
                                },
                              );
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't Get OTP? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            "Resend",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ),
                    Gap(15),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.black),
                            fixedSize:
                                WidgetStateProperty.all(Size.fromWidth(300))),
                        onPressed: () {
                          if (formKey1.currentState!.validate()) {
                            String otp = _otpControllers
                                .map((controller) => controller.text)
                                .join();

                            provider.loginWithOtp(otp: otp).then((value) {
                              if (value == "Success") {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const AuthPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Invalid OTP")),
                                );
                              }
                            });
                          }
                        },
                        child: Text(
                          "Verify",
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
      },
    );
  }
}
