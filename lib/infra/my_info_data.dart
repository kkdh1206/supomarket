import '../entity/setting_entity.dart';
import '../entity/user_entity.dart';

var mySetting = Setting(
  categoryAlarmOnOff: false,
  chatAlarmOnOff: false,
  categoryAlarms:
  {"전자기기" : true,
    "의류" : false,
    "자취방" : false,
    "모니터" : false,
    "책" : false,
    "기타" : false},
  selectedCategoryAlarm: "없음",
);

var myUserInfo = AUser(
    id: 0,
    email: "",
    password : "",
    userName: "",
    realName : "",
    imagePath: "assets/images/user.png",
    userStudentNumber: "",
    userItemNum: 0,
    isUserLogin: false, //이걸로 초기 페이지 조절 가능
    userStatus: UserStatus.NORMAL,
    userInterestedId: [],
    userUid: "",
    userScore: 0,
    userGrade: "C0",
    requestList : [],
);
