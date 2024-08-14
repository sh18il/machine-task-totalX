import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:totalx/controller/mobile_auth.dart';
import 'package:totalx/view/widget/auth_page.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});
  final formKey1 = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhoneOtpAuth>(context, listen: false);

    return Scaffold(
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
                    Text("OTP Verification"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    """Enter the verification code we just sent to your number +91 *******21."""),
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
                            color: Colors.red, fontWeight: FontWeight.bold),
                        controller: _otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "", // Hide the character counter
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
                            // Move focus to the next field
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            // Move focus to the previous field if backspace is pressed
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              Gap(20),
              Text("56 s"),
              Gap(7),
              Text("Don't Get OTP? Resend"),
              Gap(15),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      fixedSize: WidgetStatePropertyAll(Size.fromWidth(300))),
                  onPressed: () {
                    if (formKey1.currentState!.validate()) {
                      // Concatenate the values from each TextFormField to form the full OTP
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
    );
  }
}
