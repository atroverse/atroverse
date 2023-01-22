import 'dart:io';

import 'package:atroverse/Controllers/CommentController.dart';
import 'package:atroverse/Controllers/LoginController.dart';
import 'package:atroverse/Helpers/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lottie/lottie.dart';

import 'package:intl/intl.dart' as intl;
import 'date_formatter.dart';

class WidgetHelper {
  static textField({
    String title = '',
    IconData? icon,
    TextEditingController? controller,
    TextAlign textAlign = TextAlign.center,
    TextInputType keyboardType = TextInputType.text,
    void Function(String string)? onChanged,
    FocusNode? focusNode,
    List<TextInputFormatter> formatter = const [],
    double letterSpacing = 1.9,
    bool enabled = true,
    bool? valid,
    int maxLines = 1,
    bool price = false,
    bool percent = false,
    Color? backgroundColor,
    double heightFactor = 21,
    Color? borderColor,
    bool password = false,
    bool suffix = true,
  }) {
    return Container(
      height: maxLines == 0
          ? Get.height / heightFactor
          : Get.height / (heightFactor / maxLines),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: backgroundColor,
      ),
      child: TextFormField(
        textAlign: textAlign,
        keyboardType: price ? TextInputType.number : keyboardType,
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        focusNode: focusNode,
        cursorColor: ColorUtils.kShadowColor,
        obscureText: password,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
          color: ColorUtils.kBodyTextColorDark,
          letterSpacing: letterSpacing,
          fontSize: !suffix ? 12.0 : 14.0,
        ),
        inputFormatters: [
          if (percent) LengthLimitingTextInputFormatter(3),
          if (percent || price) FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (String str) {
          if (price) {
            double value = double.parse(str.replaceAll(',', '').trim());
            controller!.selection = TextSelection.fromPosition(
              TextPosition(
                offset: controller.text.length,
              ),
            );
          }
          if (percent) {
            double value;
            try {
              value = double.parse(str);
            } catch (e) {
              value = 0;
            }
            if (value > 100) {
              controller!.text = '100';
              controller.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: controller.text.length,
                ),
              );
            }
          }
          if (onChanged != null) onChanged(str);
        },
        decoration: InputDecoration(
          hintText: title,
          // suffixIcon: suffix
          //     ? Icon(
          //   Ionicons.search_outline,
          //   size: 20.0,
          //   color: ColorUtils.black.withOpacity(0.3),
          // )
          //     : null,
          // prefixIcon: !suffix
          //     ? Icon(
          //   Ionicons.search_outline,
          //   size: 15.0,
          //   color: ColorUtils.black.withOpacity(0.3),
          // )
          //     : null,
          hintStyle: TextStyle(
            color: ColorUtils.kBodyTextColorDark.withOpacity(0.3),
            fontSize: !suffix ? 10.0 : 112.0,
          ),
          hintMaxLines: 1,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: ColorUtils.kShadowColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(Get.context!).shadowColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(Get.context!).shadowColor),
          ),
        ),
      ),
    );
  }

  static Widget textField2({
    String? text,
    TextEditingController? controller,
    int? maxLine,
    double? fontSize,
    FormFieldValidator<String>? function,
    ValueChanged<String>? onChange,
    ValueChanged<String>? submit,
    Size? size,
    FormFieldValidator<String>? validator,
    GlobalKey? formKey,
    int? maxLength,
    required bool obscureText,
    TextInputType? keyBoardType,
    String? errorText,
    String? hintText,
    bool? enabled,
    Widget? icon,
    Color? color,
    required String title,
    bool autoValidate = false,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        textDirection: TextDirection.rtl,
        autovalidateMode: autoValidate
            ? AutovalidateMode.always
            : AutovalidateMode.onUserInteraction,
        onChanged: (String str) {},
        validator: validator,
        controller: controller,
        cursorColor: ColorUtils.kShadowColor,
        cursorHeight: Get.height * .02,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(Get.context!).textTheme.bodyText1,
        maxLines: 1,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: submit,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.white, fontSize: 14),
          hintMaxLines: 1,
          labelText: title,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: ColorUtils.kShadowColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(Get.context!).shadowColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(Get.context!).shadowColor),
          ),
        ),
      ),
    );
  }

  static checkProfileDialog({
    Function? func,
  }) =>
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 50.0,
            content: Container(
              height: Get.height * .3,
              width: Get.width,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Lottie.asset("assets/anims/edit_profile.json",
                        repeat: false, width: Get.width * .3),
                  ),
                  SizedBox(
                    height: Get.height * .01,
                  ),
                  const AutoSizeText(
                    "برای استفاده از این بخش باید پروفایل خود را تکمیل کنید!!!",
                    maxLines: 1,
                    maxFontSize: 22,
                    minFontSize: 10,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(
                    height: Get.height * .015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            func!();
                          },
                          child: Container(
                            height: Get.height * .05,
                            width: Get.width * .4,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: AutoSizeText(
                                "تکیمل پروفایل",
                                maxLines: 1,
                                maxFontSize: 22,
                                minFontSize: 10,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Get.close(0);
                      //     },
                      //     child: Container(
                      //       height: Get.height * .05,
                      //       width: Get.width * .35,
                      //       decoration: BoxDecoration(
                      //         color: Colors.red,
                      //         borderRadius: BorderRadius.circular(15),
                      //         boxShadow: const [
                      //           BoxShadow(
                      //             color: Colors.black12,
                      //             blurRadius: 5,
                      //             spreadRadius: 2,
                      //           ),
                      //         ],
                      //       ),
                      //       child: const Center(
                      //         child: AutoSizeText(
                      //           "بعدا",
                      //           maxLines: 1,
                      //           maxFontSize: 22,
                      //           minFontSize: 10,
                      //           textAlign: TextAlign.center,
                      //           style:
                      //           TextStyle(color: Colors.white, fontSize: 14),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );

  static Widget input({
    required String title,
    Widget? icon,
    String? initialValue,
    String? hint,
    FocusNode? focusNode,
    required ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validate,
    GestureTapCallback? onTap,
    TextEditingController? controller,
    TextInputAction? textInputAction,
    int? maxLength,
    int? maxLine = 1,
    int? minLine = 1,
    List<TextInputFormatter>? inputFormatters,
    bool show = false,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
      child: TextFormField(
        onChanged: (value){
          Get.appUpdate();
          onChanged!(value);
        },
        onTap: onTap,
        textDirection: intl.Bidi.detectRtlDirectionality(controller!.text) ? TextDirection.rtl : TextDirection.ltr,
        obscureText: false,
        focusNode: focusNode,
        validator: validate,
        controller: controller,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: ColorUtils.kShadowColor,
        cursorHeight: Get.height * .03,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        maxLines: maxLine,
        minLines: minLine,
        initialValue: initialValue,
        maxLength: maxLength,
        keyboardType: type,
        scrollPadding: MediaQuery.of(Get.context!).viewInsets,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          counterText: "",
          hintText: hint,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
          prefixIconColor: ColorUtils.kShadowColor,
          labelText: title,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  static Widget dateInput({
    required String title,
    required String hint,
    Widget? icon,
    String? initialValue,
    required ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validate,
    GestureTapCallback? onTap,
    TextEditingController? controller,
    int? maxLength,
    int? maxLine = 1,
    int? minLine = 1,
    TextInputType type = TextInputType.number,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
        child: TextFormField(
          // textDirection: TextDirection.rtl,
          onChanged: onChanged,
          onTap: onTap,
          validator: validate,
          controller: controller,
          minLines: minLine,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: ColorUtils.kShadowColor,
          cursorHeight: Get.height * .03,
          textDirection: TextDirection.ltr,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          maxLines: maxLine,
          textInputAction: TextInputAction.next,
          initialValue: initialValue,
          textAlign: TextAlign.left,
          maxLength: maxLength,
          keyboardType: type,
          scrollPadding: MediaQuery.of(Get.context!).viewInsets,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            CustomDateTextFormatter(),
          ],
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black, fontSize: 14),
            alignLabelWithHint: true,
            counterText: "",
            labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
            suffixIcon: icon,
            prefixIconColor: ColorUtils.kShadowColor,
            labelText: title,
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            //   borderSide: const BorderSide(color: Colors.red),
            // ),
            // focusedErrorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            //   borderSide: const BorderSide(color: Colors.red),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            //   borderSide: const BorderSide(color: Colors.black),
            // ),
            // disabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            // ),
          ),
        ),
      ),
    );
  }

  static Widget dateInputNoBorder({
    required String title,
    required String hint,
    Widget? icon,
    String? initialValue,
    required ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validate,
    GestureTapCallback? onTap,
    TextEditingController? controller,
    int? maxLength,
    int? maxLine = 1,
    int? minLine = 1,
    TextInputAction? textInputAction,
    TextInputType type = TextInputType.number,
    bool isUnderLine = false,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
        child: TextFormField(
          // textDirection: TextDirection.rtl,
          onChanged: onChanged,
          onTap: onTap,
          validator: validate,
          controller: controller,
          minLines: minLine,
          textInputAction: textInputAction,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: ColorUtils.kShadowColor,
          cursorHeight: Get.height * .03,
          textDirection: TextDirection.ltr,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          maxLines: maxLine,
          initialValue: initialValue,
          textAlign: TextAlign.left,
          maxLength: maxLength,
          keyboardType: type,
          scrollPadding: MediaQuery.of(Get.context!).viewInsets,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            alignLabelWithHint: true,
            counterText: "",
            hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
            labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
            suffixIcon: icon,
            prefixIconColor: ColorUtils.kShadowColor,
            labelText: title,
            border: isUnderLine
                ? const UnderlineInputBorder(borderSide: BorderSide.none)
                : const UnderlineInputBorder(borderSide: BorderSide()),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            //   borderSide: const BorderSide(color: Colors.red),
            // ),
            // focusedErrorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            //   borderSide: const BorderSide(color: Colors.red),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            //   borderSide: const BorderSide(color: Colors.black),
            // ),
            // disabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.0),
            // ),
          ),
        ),
      ),
    );
  }

  static Widget inputComment({
    required String title,
    Widget? icon,
    Widget? icon2,
    required ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validate,
    GestureTapCallback? onTap,
    TextEditingController? controller,
    int? maxLength,
    int? maxLine = 1,
    TextInputType type = TextInputType.number,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        // textDirection: TextDirection.rtl,
        onChanged: onChanged,
        onTap: onTap,
        validator: validate,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: ColorUtils.kShadowColor,
        cursorHeight: Get.height * .03,
        focusNode: Get.find<CommentController>().focusNode,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        maxLines: maxLine,
        // textAlign: TextAlign.end,
        maxLength: maxLength,
        keyboardType: type,
        decoration: InputDecoration(
            prefixIcon: icon2,
            prefixIconConstraints: BoxConstraints(minHeight: Get.width * .08),
            isDense: true,
            alignLabelWithHint: true,
            counterText: "",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            suffixIcon: icon,
            prefixIconColor: ColorUtils.kShadowColor,
            hintText: title,
            border: InputBorder.none),
      ),
    );
  }

  static btnContainer({
    void Function()? onTap,
    double widthFactor = 5,
    String title = 'ارسال',
    bool enabled = true,
    double fontSize = 10.0,
    IconData? icon,
    bool reverse = true,
  }) {
    return Container(
      height: Get.height * .058,
      width: Get.width * .8,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(right: Get.width * .03),
      child: TextButton(
        onPressed: onTap,
        child: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 18),
            maxFontSize: 20,
            minFontSize: 1,
            maxLines: 1,
            // style: TextStyle(
            //     color: SettingController.isDarkMode.isTrue
            //         ? Colors.black
            //         : Colors.white,
            //     fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  static softButton({
    void Function()? onTap,
    String? title,
    Color? color,
  }) {
    color ??= Color(0xff0265e1);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
      child: SizedBox(
        height: Get.height * .05,
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => color!),
              overlayColor:
                  MaterialStateColor.resolveWith((states) => Colors.white12)),
          child: Center(
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  static void onChange(
      String string, TextEditingController textEditingController) {
    if (textEditingController.text.length == 11) {}
    List<String> list = string.split('');
    if (list.length > 0) {
      switch (list.length) {
        case 1:
          if (list[0] == '0') {
            textEditingController.text = '0';
          } else {
            textEditingController.clear();
          }
          break;
        case 2:
          if (list[1] == '9') {
            textEditingController.text = '09';
          } else {
            textEditingController.text = '0';
          }

          break;
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
          list.removeAt(0);
          list.removeAt(0);
          textEditingController.text = '09' + list.join('');
          break;
      }
      Future.delayed(
        Duration.zero,
        () => textEditingController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: textEditingController.text.length,
          ),
        ),
      );
    }
  }

  // static buildBtn({Callback? func, String? text}) {
  //   return Container(
  //     height: Get.height * .055,
  //     width: Get.width * .8,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.3),
  //           spreadRadius: 2,
  //           blurRadius: 12,
  //         ),
  //       ],
  //       border: Border.all(color: ColorsHelper.mainColor),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(10),
  //       child: TextButton(
  //         style: ButtonStyle(
  //           overlayColor: MaterialStateColor.resolveWith(
  //                   (states) => ColorsHelper.mainColor.withOpacity(0.2)),
  //         ),
  //         onPressed: func,
  //         child: Text(
  //           text!,
  //           style: const TextStyle(color: Colors.black, fontSize: 18),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static validateNationalCode(String nc) {
    if (nc.trim() == '') {
      return false;
    } else if (nc.length != 10) {
      return false;
    } else {
      int sum = 0;

      for (int i = 0; i < 9; i++) {
        sum += int.parse(nc[i]) * (10 - i);
      }

      int lastDigit;
      int divideRemaining = sum % 11;

      if (divideRemaining < 2) {
        lastDigit = divideRemaining;
      } else {
        lastDigit = 11 - (divideRemaining);
      }

      if (int.parse(nc[9]) == lastDigit) {
        return true;
      } else {
        return false;
      }
    }
  }
}

