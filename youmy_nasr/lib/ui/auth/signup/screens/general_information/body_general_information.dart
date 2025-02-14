
import 'package:flutter/material.dart';
import 'package:get/get.dart'  ;
import 'package:merchant/components/custom_text.dart';
import 'package:merchant/ui/auth/signup/controller/signup_controller.dart';
import 'package:merchant/ui/auth/signup/screens/general_information/general_information_form.dart';
import '../../../../../components/socal_card.dart';
import '../../../../../services/translation_key.dart';
import '../../../../../util/Constants.dart';
import '../../../../../util/size_config.dart';
import '../../../login/controller/login_controller.dart';

class BodyPersonalInformation extends StatelessWidget {
  const BodyPersonalInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
        init: SignupController(context),
        builder: (SignupController controller) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      CustomText(
                        text: personalInformation.tr,   // Correct usage of .tr() with parentheses
                        align: Alignment.center,
                        fontColor: KPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),

                      SizedBox(height: SizeConfig.screenHeight * 0.01),
                      const SignUpFormGeneralInformation(),
                      SizedBox(height: SizeConfig.screenHeight * 0.08),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocalCard(
                            icon: "assets/images/google.png",
                            press: () {},
                          ),
                          SocalCard(
                            icon: "assets/icons/facebook-2.svg",
                            press: () {},
                          ),
                          SocalCard(
                            icon: "assets/icons/twitter.svg",
                            press: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
