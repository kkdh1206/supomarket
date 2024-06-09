class Setting {
  bool? chatAlarmOnOff= true;
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