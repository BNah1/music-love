extension DateOnlyCompare on DateTime {

  bool isSameDate(DateTime other) {
    return year == other.year &&
        month == other.month &&
        day == other.day;
  }

  /// Trả về DateTime chỉ với ngày (giờ = 0)
  DateTime get dateOnly => DateTime(year, month, day);
}
