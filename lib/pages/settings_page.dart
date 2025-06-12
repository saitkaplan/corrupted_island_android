import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final AudioPlayer effectPlayer;

  const SettingsPage({
    super.key,
    required this.audioPlayer,
    required this.effectPlayer,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  bool isReadyForView = false;
  double musicSesSeviyesi = 0.5;
  double effectSesSeviyesi = 1.0;
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadVolumeSettings();
    checkReadyForView();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void checkReadyForView() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isReadyForView = true;
    });
  }

  Future<void> loadVolumeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      musicSesSeviyesi = prefs.getDouble('musicSesSeviyesi') ?? 0.5;
      effectSesSeviyesi = prefs.getDouble('effectSesSeviyesi') ?? 1.0;
    });
    audioPlayer.setVolume(musicSesSeviyesi);
    _effectPlayer.setVolume(effectSesSeviyesi);
  }

  Future<void> updateVolumeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicSesSeviyesi', musicSesSeviyesi);
    await prefs.setDouble('effectSesSeviyesi', effectSesSeviyesi);
  }

  void onMusicVolumeChanged(double value) {
    setState(() {
      musicSesSeviyesi = value;
    });
    widget.audioPlayer.setVolume(musicSesSeviyesi);
    updateVolumeSettings();
  }

  void onEffectVolumeChanged(double value) {
    setState(() {
      effectSesSeviyesi = value;
    });
    widget.effectPlayer.setVolume(effectSesSeviyesi);
    updateVolumeSettings();
  }

  void _resetGamePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('playerName');
    await prefs.remove('race');
    await prefs.remove('class');
    await prefs.remove('imagePath');
    await prefs.remove('level');
    await prefs.remove('xp');
    await prefs.remove('maxXp');
    await prefs.remove('health');
    await prefs.remove('maxHealth');
    await prefs.remove('magicBar');
    await prefs.remove('gold');
    await prefs.remove('luckCards');
    await prefs.remove('resetCards');
    await prefs.remove('healthPot');
    await prefs.remove('manaPot');
    await prefs.remove('daily');
    await prefs.remove('dailyController');
    await prefs.remove('skillPoints');
    await prefs.remove('hizPoints');
    await prefs.remove('katalen');
    await prefs.remove('kristalKalp');
    await prefs.remove('organikParcalar');
    await prefs.remove('bosSise');
    await prefs.remove('productController');
    await prefs.remove('defeatedEnemies');
    await prefs.remove('criticalChoice');
    await prefs.remove('totalChoice');
    await prefs.remove('purchasedItem');
    await prefs.remove('totalDamageToEnemies');
    await prefs.remove('entryShop');
    await prefs.remove('totalEarnedXP');
    await prefs.remove('usesLuckCards');
    await prefs.remove('spentMoney');
    await prefs.remove('totalSkillPoints');
    await prefs.remove('totalHizPoints');
    await prefs.remove('firstEntryGamePage');
    await prefs.remove('firstEntryStatusPage');
    await prefs.remove('firstEntryMarketPage');
    await prefs.remove('firstEntryShopPage');
    await prefs.remove('firstEntryWarPage');
    await prefs.remove('firstEntryDailyPage');
    await prefs.remove('firstEntryProductionPage');
    await prefs.remove('firstEntryUpgradePage');
    await prefs.remove('isReadyOpenInventory');
    await prefs.remove('firstSkillLock');
    await prefs.remove('secondSkillLock');
    await prefs.remove('thirdSkillLock');
    await prefs.remove('fourthSkillLock');
    await prefs.remove('fifthSkillLock');
    await prefs.remove('firstSkillCooldown');
    await prefs.remove('secondSkillCooldown');
    await prefs.remove('thirdSkillCooldown');
    await prefs.remove('fourthSkillCooldown');
    await prefs.remove('fifthSkillCooldown');
    await prefs.remove('strengthPlus');
    await prefs.remove('intelligencePlus');
    await prefs.remove('dexterityPlus');
    await prefs.remove('charismaPlus');
    await prefs.remove('productEfficiency');
    await prefs.remove('equippedItems');
    await prefs.remove('inventoryItems');

    await prefs.remove("mevcutHikayeNoktası");
  }

  void showAttentionAndInfo(bool isInfo, String title, String body) {
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
                      title,
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
                              body,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isInfo)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.withOpacity(0.25),
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
                              "Değilim!",
                              style: baseNumberStyle.copyWith(
                                  fontSize: width * 0.0325),
                              textScaler: const TextScaler.linear(1),
                            ),
                          ),
                        if (!isInfo) SizedBox(width: width * 0.025),
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
                            if (!isInfo) {
                              _resetGamePreferences();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Karakter verileri silinmiştir!',
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.04),
                                    textAlign: TextAlign.left,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                ),
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            isInfo ? "Anladım" : "Eminim!",
                            style: baseNumberStyle.copyWith(
                                fontSize:
                                    isInfo ? width * 0.05 : width * 0.0325),
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                      ],
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
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 3,
          color: Colors.black87,
          offset: Offset(1, 1),
        ),
      ],
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/backgrounds/primary/settings_page_bg.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: statusBarHeight),
                Row(
                  children: [
                    SizedBox(width: width * 0.05),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.arrow_left_circle_fill,
                        size: width * 0.09,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      'Ayarlar',
                      style: baseTextStyle.copyWith(fontSize: width * 0.065),
                      textScaler: const TextScaler.linear(1),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.025,
                    left: width * 0.06,
                    right: width * 0.06,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "SES AYARLARI:",
                        style: baseTextStyle.copyWith(fontSize: width * 0.055),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Müzik Ses Seviyesi Ayarı:",
                        style: baseTextStyle.copyWith(fontSize: width * 0.045),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      Slider(
                        value: musicSesSeviyesi,
                        min: 0.0,
                        max: 1.0,
                        onChanged: onMusicVolumeChanged,
                        activeColor: Colors.green.shade600,
                        inactiveColor: Colors.white,
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Efekt ve Konuşma Ses Seviyesi Ayarı:",
                        style: baseTextStyle.copyWith(fontSize: width * 0.045),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      Slider(
                        value: effectSesSeviyesi,
                        min: 0.0,
                        max: 1.0,
                        onChanged: onEffectVolumeChanged,
                        activeColor: Colors.green.shade600,
                        inactiveColor: Colors.white,
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Oyun Kayıt Ayarı:",
                        style: baseTextStyle.copyWith(fontSize: width * 0.045),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.01),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red.shade700,
                        child: InkWell(
                          splashColor: Colors.black.withOpacity(0.2),
                          highlightColor: Colors.black.withOpacity(0.1),
                          onTap: () {
                            showAttentionAndInfo(
                              false,
                              "Dikkat!",
                              "Oyun ilerlemenizi, kayıtlı tüm envanter ve "
                                  "karakterinizi silmek istediğinize emin "
                                  "misiniz?",
                            );
                          },
                          borderRadius: BorderRadius.circular(35),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.0075,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.rotate(
                                  angle: pi / 4,
                                  child: Icon(
                                    Icons.add,
                                    size: width * 0.1,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: width * 0.05),
                                Text(
                                  "Kayıtlı karakter verilerini sil!",
                                  style: baseTextStyle.copyWith(
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                                SizedBox(width: width * 0.05),
                                InkWell(
                                  splashColor: Colors.black.withOpacity(0.2),
                                  highlightColor: Colors.black.withOpacity(0.1),
                                  onTap: () {
                                    showAttentionAndInfo(
                                      true,
                                      "Bilgilendirme!",
                                      "Bu buton vasıtasıyla oyun içerisindeki "
                                          "ilerlemenizi, karakterinizi ve buna "
                                          "bağlı envanter, gelişim ve fazlasını "
                                          "sıfırlayabilirsiniz. Böylelikle oyun "
                                          "deneyimini sıfırdan en baştan "
                                          "deneyimleme şansına sahip "
                                          "olabilirsiniz.",
                                    );
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
                      'assets/images/backgrounds/primary/settings_page_bg.png',
                      fit: BoxFit.cover,
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
                          style: baseTextStyle.copyWith(fontSize: width * 0.05),
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