class InputPassword extends StatelessWidget {
  InputPassword({
    Key? key,
    required this.title,
    this.icon,
    this.initialValue,
    this.onChanged,
    this.validate,
    this.onTap,
    this.controller,
    this.maxLength,
    this.maxLine,
    required this.show,
    required this.type,
  }) : super(key: key);

  String title;
  Widget? icon;
  String? initialValue;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validate;
  GestureTapCallback? onTap;
  TextEditingController? controller;
  int? maxLength;
  int? maxLine = 1;
  RxBool show;
  RxBool see = true.obs;
  TextInputType type = TextInputType.number;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
          child: TextFormField(
            // textDirection: TextDirection.rtl,
            onChanged: onChanged,
            onTap: onTap,
            obscureText: see.value,
            validator: validate,
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: ColorUtils.kShadowColor,
            cursorHeight: Get.height * .03,
            textDirection: TextDirection.ltr,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            maxLines: 1,
            initialValue: initialValue,
            textAlign: TextAlign.left,
            maxLength: maxLength,
            keyboardType: type,
            scrollPadding: MediaQuery.of(Get.context!).viewInsets,
            decoration: InputDecoration(
              isDense: true,
              alignLabelWithHint: true,
              counterText: "",
              labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
              suffixIcon: show.isTrue
                  ? const Text("")
                  : IconButton(
                      icon: Icon(
                        see.isTrue ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        see.value = !see.value;
                      },
                    ),
              prefixIconColor: ColorUtils.kShadowColor,
              labelText: title,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
      );
    });
  }
}
