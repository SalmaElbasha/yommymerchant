import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merchant/components/custom_chip.dart';
import 'package:merchant/components/custom_text.dart';
import 'package:merchant/data/model/courier.dart';
import 'package:merchant/services/translation_key.dart';
import 'package:merchant/ui/home/components/orders/components/orders_data.dart';
import 'package:merchant/util/Constants.dart';
import '../../../../../components/action_button.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_text_form_field.dart';
import '../../../../../components/expandable_fab.dart';
import '../../../../../services/localization_services.dart';
import '../../../../../services/memory.dart';
import '../../../../../util/size_config.dart';
import '../controller/orders_controller.dart';
import '../search/search_screen.dart';

Courier? selectedCourier;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isGridView = true;



  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: OrdersController(),
        builder: (OrdersController controller) {
          return Scaffold(
      appBar: AppBar(
        leading: null,
        title:  CustomText(
          text: ordersTitle.tr,
          align: Alignment.center,
          fontColor: KPrimaryColor,
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return Get.find<CacheHelper>()
                  .activeLocale == SupportedLocales.english?  {'A to Z', 'Oldest to New'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                  onTap: () {
                   if(choice=="'A to Z")
                   {
                     controller.sortOrders();
                   }else
                   {
                     controller.sortOrdersOldestToNewest();
                   }
                  },
                );
              }).toList():{'من الألف إلى الياء', 'الأقدم إلى الأحدث'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                  onTap: () {
                    if(choice=="من الألف إلى الياء")
                    {
                      controller.sortOrders();
                    }else
                    {
                      controller.sortOrdersOldestToNewest();
                    }
                  },
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   children: [
              //     ...List.generate(
              //         cities.length,
              //         (index) => index < 3
              //             ? CustomChip(
              //                 type: 2,
              //                 label: cities[index],
              //                 onSelected: () {},
              //                 onPressed: () {},
              //               )
              //             : CustomText(
              //                 text: 'Show All',
              //           fontColor: KPrimaryColor,
              //               )),
              //
              //   ],
              // ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
                child: SizedBox(
                  height: getProportionateScreenHeight(50),
                  child: controller.isLoading.value?CircularProgressIndicator():
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.branchess.length,
                      itemBuilder: (BuildContext context, int index) =>  CustomChip(
                              type: 2,
                              label: controller.branchess[index],
                              onPressed: () {},
                            )
                          ),
                ),
              ),

              const OrdersData(),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              // showFilterScreen(context); // add
            },
            icon: const Icon(
              Icons.sort,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () =>
                Navigator.pushNamed(context, OrderSearchScreen.routeName),
            // search
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );});
  }

  void showFilterScreen(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      )),
      context: context,
      builder: (BuildContext context) {
        return const BottomSheetBody();
      },
    );
  }
}

class BottomSheetBody extends StatefulWidget {
  const BottomSheetBody({Key? key}) : super(key: key);

  @override
  State<BottomSheetBody> createState() => _BottomSheetBodyState();
}

class _BottomSheetBodyState extends State<BottomSheetBody> {
  bool onRevision = false,
      onPrepare = false,
      onWay = false,
      onDelivered = false,
      nonDelivered = false,
      cancelled = false;

