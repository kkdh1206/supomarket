enum BoardStatus {PUBLIC, PRIVATE, DELETED}

class Board {
  int? id;
  String? title;
  String? description;
  BoardStatus? boardStatus;
  String? userName;
  String? userStudentNumber;
  String? uploadDate;
  DateTime? uploadDateForCompare;

  Board({
    required this.id,
    required this.title,
    required this.description,
    required this.boardStatus,
    required this.userName,
    required this.userStudentNumber,
    this.uploadDate,
    this.uploadDateForCompare,
  });

}
