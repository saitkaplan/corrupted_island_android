import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:corrupted_island_android/process_file/google_ads.dart';
import 'package:corrupted_island_android/process_file/object_items.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class MarketPage extends StatefulWidget {
  final Character character;

  const MarketPage({
    super.key,
    required this.character,
  });

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> with WidgetsBindingObserver {
  late GoogleAds _googleAds;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool isReadyForView = false;
  final AudioPlayer _effectPlayer = AudioPlayer();
  double effectSesSeviyesi = 1.0;

  @override
  void initState() {
    _googleAds = GoogleAds();
    _googleAds.loadInterstitialAd(
      showAfterLoad: false,
      onAdClosed: () {},
    );
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkConnectivity();
    checkReadyForView();
    loadVolumeSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _effectPlayer.dispose();
    super.dispose();
  }

  Future<void> loadVolumeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      effectSesSeviyesi = prefs.getDouble('effectSesSeviyesi') ?? 1.0;
    });
    _effectPlayer.setVolume(effectSesSeviyesi);
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult;
    });
  }

  void checkReadyForView() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isReadyForView = true;
      if (widget.character.firstEntryMarketPage == 0) {
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
                      "Gizemli Market",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Burası, maceranız boyunca işinize yarayacak değerli "
                              "ödüller kazanabileceğiniz market sayfası! Bu "
                              "sayfada, reklamları izleyerek rastgele şansa "
                              "bağlı ödüller kazanabilir ve oyun deneyiminizi "
                              "zenginleştirebilirsiniz. Her izlenen reklam, "
                              "size sürpriz hediyeler ve nadir eşyalar getirme "
                              "şansı sunar.",
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
                        widget.character.firstEntryMarketPage++;
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

  void _generateReward() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
    );
    TextStyle baseNumberStyle = const TextStyle(
      fontFamily: "LibreBaskerville-Bold",
    );

    int randomValue = Random().nextInt(10000) + 1;
    String rewardMessage = "";

    if (randomValue <= 3000) {
      widget.character.gold += 10;
      rewardMessage = "Tebrikler! 10 Altın kazandınız.";
    } else if (randomValue > 3000 && randomValue <= 3025) {
      switch (widget.character.characterClass) {
        case 'Barbar':
          widget.character.inventory.addItem(odulBalta);
          break;
        case 'Paladin':
          widget.character.inventory.addItem(odulBalta);
          break;
        case 'Hırsız':
          widget.character.inventory.addItem(odulArbalet);
          break;
        case 'Korucu':
          widget.character.inventory.addItem(odulArbalet);
          break;
        case 'Büyücü':
          widget.character.inventory.addItem(odulAsa);
          break;
      }
      rewardMessage = "Efsanevi! En büyük ödüllerden birini kazandınız!"
          "\n\nÇok özel bir Birincil Silah kazandınız.";
    } else if (randomValue > 3025 && randomValue <= 5025) {
      widget.character.gold += 25;
      rewardMessage = "Tebrikler! 25 Altın kazandınız.";
    } else if (randomValue > 5025 && randomValue <= 5050) {
      widget.character.inventory.addItem(odulZirh);
      rewardMessage = "Efsanevi! En büyük ödüllerden birini kazandınız!"
          "\n\nÇok özel bir Zırh kazandınız.";
    } else if (randomValue > 5050 && randomValue <= 6550) {
      widget.character.healthPot += 1;
      rewardMessage = "Tebrikler! 1 Can Potu kazandınız.";
    } else if (randomValue > 6550 && randomValue <= 6575) {
      widget.character.inventory.addItem(odulTilsimTier2);
      rewardMessage = "Efsanevi! En büyük ödüllerden birini kazandınız!"
          "\n\nÇok özel bir Tılsım kazandınız.";
    } else if (randomValue > 6575 && randomValue <= 8075) {
      widget.character.manaPot += 1;
      rewardMessage = "Tebrikler! 1 Aksiyon Potu kazandınız.";
    } else if (randomValue > 8075 && randomValue <= 8100) {
      switch (widget.character.characterClass) {
        case 'Barbar':
          widget.character.inventory.addItem(odulKalkan);
          break;
        case 'Paladin':
          widget.character.inventory.addItem(odulKalkan);
          break;
        case 'Hırsız':
          widget.character.inventory.addItem(odulBicak);
          break;
        case 'Korucu':
          widget.character.inventory.addItem(odulBicak);
          break;
        case 'Büyücü':
          widget.character.inventory.addItem(odulRunik);
          break;
      }
      rewardMessage = "Efsanevi! En büyük ödüllerden birini kazandınız!"
          "\n\nÇok özel bir İkincil Silah kazandınız.";
    } else if (randomValue > 8100 && randomValue <= 9100) {
      widget.character.manaPot += 1;
      widget.character.healthPot += 1;
      rewardMessage = "Harika! Orta büyüklükte ödül kazandınız."
          "\n\nBirer adet Can ve Aksiyon Potu kazandınız.";
    } else if (randomValue > 9100 && randomValue <= 9150) {
      int littleRandom = Random().nextInt(4) + 1;
      switch (littleRandom) {
        case 1:
          widget.character.inventory.addItem(randomOdulMigferTier1);
          break;
        case 2:
          widget.character.inventory.addItem(randomOdulZirhTier1);
          break;
        case 3:
          widget.character.inventory.addItem(randomOdulEldivenTier1);
          break;
        case 4:
          widget.character.inventory.addItem(randomOdulAyakkabiTier1);
          break;
      }
      rewardMessage = "Muhteşem! Epik ödül kazandınız."
          "\n\nÖzel bir Savunma Techizatı kazandınız.";
    } else if (randomValue > 9150 && randomValue <= 9650) {
      widget.character.luckCards += 1;
      rewardMessage = "Şanslısınız! Büyük ödül kazandınız."
          "\n\n1 adet Şans Kartı kazandınız.";
    } else if (randomValue > 9650 && randomValue <= 9700) {
      widget.character.inventory.addItem(odulTilsimTier1);
      rewardMessage = "Muhteşem! Epik ödül kazandınız."
          "\n\nÖzel bir Tılsım kazandınız.";
    } else if (randomValue > 9700 && randomValue <= 9900) {
      widget.character.luckCards += 2;
      rewardMessage = "Şanslısınız! Büyük ödül kazandınız."
          "\n\n2 adet Şans Kartı kazandınız.";
    } else if (randomValue > 9900 && randomValue <= 10000) {
      widget.character.luckCards += 5;
      rewardMessage = "Muhteşem! Epik ödül kazandınız."
          "\n\n5 adet Şans Kartı kazandınız.";
    }
    widget.character.saveCharacterData();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                      "Ödül Kazandınız!",
                      style: baseTextStyle.copyWith(
                          fontSize: width * 0.065, color: Colors.black87),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      rewardMessage,
                      style: baseNumberStyle.copyWith(
                          fontSize: width * 0.04, color: Colors.black87),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      "Destek olduğunuz için teşekkür ederiz.",
                      style: baseNumberStyle.copyWith(
                          fontSize: width * 0.04, color: Colors.black87),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
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
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Mükemmel',
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

  void buttonKnowledge() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = const TextStyle(
      color: Colors.black87,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
    );
    TextStyle baseNumberStyle = const TextStyle(
      color: Colors.black87,
      fontFamily: "LibreBaskerville-Bold",
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
                      "Ödül Oranları!",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      "%0.25: Çok özel bir Tılsım\n"
                      "%0.25: Çok özel bir Zırh\n"
                      "%0.25: Çok özel bir Birincil Silah\n"
                      "%0.25: Çok özel bir İkincil Silah\n"
                      "%0.5: Özel bir Savunma Techizatı\n"
                      "%0.5: Özel bir Tılsım\n"
                      "%1: 5 Şans Kartı\n"
                      "%2: 2 Şans Kartı\n"
                      "%5: 1 Şans Kartı\n"
                      "%10: 1'er tane Can ve Aksiyon Potu\n"
                      "%15: 1 Can Potu\n"
                      "%15: 1 Aksiyon Potu\n"
                      "%20: 25 Altın\n"
                      "%30: 10 Altın",
                      style: baseNumberStyle.copyWith(fontSize: width * 0.03),
                      textAlign: TextAlign.left,
                      textScaler: const TextScaler.linear(1),
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

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/backgrounds/primary/general_page_bg.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: statusBarHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: width * 0.06),
                        Text(
                          "Gizemli Market",
                          style: baseTextStyle.copyWith(
                              fontSize: width * 0.065, color: Colors.black87),
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
                              widget.character.saveCharacterData();
                              Navigator.of(context).pop();
                            },
                            customBorder: const CircleBorder(),
                            child: Transform.rotate(
                              angle: pi / 4,
                              child: Icon(
                                Icons.add_circle,
                                size: width * 0.1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.06),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.card_membership,
                          color: Colors.red,
                          size: width * 0.06,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          "${widget.character.luckCards}",
                          style: baseNumberStyle,
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        SizedBox(width: width * 0.06),
                        Icon(
                          Icons.monetization_on,
                          color: Colors.yellow[900],
                          size: width * 0.06,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          "${widget.character.gold}",
                          style: baseNumberStyle,
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        SizedBox(width: width * 0.06),
                        Icon(
                          CupertinoIcons.drop_fill,
                          color: Colors.red,
                          size: width * 0.06,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          "${widget.character.healthPot}",
                          style: baseNumberStyle,
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        SizedBox(width: width * 0.06),
                        Icon(
                          CupertinoIcons.drop_fill,
                          color: Colors.blue,
                          size: width * 0.06,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          "${widget.character.manaPot}",
                          style: baseNumberStyle,
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                (_connectivityResult == ConnectivityResult.none)
                    ? Column(
                        children: [
                          SizedBox(height: height * 0.3),
                          Text(
                            "İnternet bağlantınız bulunmamaktadır!",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.065, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(height: height * 0.02),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.greenAccent.shade700,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.2),
                              highlightColor: Colors.black.withOpacity(0.1),
                              onTap: () {
                                _googleAds.loadInterstitialAd(
                                  showAfterLoad: true,
                                  onAdClosed: _generateReward,
                                );
                              },
                              borderRadius: BorderRadius.circular(35),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.02,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.cube_box_fill,
                                      size: width * 0.075,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: width * 0.05),
                                    Text(
                                      "Rastgele değerli bir ödül için...\n"
                                      "REKLAM İZLE!",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.035,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    SizedBox(width: width * 0.05),
                                    InkWell(
                                      splashColor:
                                          Colors.black.withOpacity(0.2),
                                      highlightColor:
                                          Colors.black.withOpacity(0.1),
                                      onTap: () {
                                        buttonKnowledge();
                                      },
                                      borderRadius: BorderRadius.circular(35),
                                      child: Padding(
                                        padding: EdgeInsets.all(width * 0.01),
                                        child: Icon(
                                          Icons.help_outline,
                                          color: Colors.white,
                                          size: width * 0.085,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.1),
                          Text(
                            "Market güncellemesi\nYakında yapılacaktır...",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.05, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
              ],
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
