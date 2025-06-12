import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class ProductionPage extends StatefulWidget {
  final Character character;

  const ProductionPage({
    super.key,
    required this.character,
  });

  @override
  _ProductionPageState createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage>
    with WidgetsBindingObserver {
  bool isReadyForView = false;
  int healthPotRequired1 = 1;
  int healthPotRequired2 = 100;
  int manaPotRequired1 = 1;
  int manaPotRequired2 = 200;
  final AudioPlayer _effectPlayer = AudioPlayer();
  double effectSesSeviyesi = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    toResultRequired();
    checkReadyForView();
    loadVolumeSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _effectPlayer.dispose();
    super.dispose();
  }

  void toResultRequired() {
    setState(() {
      if (widget.character.productEfficiency > 0) {
        healthPotRequired2 = healthPotRequired2 -
            (healthPotRequired2 * widget.character.productEfficiency ~/ 100);
        manaPotRequired2 = manaPotRequired2 -
            (manaPotRequired2 * widget.character.productEfficiency ~/ 100);
      }
    });
  }

  void checkReadyForView() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isReadyForView = true;
      if (widget.character.firstEntryProductionPage == 0) {
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
                      "Üretim Sayfası",
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
                              "Burası, maceralarınızda size yardımı dokunucak eşyaları "
                              "ürettiğiniz ve bunları işlediğiniz yer. Yolculuk "
                              "boyunca elde ettiğiniz hammadde ve kaynakları "
                              "kullanarak kilidini açtığınız eşyaların ve ürünlerin "
                              "üretimlerini buradan gerçekleştirebilirsiniz. "
                              "Üretim sayfası, size maceralarınızı daha güçlü bir "
                              "şekilde devam ettirmenize önayak olur.",
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
                        widget.character.firstEntryProductionPage++;
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Üretim Metrikleri",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.lab_flask_solid,
                          color: Colors.cyan,
                          size: width * 0.06,
                        ),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.black87,
                          size: width * 0.04,
                        ),
                        Text(
                          " Boş Şişe Miktarı",
                          style: baseNumberStyle.copyWith(
                              fontSize: width * 0.0425),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.drop_fill,
                          color: Colors.purple,
                          size: width * 0.06,
                        ),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.black87,
                          size: width * 0.04,
                        ),
                        Text(
                          " Katalen Miktarı",
                          style: baseNumberStyle.copyWith(
                              fontSize: width * 0.0425),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.bubble_chart,
                          color: Colors.green,
                          size: width * 0.06,
                        ),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.black87,
                          size: width * 0.04,
                        ),
                        Text(
                          " Organik Parça Miktarı",
                          style: baseNumberStyle.copyWith(
                              fontSize: width * 0.0425),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
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
                        'Metrikleri Kapat',
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
    );
    TextStyle baseNumberStyle = const TextStyle(
      fontFamily: "LibreBaskerville-Bold",
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
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        'Üretim',
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
                          CupertinoIcons.lab_flask_solid,
                          color: Colors.cyan,
                          size: width * 0.06,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          "${widget.character.bosSise}",
                          style: baseNumberStyle.copyWith(
                              fontSize: width * 0.04, color: Colors.black87),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        SizedBox(width: width * 0.06),
                        Icon(
                          CupertinoIcons.drop_fill,
                          color: Colors.purple,
                          size: width * 0.06,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          "${widget.character.katalen}",
                          style: baseNumberStyle.copyWith(
                              fontSize: width * 0.04, color: Colors.black87),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        SizedBox(width: width * 0.06),
                        Icon(
                          Icons.bubble_chart,
                          color: Colors.green,
                          size: width * 0.06,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          "${widget.character.organikParcalar}",
                          style: baseNumberStyle.copyWith(
                              fontSize: width * 0.04, color: Colors.black87),
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
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.06,
                    right: width * 0.06,
                    top: height * 0.025,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Can Potu Üretimi",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.05, color: Colors.black87),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.01),
                      Container(
                        width: width * 0.5,
                        height: width * 0.5,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/backgrounds/secondary/product_bg.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(width * 0.055),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/icons/buttons/can_potu_arkaplansiz.png",
                                  fit: BoxFit.fill,
                                  width: width * 0.125,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: height * 0.01),
                                      Text(
                                        "Gereksinimler:",
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.0275,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.lab_flask_solid,
                                            color: Colors.cyan,
                                            size: width * 0.05,
                                          ),
                                          Text(
                                            ": $healthPotRequired1",
                                            style: baseNumberStyle.copyWith(
                                                fontSize: width * 0.035,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            textScaler:
                                                const TextScaler.linear(1),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.0025),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.bubble_chart,
                                            color: Colors.green,
                                            size: width * 0.05,
                                          ),
                                          Text(
                                            ": $healthPotRequired2",
                                            style: baseNumberStyle.copyWith(
                                                fontSize: width * 0.035,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            textScaler:
                                                const TextScaler.linear(1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: width * 0.02,
                                  bottom: height * 0.01,
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (widget.character.bosSise >=
                                            healthPotRequired1 &&
                                        widget.character.organikParcalar >=
                                            healthPotRequired2) {
                                      setState(() {
                                        widget.character.bosSise -=
                                            healthPotRequired1;
                                        widget.character.organikParcalar -=
                                            healthPotRequired2;
                                        widget.character.healthPot++;
                                        widget.character.xp += 50;
                                        widget.character.totalEarnedXP += 50;
                                        widget.character.saveCharacterData();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Can potu başarıyla üretildi!",
                                            style: baseNumberStyle.copyWith(
                                                fontSize: width * 0.035,
                                                color: Colors.black87),
                                            textAlign: TextAlign.left,
                                            textScaler:
                                                const TextScaler.linear(1),
                                          ),
                                          duration: const Duration(
                                            seconds: 2,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.green,
                                          margin: EdgeInsets.only(
                                            left: width * 0.01,
                                            right: width * 0.01,
                                            bottom: height * 0.01,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Yeterli malzeme yok!",
                                            style: baseNumberStyle.copyWith(
                                                fontSize: width * 0.035,
                                                color: Colors.black87),
                                            textAlign: TextAlign.left,
                                            textScaler:
                                                const TextScaler.linear(1),
                                          ),
                                          duration: const Duration(
                                            seconds: 2,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.red,
                                          margin: EdgeInsets.only(
                                            left: width * 0.01,
                                            right: width * 0.01,
                                            bottom: height * 0.01,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.gear_alt_fill,
                                    color: Colors.black87,
                                  ),
                                  label: Text(
                                    "Üret",
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.04,
                                        color: Colors.black87),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                      horizontal: width * 0.025,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.025),
                      Text(
                        "Aksiyon Potu Üretimi",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.05, color: Colors.black87),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.01),
                      Container(
                        width: width * 0.5,
                        height: width * 0.5,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/backgrounds/secondary/product_bg.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(width * 0.055),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/icons/buttons/mana_potu_arkaplansiz.png",
                                  fit: BoxFit.fill,
                                  width: width * 0.125,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: height * 0.01),
                                      Text(
                                        "Gereksinimler:",
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.0275,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.lab_flask_solid,
                                            color: Colors.cyan,
                                            size: width * 0.05,
                                          ),
                                          Text(
                                            ": $manaPotRequired1",
                                            style: baseNumberStyle.copyWith(
                                                fontSize: width * 0.035,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            textScaler:
                                                const TextScaler.linear(1),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.0025),
                                      Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.drop_fill,
                                            color: Colors.purple,
                                            size: width * 0.05,
                                          ),
                                          Text(
                                            ": $manaPotRequired2",
                                            style: baseNumberStyle.copyWith(
                                                fontSize: width * 0.035,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            textScaler:
                                                const TextScaler.linear(1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: width * 0.02,
                                  bottom: height * 0.01,
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (widget.character.bosSise >=
                                            manaPotRequired1 &&
                                        widget.character.katalen >=
                                            manaPotRequired2) {
                                      setState(() {
                                        widget.character.bosSise -=
                                            manaPotRequired1;
                                        widget.character.katalen -=
                                            manaPotRequired2;
                                        widget.character.manaPot++;
                                        widget.character.xp += 50;
                                        widget.character.totalEarnedXP += 50;
                                        widget.character.saveCharacterData();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Aksiyon potu başarıyla üretildi!",
                                            style: baseNumberStyle.copyWith(
                                                fontSize: width * 0.035,
                                                color: Colors.black87),
                                            textAlign: TextAlign.left,
                                            textScaler:
                                                const TextScaler.linear(1),
                                          ),
                                          duration: const Duration(
                                            seconds: 2,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.green,
                                          margin: EdgeInsets.only(
                                            left: width * 0.01,
                                            right: width * 0.01,
                                            bottom: height * 0.01,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Yeterli malzeme yok!",
                                            style: baseNumberStyle.copyWith(
                                                fontSize: width * 0.035,
                                                color: Colors.black87),
                                            textAlign: TextAlign.left,
                                            textScaler:
                                                const TextScaler.linear(1),
                                          ),
                                          duration: const Duration(
                                            seconds: 2,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.red,
                                          margin: EdgeInsets.only(
                                            left: width * 0.01,
                                            right: width * 0.01,
                                            bottom: height * 0.01,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.gear_alt_fill,
                                    color: Colors.black87,
                                  ),
                                  label: Text(
                                    "Üret",
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.04,
                                        color: Colors.black87),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                      horizontal: width * 0.025,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
