class Setting {
  bool? chatAlarmOnOff;
  bool? categoryAlarmOnOff;
  Map? categoryAlarms;
  String? selectedCategoryAlarm;

  Setting
      ({
    required this.chatAlarmOnOff,
    required this.categoryAlarmOnOff,
    required this.categoryAlarms,
    required this.selectedCategoryAlarm,
  });

}