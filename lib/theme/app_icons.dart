/// Icon asset paths from the BeaverTalk Figma `02_Icon Component` frame.
///
/// Each constant points to an SVG under `assets/icons/`. Render with
/// `flutter_svg`, e.g.:
///
/// ```dart
/// SvgPicture.asset(AppIcons.check, width: 24, height: 24)
/// ```
///
/// SVGs are vector, so a single asset per icon scales to any size.
abstract final class AppIcons {
  AppIcons._();

  static const String _base = 'assets/icons';

  static const String alarmClock = '$_base/alarm-clock.svg';
  static const String arrowLeft = '$_base/arrow-left.svg';
  static const String arrowRight = '$_base/arrow-right.svg';
  static const String bookmarkFill = '$_base/bookmark-fill.svg';
  static const String bookmarkLine = '$_base/bookmark-line.svg';
  static const String calendar = '$_base/calendar.svg';
  static const String call = '$_base/call.svg';
  static const String callEnd = '$_base/call-end.svg';
  static const String check = '$_base/check.svg';
  static const String chevronLeft = '$_base/chevron-left.svg';
  static const String chevronRight = '$_base/chevron-right.svg';
  static const String close = '$_base/close.svg';
  static const String edit = '$_base/edit.svg';
  static const String eyeFill = '$_base/eye-fill.svg';
  static const String eyeLine = '$_base/eye-line.svg';
  static const String flag = '$_base/flag.svg';
  static const String global = '$_base/global.svg';
  static const String heartEyes = '$_base/heart-eyes.svg';
  static const String history = '$_base/history.svg';
  static const String lock = '$_base/lock.svg';
  static const String magicWand = '$_base/magic-wand.svg';
  static const String mail = '$_base/mail.svg';
  static const String mic = '$_base/mic.svg';
  static const String plus = '$_base/plus.svg';
  static const String profile = '$_base/profile.svg';
  static const String redo = '$_base/redo.svg';
  static const String search = '$_base/search.svg';
  static const String share = '$_base/share.svg';
  static const String thumbsDown = '$_base/thumbs-down.svg';
  static const String thumbsUp = '$_base/thumbs-up.svg';
  static const String translate = '$_base/translate.svg';
  static const String trash = '$_base/trash.svg';
  static const String user = '$_base/user.svg';
  static const String volume = '$_base/volume.svg';

  /// All icon asset paths, useful for previews and galleries.
  static const List<String> all = [
    alarmClock,
    arrowLeft,
    arrowRight,
    bookmarkFill,
    bookmarkLine,
    calendar,
    call,
    callEnd,
    check,
    chevronLeft,
    chevronRight,
    close,
    edit,
    eyeFill,
    eyeLine,
    flag,
    global,
    heartEyes,
    history,
    lock,
    magicWand,
    mail,
    mic,
    plus,
    profile,
    redo,
    search,
    share,
    thumbsDown,
    thumbsUp,
    translate,
    trash,
    user,
    volume,
  ];
}
