class userSettingDatas {
  final int fontSize;
  final String fontStyle;

  userSettingDatas(
      {required this.fontSize,
        required this.fontStyle,});

  Map<String,dynamic> toMap() {
    return {
      'fontSize': fontSize,
      'fontStyle': fontStyle,
    };
  }
}
