import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UpgradePage extends StatefulWidget {
  final Character character;

  const UpgradePage({
    super.key,
    required this.character,
  });

  @override
  _UpgradePageState createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> with WidgetsBindingObserver {
  bool isReadyForView = false;
  bool isFirstSkillShow = false;
  bool isSecondSkillShow = false;
  bool isThirdSkillShow = false;
  bool isFourthSkillShow = false;
  bool isFifthSkillShow = false;

  final AudioPlayer _effectPlayer = AudioPlayer();
  double effectSesSeviyesi = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkReadyForView();
    loadVolumeSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _effectPlayer.dispose();
    super.dispose();
  }

  void checkReadyForView() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isReadyForView = true;
      if (widget.character.firstEntryUpgradePage == 0) {
        firstLookThePages();
      }
    });
  }

  void firstLookThePages() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    TextStyle baseNumberStyle = const TextStyle(
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.black87,
    );

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.06,
                  bottom: height * 0.06,
                  right: width * 0.08,
                  left: width * 0.08,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tebrikler!!!\nSeviye Atladınız!",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "İkinci seviyeye ulaştınız. Sizi tebrik ederiz. Bu "
                              "sayfada her seviye atladığınızda elde ettiğiniz "
                              "Yetenek ve Hız Puanlarını kullanarak yeteneklerinizi "
                              "geliştirip hızlandırabilir ve aynı zamanda temel "
                              "statülerinizi ve üretim verimliliğinizi de "
                              "geliştirebilirsiniz.",
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.045),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.25),
                        foregroundColor: Colors.black,
                        shadowColor: Colors.black.withOpacity(0.2),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.only(
                          top: height * 0.011,
                          bottom: height * 0.011,
                          left: width * 0.075,
                          right: width * 0.075,
                        ),
                      ),
                      onPressed: () {
                        widget.character.firstEntryUpgradePage++;
                        widget.character.saveCharacterData();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Anladım',
                        style: baseNumberStyle.copyWith(fontSize: width * 0.05),
                        textScaler: const TextScaler.linear(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> loadVolumeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      effectSesSeviyesi = prefs.getDouble('effectSesSeviyesi') ?? 1.0;
    });
    _effectPlayer.setVolume(effectSesSeviyesi);
  }

  void showInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    TextStyle baseNumberStyle = const TextStyle(
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.black87,
    );

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.06,
                  bottom: height * 0.06,
                  right: width * 0.08,
                  left: width * 0.08,
                ),
                child: Column(
                  children: [
                    Text(
                      "Simgeler Hakkında",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.02),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.book_solid,
                                  color: Colors.teal,
                                  size: width * 0.06,
                                ),
                                Icon(
                                  CupertinoIcons.arrow_right,
                                  color: Colors.black87,
                                  size: width * 0.04,
                                ),
                                Text(
                                  " Sıfırlama Kartı Miktarı",
                                  style: baseTextStyle.copyWith(
                                      fontSize: width * 0.045),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.military_tech_outlined,
                                  color: Colors.cyan.shade700,
                                  size: width * 0.06,
                                ),
                                Icon(
                                  CupertinoIcons.arrow_right,
                                  color: Colors.black87,
                                  size: width * 0.04,
                                ),
                                Text(
                                  " Yetenek Puanı Miktarı",
                                  style: baseTextStyle.copyWith(
                                      fontSize: width * 0.045),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: Colors.redAccent,
                                  size: width * 0.06,
                                ),
                                Icon(
                                  CupertinoIcons.arrow_right,
                                  color: Colors.black87,
                                  size: width * 0.04,
                                ),
                                Text(
                                  " Hız Puanı Miktarı",
                                  style: baseTextStyle.copyWith(
                                      fontSize: width * 0.045),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              "Ayrıntılı Açıklama",
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.06),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              "    'Yetenek Puanı' ve 'Hız Puanı', "
                              "karakterinizin seviye atladıkça kazandığı özel "
                              "gelişim puanlarıdır. Bu puanlar sayesinde "
                              "karakterinizi daha güçlü ve etkili hale "
                              "getirebilirsiniz. Örneğin, bir Yetenek Puanı "
                              "ile karakterinizin kilitli bir özel hareketini "
                              "(yani bir yeteneğini) açabilirsiniz. Bu "
                              "yetenekler, savaşlarda size büyük avantajlar "
                              "sağlar. Hız Puanı ise, bu yeteneklerin "
                              "tekrar kullanılabilir olma süresini yani "
                              "'soğuma süresini' azaltmak için kullanılır. "
                              "Böylece bir yeteneği daha kısa aralıklarla "
                              "tekrar kullanabilirsiniz. Ayrıca bu puanları, "
                              "karakterinizin temel statülerini (güç, zeka, "
                              "beceri, karizma gibi statüleri) daha da "
                              "geliştirmek için de harcayabilirsiniz."
                              "\n\n"
                              "    Ancak bazen puanları yanlış yerlerde "
                              "kullanmış veya oyun tarzınızı değiştirmek "
                              "isteyebilirsiniz. İşte tam bu noktada "
                              "'Sıfırlama Kartı' devreye girer. "
                              "Sıfırlama Kartı, daha önce harcadığınız tüm "
                              "Yetenek Puanlarını sıfırlayarak, "
                              "onları yeniden dağıtmanıza imkân tanır. "
                              "Böylece farklı bir strateji izleyebilir, "
                              "yeni yetenekler deneyebilir ya da "
                              "farklı statülere ağırlık verebilirsiniz. "
                              "Bu kartı gizemli marketten elde edebilirsiniz.",
                              textAlign: TextAlign.start,
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.045),
                              textScaler: const TextScaler.linear(1),
                            ),
                            if (widget.character.resetCards > 0)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: height * 0.01),
                                  Container(
                                    width: width * 0.5,
                                    height: height * 0.0015,
                                    color: Colors.teal.shade700,
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    "    Şuan 'Sıfırlama Kartına' sahipsiniz. "
                                    "Bu kartla verdiğiniz yetenek puanlarının "
                                    "tamamını geri alabilirsiniz ve bununla "
                                    "birlikte kilidi açılmış tüm geliştirmeler geri "
                                    "kilitlenir.\n\n    Dikkatli olun bu işlem geri "
                                    "alınamaz!\n\n    Sıfırlama kartını "
                                    "kullanmak istiyor musunuz?",
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.045),
                                    textAlign: TextAlign.left,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                  SizedBox(height: height * 0.015),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.teal.withOpacity(0.25),
                                      foregroundColor: Colors.black,
                                      shadowColor:
                                          Colors.black.withOpacity(0.2),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.only(
                                        top: height * 0.011,
                                        bottom: height * 0.011,
                                        left: width * 0.075,
                                        right: width * 0.075,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (widget.character.resetCards > 0) {
                                        setState(() {
                                          widget.character.resetCards--;
                                          widget.character.skillPoints = 0;
                                          widget.character.firstSkillLock =
                                              false;
                                          widget.character.secondSkillLock =
                                              false;
                                          widget.character.thirdSkillLock =
                                              false;
                                          widget.character.fourthSkillLock =
                                              false;
                                          widget.character.fifthSkillLock =
                                              false;
                                          widget.character.strengthPlus = 0;
                                          widget.character.intelligencePlus = 0;
                                          widget.character.dexterityPlus = 0;
                                          widget.character.charismaPlus = 0;
                                          widget.character.productEfficiency =
                                              0;
                                          switch (widget.character.level) {
                                            case 2:
                                              widget.character.skillPoints += 2;
                                              break;
                                            case 3:
                                              widget.character.skillPoints += 3;
                                              break;
                                            case 4:
                                              widget.character.skillPoints += 4;
                                              break;
                                            case 5:
                                              widget.character.skillPoints += 5;
                                              break;
                                            case 6:
                                              widget.character.skillPoints += 6;
                                              break;
                                            case 7:
                                              widget.character.skillPoints += 8;
                                              break;
                                            case 8:
                                              widget.character.skillPoints +=
                                                  10;
                                              break;
                                            case 9:
                                              widget.character.skillPoints +=
                                                  12;
                                              break;
                                            case 10:
                                              widget.character.skillPoints +=
                                                  15;
                                              break;
                                          }
                                        });
                                      }
                                      widget.character.saveCharacterData();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Kullan',
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.05),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.015),
                                  Container(
                                    width: width * 0.5,
                                    height: height * 0.0015,
                                    color: Colors.teal.shade700,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.25),
                        foregroundColor: Colors.black,
                        shadowColor: Colors.black.withOpacity(0.2),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.only(
                          top: height * 0.011,
                          bottom: height * 0.011,
                          left: width * 0.075,
                          right: width * 0.075,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Anladım',
                        style: baseNumberStyle.copyWith(fontSize: width * 0.05),
                        textScaler: const TextScaler.linear(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showExtraInfo(String titleText, String bodyText) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.red[800],
    );
    TextStyle baseNumberStyle = const TextStyle(
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.black87,
    );

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.06,
                  bottom: height * 0.06,
                  right: width * 0.08,
                  left: width * 0.08,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titleText,
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(
                          bodyText,
                          style:
                              baseNumberStyle.copyWith(fontSize: width * 0.04),
                          textAlign: TextAlign.left,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.25),
                        foregroundColor: Colors.black,
                        shadowColor: Colors.black.withOpacity(0.2),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.only(
                          top: height * 0.011,
                          bottom: height * 0.011,
                          left: width * 0.075,
                          right: width * 0.075,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Anladım',
                        style: baseNumberStyle.copyWith(fontSize: width * 0.05),
                        textScaler: const TextScaler.linear(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void bottomAlert(String text, Color color) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle bottomTextStyle = TextStyle(
      fontSize: width * 0.043,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: bottomTextStyle,
          textAlign: TextAlign.left,
          textScaler: const TextScaler.linear(1),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.only(
          left: width * 0.01,
          right: width * 0.01,
          bottom: height * 0.01,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
    );

    TextStyle baseNumberStyle = TextStyle(
      fontSize: width * 0.04,
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.black87,
    );

    TextStyle skillTextStyle = TextStyle(
      fontSize: width * 0.0325,
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.white,
      shadows: const [
        Shadow(offset: Offset(-1, -1), color: Colors.black),
        Shadow(offset: Offset(1, -1), color: Colors.black),
        Shadow(offset: Offset(1, 1), color: Colors.black),
        Shadow(offset: Offset(-1, 1), color: Colors.black),
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/backgrounds/primary/general_page_bg.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: statusBarHeight,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: width * 0.05),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.arrow_left_circle_fill,
                            size: width * 0.09,
                          ),
                          color: Colors.black,
                          onPressed: () {
                            widget.character.saveCharacterData();
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: width * 0.02),
                        Text(
                          'Kendini Geliştir',
                          style: baseTextStyle.copyWith(
                              fontSize: width * 0.055, color: Colors.black87),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.06),
                          Icon(
                            Icons.military_tech_outlined,
                            color: Colors.cyan.shade700,
                            size: width * 0.06,
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            "${widget.character.skillPoints}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          SizedBox(width: width * 0.06),
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.redAccent,
                            size: width * 0.06,
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            "${widget.character.hizPoints}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.book_solid,
                            color: Colors.teal,
                            size: width * 0.06,
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            "${widget.character.resetCards}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          SizedBox(width: width * 0.06),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                showInfo();
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.question_circle_fill,
                                size: width * 0.07,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.06),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.06),
                      Text(
                        "Yetenekler ve Kilit Durumları:",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.05, color: Colors.black87),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  // Yetenek kilit butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: width * 0.03,
                          left: width * 0.03,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.black.withOpacity(0.2),
                            highlightColor: Colors.black.withOpacity(0.1),
                            onTap: () {
                              if (!widget.character.firstSkillLock) {
                                if (widget.character.skillPoints > 0) {
                                  setState(() {
                                    widget.character.firstSkillLock = true;
                                    widget.character.skillPoints--;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Yeteri miktarda Yetenek Puanı yok!",
                                    Colors.red,
                                  );
                                }
                              } else {
                                bottomAlert(
                                  "Yeteneğin kilidi halihazırda açılmış durumda!",
                                  Colors.green,
                                );
                              }
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: width * 0.115,
                              height: width * 0.115,
                              decoration: BoxDecoration(
                                color: widget.character.firstSkillLock
                                    ? Colors.green
                                    : Colors.red.shade600,
                                borderRadius: BorderRadius.circular(35.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: width * 0.003,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  widget.character.firstSkillLock
                                      ? Icons.lock_open
                                      : Icons.lock_outline,
                                  color: Colors.white,
                                  size: width * 0.06,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: width * 0.03,
                          left: width * 0.03,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.black.withOpacity(0.2),
                            highlightColor: Colors.black.withOpacity(0.1),
                            onTap: () {
                              if (!widget.character.secondSkillLock) {
                                if (widget.character.skillPoints > 0) {
                                  setState(() {
                                    widget.character.secondSkillLock = true;
                                    widget.character.skillPoints--;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Yeteri miktarda Yetenek Puanı yok!",
                                    Colors.red,
                                  );
                                }
                              } else {
                                bottomAlert(
                                  "Yeteneğin kilidi halihazırda açılmış durumda!",
                                  Colors.green,
                                );
                              }
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: width * 0.115,
                              height: width * 0.115,
                              decoration: BoxDecoration(
                                color: widget.character.secondSkillLock
                                    ? Colors.green
                                    : Colors.red.shade600,
                                borderRadius: BorderRadius.circular(35.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: width * 0.003,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  widget.character.secondSkillLock
                                      ? Icons.lock_open
                                      : Icons.lock_outline,
                                  color: Colors.white,
                                  size: width * 0.06,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: width * 0.03,
                          left: width * 0.03,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.black.withOpacity(0.2),
                            highlightColor: Colors.black.withOpacity(0.1),
                            onTap: () {
                              if (!widget.character.thirdSkillLock) {
                                if (widget.character.skillPoints > 0) {
                                  setState(() {
                                    widget.character.thirdSkillLock = true;
                                    widget.character.skillPoints--;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Yeteri miktarda Yetenek Puanı yok!",
                                    Colors.red,
                                  );
                                }
                              } else {
                                bottomAlert(
                                  "Yeteneğin kilidi halihazırda açılmış durumda!",
                                  Colors.green,
                                );
                              }
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: width * 0.115,
                              height: width * 0.115,
                              decoration: BoxDecoration(
                                color: widget.character.thirdSkillLock
                                    ? Colors.green
                                    : Colors.red.shade600,
                                borderRadius: BorderRadius.circular(35.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: width * 0.003,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  widget.character.thirdSkillLock
                                      ? Icons.lock_open
                                      : Icons.lock_outline,
                                  color: Colors.white,
                                  size: width * 0.06,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: width * 0.03,
                          left: width * 0.03,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.black.withOpacity(0.2),
                            highlightColor: Colors.black.withOpacity(0.1),
                            onTap: () {
                              if (!widget.character.fourthSkillLock) {
                                if (widget.character.skillPoints > 0) {
                                  setState(() {
                                    widget.character.fourthSkillLock = true;
                                    widget.character.skillPoints--;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Yeteri miktarda Yetenek Puanı yok!",
                                    Colors.red,
                                  );
                                }
                              } else {
                                bottomAlert(
                                  "Yeteneğin kilidi halihazırda açılmış durumda!",
                                  Colors.green,
                                );
                              }
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: width * 0.115,
                              height: width * 0.115,
                              decoration: BoxDecoration(
                                color: widget.character.fourthSkillLock
                                    ? Colors.green
                                    : Colors.red.shade600,
                                borderRadius: BorderRadius.circular(35.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: width * 0.003,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  widget.character.fourthSkillLock
                                      ? Icons.lock_open
                                      : Icons.lock_outline,
                                  color: Colors.white,
                                  size: width * 0.06,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: width * 0.03,
                          left: width * 0.03,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.black.withOpacity(0.2),
                            highlightColor: Colors.black.withOpacity(0.1),
                            onTap: () {
                              if (!widget.character.fifthSkillLock) {
                                if (widget.character.skillPoints > 0) {
                                  setState(() {
                                    widget.character.fifthSkillLock = true;
                                    widget.character.skillPoints--;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Yeteri miktarda Yetenek Puanı yok!",
                                    Colors.red,
                                  );
                                }
                              } else {
                                bottomAlert(
                                  "Yeteneğin kilidi halihazırda açılmış durumda!",
                                  Colors.green,
                                );
                              }
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: width * 0.115,
                              height: width * 0.115,
                              decoration: BoxDecoration(
                                color: widget.character.fifthSkillLock
                                    ? Colors.green
                                    : Colors.red.shade600,
                                borderRadius: BorderRadius.circular(35.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: width * 0.003,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  widget.character.fifthSkillLock
                                      ? Icons.lock_open
                                      : Icons.lock_outline,
                                  color: Colors.white,
                                  size: width * 0.06,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  // Yetenek Görselleri
                  if (widget.character.characterClass == 'Barbar')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = true;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/kemik_kiran.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = true;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/kukreme.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = true;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/ofke_hasati.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = true;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/guc_patlamasi.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = true;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/sarsilmaz_vucut.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (widget.character.characterClass == 'Paladin')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = true;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/kutsanmis.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = true;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/kutsal_odak.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = true;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/secilmis_irade.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = true;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/paladinin_duasi.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = true;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/ruhani_vucut.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (widget.character.characterClass == 'Hırsız')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = true;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/sasirtmaca.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = true;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/manipulasyon.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = true;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/ruh_hirsizi.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = true;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/hileli_zar.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = true;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/olumcul_vurus.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (widget.character.characterClass == 'Korucu')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = true;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/cevik_adim.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = true;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/zehirli_saldiri.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = true;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/dengesiz_ruzgar.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = true;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/doganin_hediyesi.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = true;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/ormanin_yankisi.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (widget.character.characterClass == 'Büyücü')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = true;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/yarinin_arzusu.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = true;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/buyu_ustadi.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = true;
                                isFourthSkillShow = false;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/yildirim_ruhu.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = true;
                                isFifthSkillShow = false;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/halusinasyon.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isFirstSkillShow = false;
                                isSecondSkillShow = false;
                                isThirdSkillShow = false;
                                isFourthSkillShow = false;
                                isFifthSkillShow = true;
                              });
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/kaderin_cagrisi.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Sınıf Yetenek Açıklamaları
                  if (isFirstSkillShow &&
                      widget.character.characterClass == 'Barbar') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Kemik Kıran\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve mevcut turda "
                            "düşmana, Normal Saldırı Değerinin 2 katı kadar bir "
                            "hasar uygular."
                            "\n\n"
                            "Kulanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 2 x Saldırı Değeri\n"
                            "Sonraki Tur: Düşmana Geçer",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isSecondSkillShow &&
                      widget.character.characterClass == 'Barbar') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Kükreme\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve bulunduğu turda "
                            "düşmana, Normal Saldırı Değerinin yanında onları "
                            "sonraki tur boyunca korkuya sürükler ve saldırı "
                            "yapamaz duruma getirir."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 1 x Saldırı Değeri\n"
                            "Sonraki Tur: Oyuncuda Kalır",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isThirdSkillShow &&
                      widget.character.characterClass == 'Barbar') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Öfke Hasatı\n\n"
                            "Bu yetenek ile oyuncu 25 Can Puanı feda ederek 1 "
                            "Aksion Barı kazanır. Ek olarak bu yetenek öyle "
                            "hızlıdır ki, oyuncu bir tur daha saldırı yapabilir."
                            "\n\n"
                            "Kullanım Bedeli: 25 Can Değeri\n"
                            "Alınan İyileşme: 1 Aksiyon Barı\n"
                            "Sonraki Tur: Oyuncuda Kalır",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFourthSkillShow &&
                      widget.character.characterClass == 'Barbar') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Güç Patlaması\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcayarak oyuncunun "
                            "Saldırı Değerini, sonraki turla beraber 3 tur "
                            "boyunca 1.5 katına çıkartır. Ancak bu ritüel zaman "
                            "aldığı için tur düşmana geçer."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Alınan Güçlendirme: 1.5 x Saldırı Değeri\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Tur Devamlılığı: 3 Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFifthSkillShow &&
                      widget.character.characterClass == 'Barbar') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Sarsılmaz Vücut\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcayarak oyuncunun "
                            "Savunma Değerini, bulunduğu turla beraber 2 tur "
                            "boyunca 2 katına çıkartır. Ancak bu ritüel zaman "
                            "aldığı için tur düşmana geçer."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Alınan Güçlendirme: 2 x Savunma Değeri\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Tur Devamlılığı: 2 Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFirstSkillShow &&
                      widget.character.characterClass == 'Paladin') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Kutsanmış\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve bulunduğu turda "
                            "düşmana, art arda 2 kez Normal Saldırı Değeri kadar "
                            "hasar uygular."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 1 x Saldırı Değeri\n"
                            "Atılan Zar: 2 Adet\n"
                            "Sonraki Tur: Düşmana Geçer",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isSecondSkillShow &&
                      widget.character.characterClass == 'Paladin') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Kutsal Odak\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve bulunduğu turda "
                            "düşmana, Normal Saldırı Değeri kadar hasar uygular. "
                            "Fakat bu yetenekteki odak etkisi sayesinde oyuncu, "
                            "düşmana bir kez daha saldırabilir."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 1 x Saldırı Değeri\n"
                            "Sonraki Tur: Oyuncuda Kalır",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isThirdSkillShow &&
                      widget.character.characterClass == 'Paladin') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Seçilmiş İrade\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve sonraki tur oyuncu "
                            "için atılan zarın Zar Değerini arttırır. Ancak bu "
                            "ritüel zaman aldığı için tur düşmana geçer."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Alınan Güçlendirme: Pozitif Zar Değeri\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Etki: Sonraki Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFourthSkillShow &&
                      widget.character.characterClass == 'Paladin') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Paladinin Duası\n\n"
                            "Bu yetenek oyuncunun 1 Aksiyon Barı yenilemesini "
                            "sağlar. Ancak bu ritüel zaman aldığı için tur "
                            "düşmana geçer."
                            "\n\n"
                            "Alınan İyileşme: 1 Aksiyon Barı\n"
                            "Sonraki Tur: Düşmana Geçer",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFifthSkillShow &&
                      widget.character.characterClass == 'Paladin') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Ruhani Vücut\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve şansa bağlı "
                            "olarak oyuncunun Can Değerini 10-50 Puan aralığında "
                            "iyileştirir. Ancak bu ritüel zaman aldığı için tur "
                            "düşmana geçer."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Alınan İyileşme: 10-50 Can Değeri\n"
                            "Sonraki Tur: Düşmana Geçer",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFirstSkillShow &&
                      widget.character.characterClass == 'Hırsız') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Şaşırtmaca\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve şansa bağlı "
                            "olarak düşmanın zihnini bulandırır. Ancak bu ritüel "
                            "zaman aldığı için tur düşmana geçer.\n\n"
                            "Zihni bulanan düşman, kendi hasarının tamamını yada "
                            "hasarının yarısını kendisine isabet ettirir. Eğer "
                            "hasarın yarısı düşmana isabet ederse, kalan yarısı "
                            "oyuncuya isabet eder."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Zayıflatma: Saldırı Bozukluğu\n"
                            "Sonraki Tur: Düşmana Geçer",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isSecondSkillShow &&
                      widget.character.characterClass == 'Hırsız') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Manipülasyon\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve 3 tur boyunca "
                            "düşman için atılan zarın Zar Değerini azaltır. "
                            "Ancak bu ritüel zaman aldığı için tur düşmana geçer."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Zayıflatma: Zar Değeri\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Tur Devamlılığı: 3 Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isThirdSkillShow &&
                      widget.character.characterClass == 'Hırsız') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Ruh Hırsızı\n\n"
                            "Bu yetenek ile oyuncu, düşmanın Can Değerinden 10-50 "
                            "Puan kadar Can Değerini kendisi için çalmasını "
                            "sağlar. Aynı zamanda, bu hamle oyuncuya 1 Aksiyon "
                            "Barı yenileme fırsatı verir."
                            "\n\n"
                            "Verilen Zayıflatma: 10-50 Can Değeri Hırsızlığı\n"
                            "Alınan İyileşme: 1 Aksiyon Barı\n"
                            "Sonraki Tur: Düşmana Geçer",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFourthSkillShow &&
                      widget.character.characterClass == 'Hırsız') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Hileli Zar\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve oyuncuya mevcut "
                            "tur için 2 farklı zar atma şansı ve tekrar "
                            "saldırma hakkı verir."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Alınan Güçlendirme: Zar Atışı Artışı\n"
                            "Sonraki Tur: Oyuncuda Kalır",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFifthSkillShow &&
                      widget.character.characterClass == 'Hırsız') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Ölümcül Vuruş\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve oyuncu şansa "
                            "bağlı olarak düşmana büyük bir hasar uygular. Bu "
                            "saldırı, oyuncu şansına göre yön değiştirebilir ve "
                            "hem düşman hemde oyuncu büyük hasarlar alabilir. "
                            "Kullanırken dikkatli olunması gerekir."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 3 x Saldırı Değeri\n"
                            "Hasar Tepmesi: Zar Değerine Bağlı Değişken\n"
                            "Sonraki Tur: Düşmana Geçer",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFirstSkillShow &&
                      widget.character.characterClass == 'Korucu') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Çevik Adım\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve mevcut turda "
                            "düşmana, Normal Saldırı Değeri kadar hasar "
                            "uygular. Ek olarak hasarın yanında %50 şansla "
                            "oyuncuya bir kez daha aksiyon alma fırsatı sunar."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 1 x Saldırı Değeri\n"
                            "Sonraki Tur: Değişken",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isSecondSkillShow &&
                      widget.character.characterClass == 'Korucu') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Zehirli Saldırı\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve mevcut turda "
                            "düşmana, Normal Saldırı Değeri kadar hasar uygular. "
                            "Ek olarak düşmanı, 3 tur boyunca zehir etkisine "
                            "maruz bırakır. Zehir etkisi Normal Saldırı Değerinin "
                            "yarısı kadar etkilidir."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 1 x Saldırı Değeri\n"
                            "Alınan Güçlendirme: 0.5 x Saldırı Değeri\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Etki: Sonraki Tur\n"
                            "Tur Devamlılığı: 3 Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isThirdSkillShow &&
                      widget.character.characterClass == 'Korucu') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Dengesiz Rüzgar\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve mevcut turda "
                            "düşmana, Normal Saldırı Değerinin 2 katı kadar bir "
                            "hasar uygular. Şansa bağlı olarak bu yetenek sonraki "
                            "tur düşmanın saldırısını kendisine uygulamasını "
                            "sağlar. Eğer oyuncu çok şanslıysa düşmana kendine "
                            "kendi Saldırı Değerinin 2 katını uygulatır."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 2 x Saldırı Değeri\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Etki: Sonraki Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFourthSkillShow &&
                      widget.character.characterClass == 'Korucu') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Doğanın Hediyesi\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve şansa bağlı "
                            "olarak oyuncunun Can Değerini 7-30 Puan aralığında "
                            "iyileştirir. Ek olarak bu yetenek öyle hızlıdır ki, "
                            "oyuncu bir tur daha saldırı yapabilir."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Alınan İyileşme: 7-30 Can Değeri\n"
                            "Sonraki Tur: Oyuncuda Kalır",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFifthSkillShow &&
                      widget.character.characterClass == 'Korucu') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Ormanın Yankısı\n\n"
                            "Bu yetenek oyuncuya 2 tur boyunca, tur başına 1 "
                            "Aksiyon Barı yenilemesine olanak tanır. Ancak bu "
                            "ritüel zaman aldığı için tur düşmana geçer."
                            "\n\n"
                            "Alınan İyileşme: 1+1 Aksiyon Barı\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Tur Devamlılığı: 2 Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFirstSkillShow &&
                      widget.character.characterClass == 'Büyücü') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Yarının Arzusu\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve mevcut turun "
                            "aksiyon hakkını sonraki tura devreder ve sonraki "
                            "tur oyuncunun 2 kere aksiyon almasını sağlar."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Etki: Sonraki Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isSecondSkillShow &&
                      widget.character.characterClass == 'Büyücü') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Büyü Üstadı\n\n"
                            "Bu yetenek oyuncunun 1 Aksiyon Barını yeniler ve "
                            "ardından oyuncunun toplam Aksiyon Barı miktarına "
                            "göre oyuncunun Can Değerini 25-50 Puan kadar "
                            "yeniler. Ancak bu ritüel zaman aldığı için tur "
                            "düşmana geçer."
                            "\n\n"
                            "Alınan İyileşme: 1 Aksiyon Barı\n"
                            "Ekstra İyileşme: 25-50 Can Değeri\n"
                            "Sonraki Tur: Düşmana Geçer",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isThirdSkillShow &&
                      widget.character.characterClass == 'Büyücü') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Yıldırım Ruhu\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve savaşa bir "
                            "yıldırım ruhu çağırır. Çağrılan ruh, çağrıldığı "
                            "an düşmana oyuncunun Normal Saldırı Değeri kadar "
                            "hasar verir ve sonraki 2 tur boyunca ruh kendine "
                            "özel bir hasarla saldırılarına devam eder. 2 "
                            "turun sonunda ise ruh kaybolur. Çağırma ritüeli "
                            "uzun sürdüğü için tur düşmana geçer."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Verilen Hasar: 1 x Saldırı Değeri\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Etki: Sonraki Tur\n"
                            "Tur Devamlılığı: 2 Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFourthSkillShow &&
                      widget.character.characterClass == 'Büyücü') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                        SizedBox(width: width * 0.17),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Halüsinasyon\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve savaş meydanına "
                            "4 halüsinasyon kopyası oluşturur. Bu durum düşmanın "
                            "doğru vücudu bulana kadar saldırılar uygulamasına "
                            "neden olur. Ancak bu ritüel zaman aldığı için tur "
                            "düşmana geçer. Düşman herhangi bir kopyaya "
                            "uyguladığı her hasar sonrası o kopya yok olur, ta "
                            "ki gerçek oyuncuya hasar uygulayana dek. Düşman "
                            "gerçek oyuncuya hasar uyguladığında yetenek bozulur."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Etki: Sonraki Tur\n"
                            "Tur Devamlılığı: 1-5 Tur",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isFifthSkillShow &&
                      widget.character.characterClass == 'Büyücü') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        SizedBox(width: width * 0.17),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.0425,
                            right: width * 0.0425,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_down_circle_fill,
                            color: Colors.teal.shade700.withOpacity(0.7),
                            size: width * 0.075,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.06,
                        right: width * 0.06,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.black,
                            width: width * 0.003,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.02,
                            bottom: height * 0.02,
                          ),
                          child: Text(
                            "Kaderin Çağrısı\n\n"
                            "Bu yetenek 1 Aksiyon Barı harcar ve etkisini savaş "
                            "sonuna kadar sürdürebilecek bir hasar güçlendirmesi "
                            "oluşturur. Ancak bu ritüel zaman aldığı için tur "
                            "düşmana geçer. Bu güçlendirme her şanslı zar atışı "
                            "sonrası oyuncunun Saldırı Değerine ek olarak Normal "
                            "Saldırı Değerinin yarısı kadar bir ek hasar sağlar. "
                            "Eğer oyuncu şanssız bir zar atışı yaparsa büyü "
                            "bozulur fakat yapmazsa yetenek hep aktif kalır."
                            "\n\n"
                            "Kullanım Bedeli: 1 Aksiyon Barı\n"
                            "Alınan Güçlendirme: 0.5 x Saldırı Değeri\n"
                            "Sonraki Tur: Düşmana Geçer\n"
                            "Etki: Sonraki Tur\n"
                            "Tur Devamlılığı: Şanssız Zar Atışına Kadar",
                            style: skillTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.06),
                          Text(
                            "Yetenek Soğuma Süreleri (S.S.):",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.05, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                showExtraInfo(
                                  "Soğuma Süresi?",
                                  "    Yeteneklerin her kullanımından sonra belirli "
                                      "bir bekleme süresi olur. Buna 'Soğuma "
                                      "Süresi' denir. Bir yeteneği kullandıktan "
                                      "sonra, o yeteneği tekrar kullanabilmek "
                                      "için birkaç tur geçmesi gerekir. Bu süre "
                                      "boyunca o yetenek devre dışı kalır.\n\n"
                                      "    Ancak, 'Hız Puanı' kullanarak bu bekleme "
                                      "süresini kısaltabilirsiniz. Her bir Hız "
                                      "Puanı, soğuma süresini 1 tur azaltır. "
                                      "Soğuma süresi, en fazla 3 tura kadar "
                                      "indirilebilir. Hız Puanlarını istediğiniz "
                                      "zaman istediğiniz şekilde yeniden "
                                      "dağıtabilirsiniz. Böylece oynayış "
                                      "tarzınıza uygun bir strateji "
                                      "oluşturabilirsiniz.",
                                );
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.question_circle_fill,
                                size: width * 0.07,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.06),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.firstSkillCooldown < 8) {
                                  setState(() {
                                    widget.character.firstSkillCooldown++;
                                    widget.character.hizPoints++;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Daha fazla Hız Puanı geri alınamaz!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_left_square_fill,
                                size: width * 0.07,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.character.firstSkillCooldown}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.firstSkillLock) {
                                  if (widget.character.hizPoints > 0) {
                                    if (widget.character.firstSkillCooldown >
                                        3) {
                                      setState(() {
                                        widget.character.firstSkillCooldown--;
                                        widget.character.hizPoints--;
                                        widget.character.saveCharacterData();
                                      });
                                    } else {
                                      bottomAlert(
                                        "Daha fazla Hız Puanı verilemez!",
                                        Colors.red,
                                      );
                                    }
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Hız Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Yetenek Kilitli!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_right_square_fill,
                                size: width * 0.07,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.secondSkillCooldown < 8) {
                                  setState(() {
                                    widget.character.secondSkillCooldown++;
                                    widget.character.hizPoints++;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Daha fazla Hız Puanı geri alınamaz!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_left_square_fill,
                                size: width * 0.07,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.character.secondSkillCooldown}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.secondSkillLock) {
                                  if (widget.character.hizPoints > 0) {
                                    if (widget.character.secondSkillCooldown >
                                        3) {
                                      setState(() {
                                        widget.character.secondSkillCooldown--;
                                        widget.character.hizPoints--;
                                        widget.character.saveCharacterData();
                                      });
                                    } else {
                                      bottomAlert(
                                        "Daha fazla Hız Puanı verilemez!",
                                        Colors.red,
                                      );
                                    }
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Hız Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Yetenek Kilitli!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_right_square_fill,
                                size: width * 0.07,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.thirdSkillCooldown < 8) {
                                  setState(() {
                                    widget.character.thirdSkillCooldown++;
                                    widget.character.hizPoints++;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Daha fazla Hız Puanı geri alınamaz!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_left_square_fill,
                                size: width * 0.07,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.character.thirdSkillCooldown}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.thirdSkillLock) {
                                  if (widget.character.hizPoints > 0) {
                                    if (widget.character.thirdSkillCooldown >
                                        3) {
                                      setState(() {
                                        widget.character.thirdSkillCooldown--;
                                        widget.character.hizPoints--;
                                        widget.character.saveCharacterData();
                                      });
                                    } else {
                                      bottomAlert(
                                        "Daha fazla Hız Puanı verilemez!",
                                        Colors.red,
                                      );
                                    }
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Hız Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Yetenek Kilitli!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_right_square_fill,
                                size: width * 0.07,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.fourthSkillCooldown < 8) {
                                  setState(() {
                                    widget.character.fourthSkillCooldown++;
                                    widget.character.hizPoints++;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Daha fazla Hız Puanı geri alınamaz!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_left_square_fill,
                                size: width * 0.07,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.character.fourthSkillCooldown}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.fourthSkillLock) {
                                  if (widget.character.hizPoints > 0) {
                                    if (widget.character.fourthSkillCooldown >
                                        3) {
                                      setState(() {
                                        widget.character.fourthSkillCooldown--;
                                        widget.character.hizPoints--;
                                        widget.character.saveCharacterData();
                                      });
                                    } else {
                                      bottomAlert(
                                        "Daha fazla Hız Puanı verilemez!",
                                        Colors.red,
                                      );
                                    }
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Hız Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Yetenek Kilitli!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_right_square_fill,
                                size: width * 0.07,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.fifthSkillCooldown < 8) {
                                  setState(() {
                                    widget.character.fifthSkillCooldown++;
                                    widget.character.hizPoints++;
                                    widget.character.saveCharacterData();
                                  });
                                } else {
                                  bottomAlert(
                                    "Daha fazla Hız Puanı geri alınamaz!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_left_square_fill,
                                size: width * 0.07,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.character.fifthSkillCooldown}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.fifthSkillLock) {
                                  if (widget.character.hizPoints > 0) {
                                    if (widget.character.fifthSkillCooldown >
                                        3) {
                                      setState(() {
                                        widget.character.fifthSkillCooldown--;
                                        widget.character.hizPoints--;
                                        widget.character.saveCharacterData();
                                      });
                                    } else {
                                      bottomAlert(
                                        "Daha fazla Hız Puanı verilemez!",
                                        Colors.red,
                                      );
                                    }
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Hız Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Yetenek Kilitli!",
                                    Colors.red,
                                  );
                                }
                              },
                              child: Icon(
                                CupertinoIcons.chevron_right_square_fill,
                                size: width * 0.07,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.06),
                          Text(
                            "Statü Geliştirmeleri:",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.05, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                showExtraInfo(
                                  "Statü Gelişimi?",
                                  "    Statü geliştirmeleri, karakterinizin temel "
                                      "özelliklerini (güç, zeka, beceri, "
                                      "karizma gibi) kalıcı olarak artırır. "
                                      "Bu geliştirmeler, hem üzerinizde giyili "
                                      "olan ekipmanlardan hem de karakterinizin "
                                      "ırkına özel başlangıç statülerinden "
                                      "etkilenerek çalışır. Yani bu sistem, "
                                      "karakterinizin genel "
                                      "gücüne doğrudan katkı sağlar.\n\n"
                                      "    Statü geliştirmeleri, Yetenek Puanı "
                                      "kullanılarak yapılır. Her bir geliştirme "
                                      "size +5 Statü Puanı kazandırır. Ancak "
                                      "dikkatli olun: Bu puanlar Sıfırlama "
                                      "Kartı olmadan geri alınamaz. "
                                      "Dağıtım yapmadan önce iyi "
                                      "düşünmeniz faydalı olacaktır.",
                                );
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.question_circle_fill,
                                size: width * 0.07,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.06),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.075),
                          Text(
                            "Güç Statü Bonusu: ",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.043, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                  ),
                                  child: CircleAvatar(
                                    radius: width * 0.02,
                                    backgroundColor: index <
                                            (widget.character.strengthPlus / 5)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.strengthPlus < 25) {
                                  if (widget.character.skillPoints > 0) {
                                    setState(() {
                                      widget.character.strengthPlus += 5;
                                      widget.character.skillPoints--;
                                      widget.character.saveCharacterData();
                                    });
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Yetenek Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Bu statü daha fazla geliştirilemez!",
                                    Colors.red,
                                  );
                                }
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.plus_circle_fill,
                                size: width * 0.07,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.15),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.075),
                          Text(
                            "Zeka Statü Bonusu: ",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.043, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                  ),
                                  child: CircleAvatar(
                                    radius: width * 0.02,
                                    backgroundColor: index <
                                            (widget.character.intelligencePlus /
                                                5)
                                        ? Colors.purple
                                        : Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.intelligencePlus < 25) {
                                  if (widget.character.skillPoints > 0) {
                                    setState(() {
                                      widget.character.intelligencePlus += 5;
                                      widget.character.skillPoints--;
                                      widget.character.saveCharacterData();
                                    });
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Yetenek Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Bu statü daha fazla geliştirilemez!",
                                    Colors.red,
                                  );
                                }
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.plus_circle_fill,
                                size: width * 0.07,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.15),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.075),
                          Text(
                            "Beceri Statü Bonusu: ",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.043, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                  ),
                                  child: CircleAvatar(
                                    radius: width * 0.02,
                                    backgroundColor: index <
                                            (widget.character.dexterityPlus / 5)
                                        ? Colors.cyan
                                        : Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.dexterityPlus < 25) {
                                  if (widget.character.skillPoints > 0) {
                                    setState(() {
                                      widget.character.dexterityPlus += 5;
                                      widget.character.skillPoints--;
                                      widget.character.saveCharacterData();
                                    });
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Yetenek Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Bu statü daha fazla geliştirilemez!",
                                    Colors.red,
                                  );
                                }
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.plus_circle_fill,
                                size: width * 0.07,
                                color: Colors.cyan.shade600,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.15),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.075),
                          Text(
                            "Karizma Statü Bonusu: ",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.043, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                  ),
                                  child: CircleAvatar(
                                    radius: width * 0.02,
                                    backgroundColor: index <
                                            (widget.character.charismaPlus / 5)
                                        ? Colors.orangeAccent
                                        : Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.charismaPlus < 25) {
                                  if (widget.character.skillPoints > 0) {
                                    setState(() {
                                      widget.character.charismaPlus += 5;
                                      widget.character.skillPoints--;
                                      widget.character.saveCharacterData();
                                    });
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Yetenek Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Bu statü daha fazla geliştirilemez!",
                                    Colors.red,
                                  );
                                }
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.plus_circle_fill,
                                size: width * 0.07,
                                color: Colors.orangeAccent.shade700,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.15),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.06),
                          Text(
                            "Üretim Geliştirmeleri:",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.05, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                showExtraInfo(
                                  "Üretim Verimliliği?",
                                  "    Bu geliştirme, üretim sisteminde kullanılan "
                                      "malzemeleri daha verimli kullanmanızı "
                                      "sağlar. Yani, bir ürünü üretmek için "
                                      "normalde gereken malzeme miktarı azalır. "
                                      "Böylece daha az kaynakla aynı ürünü "
                                      "üretebilirsiniz.\n\n"
                                      "    Üretim geliştirmesi, Yetenek Puanı "
                                      "harcanarak yapılır. Her bir Yetenek Puanı, "
                                      "üretim verimliliğini %5 artırır. "
                                      "En fazla 10 puan harcayarak %50’ye kadar "
                                      "verimlilik sağlayabilirsiniz. Bu da "
                                      "üretimde maksimum yarı yarıya malzeme "
                                      "tasarrufu anlamına gelir. Ancak unutmayın: "
                                      "Verdiğiniz puanlar kalıcıdır ve Sıfırlama "
                                      "Kartı kullanmadan geri alınamaz. Bu yüzden "
                                      "üretim tarzınıza uygun şekilde dikkatli "
                                      "seçim yapmanız önemlidir.",
                                );
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.question_circle_fill,
                                size: width * 0.07,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.06),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.075),
                          Text(
                            "Üretim Verimliliği: ",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.043, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "%",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.043, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          Text(
                            "${widget.character.productEfficiency}",
                            style: baseNumberStyle,
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          SizedBox(width: width * 0.02),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                if (widget.character.productEfficiency < 50) {
                                  if (widget.character.skillPoints > 0) {
                                    setState(() {
                                      widget.character.productEfficiency += 5;
                                      widget.character.skillPoints--;
                                      widget.character.saveCharacterData();
                                    });
                                  } else {
                                    bottomAlert(
                                      "Yeteri miktarda Yetenek Puanı yok!",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  bottomAlert(
                                    "Verimlilik daha fazla geliştirilemez!",
                                    Colors.red,
                                  );
                                }
                              },
                              customBorder: const CircleBorder(),
                              child: Icon(
                                CupertinoIcons.plus_circle_fill,
                                size: width * 0.07,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.15),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.2),
                ],
              ),
            ),
          ),
          if (!isReadyForView)
            Container(
              width: width,
              height: height,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/backgrounds/primary/general_page_bg.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/icons/logos/app_name.png',
                          width: width * 0.5,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: height * 0.05),
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        SizedBox(height: height * 0.05),
                        Text(
                          "Yükleniyor...",
                          style: baseTextStyle.copyWith(
                            fontSize: width * 0.05,
                            color: Colors.black87,
                            shadows: [
                              Shadow(
                                blurRadius: 3,
                                color: Colors.white.withOpacity(0.5),
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/* void playButtonSound() async {
    await _effectPlayer.setVolume(effectSesSeviyesi);
    await _effectPlayer.play(
      AssetSource('sounds/effect_sounds/button_sound.mp3'),
    );
   } */
