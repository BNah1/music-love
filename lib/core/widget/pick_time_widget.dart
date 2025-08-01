import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_style.dart';
import 'package:musiclove/core/utils/valid_utils.dart';

class PickTimeWidget extends StatefulWidget {
  const PickTimeWidget({super.key, required this.pickTime});

  final Function(DateTime) pickTime;

  @override
  State<PickTimeWidget> createState() => _PickTimeWidgetState();
}

class _PickTimeWidgetState extends State<PickTimeWidget> {
  late DateTime pickTime;

  @override
  void initState() {
    super.initState();
    pickTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Day', style: AppTextStyle.textTaskTitle(Colors.black)),
        const SizedBox(height: 10),
        SizedBox(
          width: AppSize.fieldWidthRatio(context),
          child: Row(
            children: [
              _iconTap(false),
              /// time tile show
              Expanded(child: buildTimeTile()),
              _iconTap(true),
            ],
          ),
        ),
      ],
    );
  }

  /// icon < > action
  Widget _iconTap(bool isNext) {
    return InkWell(
      onTap: () {
        if (isNext) {
          pickTime = pickTime.add(const Duration(days: 1));
        } else {
          pickTime = pickTime.subtract(const Duration(days: 1));
        }
        setState(() {
          widget.pickTime(pickTime);
        });
      },
      child: Icon(isNext ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new),
    );
  }

  /// time tile show
  Widget buildTimeTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.paddingDashBoard),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: AppColor.primaryOverlay,
      ),
      child: InkWell(
        onTap: () async {
          /// pick time action
          await handlePickTime();
        },
        child: SizedBox(
          height: AppSize.buttonHeight,
          child: Row(
            children: [
              const Icon(Icons.date_range, color: Colors.grey),
              const SizedBox(width: 15),
              Text(
                // pickTime.toString(),
                formatDateCalender(pickTime),
                // pickTime.toLocal().toString().split(' ')[0],
                style: AppTextStyle.textTaskTitle(Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// pick time action
  Future<void> handlePickTime() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 20),
      initialDate: pickTime,
    );
    if (picked != null) {
      setState(() => pickTime = picked);
      widget.pickTime(picked);
    }
  }
}
