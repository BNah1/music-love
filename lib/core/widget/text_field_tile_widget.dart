import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:musiclove/core/constant/app_style.dart';

class TextFieldTileWidget extends StatelessWidget {
  const TextFieldTileWidget({
    super.key,
    required this.ctrl,
    required this.label,
    this.isNumber = false,
    this.subChild,
    this.icon = Icons.text_fields,
    this.hint = '',
    this.valid,
  });

  final TextEditingController ctrl;
  final String label;
  final bool isNumber;
  final Widget? subChild;
  final IconData icon;
  final String hint;
  final FormFieldValidator<String>? valid;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.textTaskTitle(AppColor.primaryTextColor),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: AppSize.fieldWidthRatio(context),
          child: Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  width: AppSize.fieldWidthRatio(context),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.paddingDashBoard,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppColor.primaryOverlay,
                  ),
                  child: SizedBox(
                    height: AppSize.buttonHeight,
                    child: TextFormField(
                      inputFormatters: isNumber
                          ? [
                              CurrencyInputFormatter(
                                thousandSeparator: ThousandSeparator.Comma,
                                mantissaLength: 0,
                                trailingSymbol: '',
                                useSymbolPadding: false,
                              ),
                            ]
                          : [],
                      keyboardType: isNumber
                          ? TextInputType.number
                          : TextInputType.text,
                      style: AppTextStyle.textHint(AppColor.primaryTextColor),
                      controller: ctrl,
                      decoration: InputDecoration(
                        hintText: hint,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        icon: Icon(icon, color: Colors.grey),
                        border: InputBorder.none,
                      ),

                      validator: valid,
                    ),
                  ),
                ),
              ),
              ?subChild,
            ],
          ),
        ),
      ],
    );
  }
}