  String? name, type, summary, address, workingHours, paymentTypes;
  final List<String?> errors = [];
  String _birthDateInString = 'Birth Date';
  DateTime? _birthDate;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        getProportionateScreenWidth(20),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: getProportionateScreenWidth(5),
              ),
              const CustomText(
                text: 'Branches',
                align: Alignment.center,
                fontColor: KPrimaryColor,
                fontSize: 23,
              ),
              SizedBox(height: getProportionateScreenWidth(0)),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: ["Maadi", "Helwan", "Tahrir", "All"]
                    .map((String name) => GestureDetector(
                          child: Chip(
                            avatar: CircleAvatar(
                              child: Text(name.substring(0, 1)),
                            ),
                            label: Text(
                              name,
                            ),
                          ),
                          onTap: () {
                            _showToast("$name is Pressed");
                          },
                        ))
                    .toList(),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              const CustomText(
                text: 'Status',
                align: Alignment.topLeft,
                fontColor: KPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Row(
                children: [
                  Row(children: [
                    Checkbox(
                      value: onRevision,
                      activeColor: KPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          onRevision = value!;
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          //go to terms screen
                        },
                        child: const CustomText(text: 'On Revision ')),
                  ]),
                  Row(children: [
                    Checkbox(
                      value: onPrepare,
                      activeColor: KPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          onPrepare = value!;
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          //go to terms screen
                        },
                        child: const CustomText(text: 'On Prepare ')),
                  ]),
                ],
              ),
              Row(
                children: [
                  Row(children: [
                    Checkbox(
                      value: onWay,
                      activeColor: KPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          onWay = value!;
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          //go to terms screen
                        },
                        child: const CustomText(text: 'On Way ')),
                  ]),
                  Row(children: [
                    Checkbox(
                      value: onDelivered,
                      activeColor: KPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          onDelivered = value!;
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          //go to terms screen
                        },
                        child: const CustomText(text: 'On Delivered ')),
                  ]),
                ],
              ),
              Row(children: [
                Checkbox(
                  value: nonDelivered,
                  activeColor: KPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      nonDelivered = value!;
                    });
                  },
                ),
                GestureDetector(
                    onTap: () {
                      //go to terms screen
                    },
                    child: const CustomText(text: 'Non Delivered ')),
              ]),
              Row(children: [
                Checkbox(
                  value: cancelled,
                  activeColor: KPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      cancelled = value!;
                    });
                  },
                ),
                GestureDetector(
                    onTap: () {
                      //go to terms screen
                    },
                    child: const CustomText(text: 'Cancelled ')),
              ]),
              SizedBox(height: getProportionateScreenHeight(10)),
              const CustomText(
                text: 'Within Range',
                align: Alignment.topLeft,
                fontColor: KPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildFilterByCourierField(),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildBirthDateField('From'),
              SizedBox(height: getProportionateScreenHeight(10)),
              buildBirthDateField('To'),
              SizedBox(height: getProportionateScreenHeight(30)),
              CustomButton(
                text: "Confirm",
                press: () {
                  // if (_formKey.currentState!.validate()) {
                  //   _formKey.currentState!.save();

                  Navigator.pop(context);
                  // }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBirthDateField(String hintText) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        CustomTextFormField(
          readOnly: true,
          suffixIcon: const Icon(Icons.calendar_today),
          textInputType: TextInputType.text,
          hintText: hintText,
          onPressed: () {},
          onValidate: (value) {
            if (value!.isEmpty) {
              addError(error: kNameNullError);
              return "";
            } else if (value.toString().isEmpty) {
              addError(error: kNameNullError);
              return "";
            }
            return null;
          },
          onChange: (value) {
            if (value.isNotEmpty) {
              removeError(error: kNameNullError);
            }
            return null;
          },
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Color(0xfff96800)),
          onPressed: () async {
            final datePick = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));
            if (datePick != null && datePick != _birthDate) {
              setState(() {
                _birthDate = datePick;
                // isDateSelected=true;
                print('MAIN- $_birthDateInString');
                // put it here
                _birthDateInString =
                    "${_birthDate?.month}/${_birthDate?.day}/${_birthDate?.year}"; // 08/14/2019
              });
            }

            // Your codes...
          },
        ),
      ],
    );
  }

  DropdownButton<Courier> buildFilterByCourierField() {
    return DropdownButton(
      hint: const CustomText(
        text: 'Choose Courier',
      ),
      iconSize: 40,
      isExpanded: true,
      value: selectedCourier,
      items: demoCouriers.map((courier) {
        return DropdownMenuItem<Courier>(
          child: Text(courier.name??""),
          value: courier,
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCourier = value;
        });
      },
    );
  }

  Widget buildFilterByCourierField1(String hintText) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        CustomTextFormField(
          readOnly: true,
          suffixIcon:
              const Icon(Icons.arrow_drop_down_circle_outlined, size: 30),
          textInputType: TextInputType.text,
          hintText: hintText,
          onPressed: () {},
          onValidate: (value) {
            if (value!.isEmpty) {
              addError(error: kNameNullError);
              return "";
            } else if (value.toString().isEmpty) {
              addError(error: kNameNullError);
              return "";
            }
            return null;
          },
          onChange: (value) {
            if (value.isNotEmpty) {
              removeError(error: kNameNullError);
            }
            return null;
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_drop_down_circle_outlined,
            color: Color(0xfff96800),
            size: 30,
          ),
          onPressed: () async {
            final datePick = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));
            if (datePick != null && datePick != _birthDate) {
              setState(() {
                _birthDate = datePick;
                // isDateSelected=true;
                print('MAIN- $_birthDateInString');
                // put it here
                _birthDateInString =
                    "${_birthDate?.month}/${_birthDate?.day}/${_birthDate?.year}"; // 08/14/2019
              });
            }

            // Your codes...
          },
        ),
      ],
    );
  }
}

void _showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: KPrimaryColor,
      fontSize: 16.0);
}

void handleClick(String value) {
  switch (value) {
    case 'A to Z':
      break;
    case 'Oldest to New':
      break;
    case 'Grid View':
      break;
  }
}
List<Courier> demoCouriers = [
  Courier(
    id: 1,
    name: "Ahmed Sayed ",
    mobile: "011156879542",
  ),
  Courier(id: 2, name: "Tamer Anwar", mobile: "012587542123", isActive: false),
  Courier(
    id: 3,
    name: "Akram Mohamed",
    mobile: "010857445327",
  ),
  Courier(
    id: 3,
    name: "Akram Mohamed",
    mobile: "010857445327",
  ),
  Courier(
    id: 3,
    name: "Akram Mohamed",
    mobile: "010857445327",
  ),
  Courier(
      id: 4, name: "Ashraf Mohamed", mobile: "012365478952", isActive: false),







];