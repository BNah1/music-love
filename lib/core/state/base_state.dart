import 'package:musiclove/core/constant/app_enum.dart';

abstract class BaseState {
  final BaseStatus status;
  final String errorMessage;

  const BaseState({this.status = BaseStatus.initial, this.errorMessage = ''});

  BaseState copyWith({
    BaseStatus? status,
    String? errorMessage,
  });
}