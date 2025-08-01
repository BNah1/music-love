import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_style.dart';

class ToastUtils {

  static void showToast(
    BuildContext context,
    String message,
    String title,
    String optionText,
  ) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(optionText),
              ),
            ],
          );
        },
      );
    }
  }

  static void showToastConfirm(
    BuildContext context,
    String message,
    String title,
    Function(BuildContext context) tap,
  ) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (contextDialog) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(contextDialog).pop();
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => tap(contextDialog),
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
    }
  }

  // void showModal(BuildContext context, Widget child) {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     showDragHandle: true,
  //     useRootNavigator: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return DraggableScrollableSheet(
  //         initialChildSize: 0.85,
  //         minChildSize: 0.4,
  //         maxChildSize: 0.95,
  //         expand: false,
  //         builder: (_, scrollController) {
  //           return Container(
  //             padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom,
  //               left: 16,
  //               right: 16,
  //               top: 16,
  //             ),
  //             decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //             ),
  //             child: SingleChildScrollView(
  //               controller: scrollController,
  //               child: child,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  static void showModal(BuildContext context, Widget child) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }



  static void showErrorBottom(String message, BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message,style: const TextStyle(color: Colors.black),),
        backgroundColor: AppColor.primaryOverlay,
      ),
    );
  }



  ToastUtils._();
}
