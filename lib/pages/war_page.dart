import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/pages/market_page.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:corrupted_island_android/process_file/object_enemies.dart';
import 'package:corrupted_island_android/process_file/google_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class WarPage extends StatefulWidget {
  final Character character;
  final Enemy enemy;
  final int saldiriDegeri;
  final int savunmaDegeri;
  final int strength;
  final int intelligence;
  final int dexterity;
  final int charisma;

  const WarPage({
    super.key,
    required this.character,
    required this.enemy,
    required this.saldiriDegeri,
    required this.savunmaDegeri,
    required this.strength,
    required this.intelligence,
    required this.dexterity,
    required this.charisma,
  });

  @override
  _WarPageState createState() => _WarPageState();
}

class _WarPageState extends State<WarPage> with WidgetsBindingObserver {
  late int playerRoll;
  late int enemyRoll;
  int firstSkillCD = 0;
  int secondSkillCD = 0;
  int thirdSkillCD = 0;
  int fourthSkillCD = 0;
  int fifthSkillCD = 0;
  int playerAttack = 0;
  int enemyAttack = 0;
  late int spiritRoll;
  late int spiritAttack;
  late int halusinasyonRoll;
  late int halusinasyonEnemyRoll;
  bool isReadyForView = false;
  late GoogleAds _googleAds;

  late VideoPlayerController _controller;
  bool videoController = true;

  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer2 = AudioPlayer();
  final AudioPlayer _effectPlayer3 = AudioPlayer();
  final AudioPlayer _effectPlayer4 = AudioPlayer();
  final AudioPlayer _effectPlayer5 = AudioPlayer();
  final AudioPlayer _effectPlayer6 = AudioPlayer();
  final AudioPlayer _effectPlayer7 = AudioPlayer();
  final AudioPlayer _effectPlayer8 = AudioPlayer();
  final AudioPlayer _effectPlayer9 = AudioPlayer();
  final AudioPlayer _effectPlayer10 = AudioPlayer();

  bool isPlaying = false;
  bool isPaused = false;
  Duration? position;
  double musicSesSeviyesi = 0.5;
  double effectSesSeviyesi = 1.0;

  int diceResult = 0;
  String turnIndicator = "";
  String turnSkillIndicator = "İlk saldırı hakkı senin!";
  int turGecikmesi = 0;
  bool isRollDice = false;
  bool showDiceTurn = false;
  bool showDamage = false;
  bool isPlayerDice = false;
  bool showButton = false;
  bool ozelTurEffect = false;
  double playerOpacity = 0.0;
  double enemyOpacity = 0.0;
  int maxMagicBar = 0;

  bool tekrarTurKarakterde = false;
  int gucPatlamasiTuru = 0;
  int sarsilmazVucutTuru = 0;
  bool ozelZarDurum = false;
  bool secilmisIradeTuru = false;
  bool sasirtmacaTuru = false;
  int manipulasyonTuru = 0;
  bool hileliZarTuru = false;
  int zehirSaldirisiEtkisi = 0;
  int zehirSaldirisiTuru = 0;
  bool zehirSaldirisiEtkiDurumu = false;
  bool dengesizRuzgarTuru = false;
  bool ormaninYankisiTuru = false;
  int ormaninYankisiSayac = 0;
  bool yarininArzusuTuru = false;
  int yarininArzusuSayac = 0;
  int yildirimRuhuTuru = 0;
  bool halusinasyonTuru = false;
  List<int> halusinasyonRollList = [0];
  bool kaderinCagrisiTuru = false;

  final List<String> _diceVideos = [
    'assets/dices/dice_1.mp4',
    'assets/dices/dice_2.mp4',
    'assets/dices/dice_3.mp4',
    'assets/dices/dice_4.mp4',
    'assets/dices/dice_5.mp4',
    'assets/dices/dice_6.mp4',
    'assets/dices/dice_7.mp4',
    'assets/dices/dice_8.mp4',
    'assets/dices/dice_9.mp4',
    'assets/dices/dice_10.mp4',
    'assets/dices/dice_11.mp4',
    'assets/dices/dice_12.mp4',
    'assets/dices/dice_13.mp4',
    'assets/dices/dice_14.mp4',
    'assets/dices/dice_15.mp4',
    'assets/dices/dice_16.mp4',
    'assets/dices/dice_17.mp4',
    'assets/dices/dice_18.mp4',
    'assets/dices/dice_19.mp4',
    'assets/dices/dice_20.mp4',
  ];

  @override
  void initState() {
    _googleAds = GoogleAds();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (videoController == true) {
      videoDenetleyici();
    }
    showDamage = false;
    playerRoll = 0;
    enemyRoll = 0;
    diceResult = 0;
    gucPatlamasiTuru = 0;
    sarsilmazVucutTuru = 0;
    manipulasyonTuru = 0;
    zehirSaldirisiEtkisi = 0;
    zehirSaldirisiTuru = 0;
    yarininArzusuSayac = 0;
    yildirimRuhuTuru = 0;
    widget.enemy.health = widget.enemy.maxHealth;
    switch (widget.character.race) {
      case 'İnsan':
        maxMagicBar = 3;
        break;
      case 'Elf':
        maxMagicBar = 4;
        break;
      case 'Cüce':
        maxMagicBar = 2;
        break;
      case 'Yarı İnsan':
        maxMagicBar = 4;
        break;
      case 'Yarı Ork':
        maxMagicBar = 1;
        break;
      case 'Yarı Şeytan':
        maxMagicBar = 6;
        break;
    }
    loadAdData();
    checkReadyForView();
    loadVolumeSettings();
    playSound();
  }

  void loadAdData() {
    _googleAds.loadWarPageBannerAd(
      adLoaded: () {
        setState(() {});
      },
    );
  }

  void checkReadyForView() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isReadyForView = true;
      if (widget.character.firstEntryWarPage == 0) {
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
                      "Savaş Sayfası",
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
                              "Burası, hikayede karşılaştığınız düşmanlarla "
                              "yüzleştiğiniz savaş sayfası! Sıra tabanlı "
                              "savaş sistemine dayalı bu bölümde, sınıfınıza "
                              "özgü yetenekleri kullanarak düşmanlarınıza karşı "
                              "stratejik hamleler yapabilirsiniz. Her savaşta, "
                              "oyuncu ve düşman sırayla saldırır; ayrıca 20’lik "
                              "bir zar atılarak saldırının etkisi belirlenir. Bu "
                              "zar, savaşın gidişatını etkileyen şans faktörünü "
                              "yansıtır ve mücadeleye heyecan katar. Savaşlar, "
                              "oyunun en temel unsurlarından biri olup, kaderin "
                              "ve stratejinin el ele verdiği bir meydan okuma "
                              "sunar.\n\nİlk savaşınıza hazır mısınız? Yetenekler "
                              "hakkında ek bilgi almak için üzerlerine basılı "
                              "tutabilir, gerekliliklerini öğrenebilirsiniz. "
                              "İlk saldırınızı yapın ve oluşan olay döngüsünü "
                              "keşfedin...",
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
                        widget.character.firstEntryWarPage++;
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

  void bottomAlert(String text) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle bottomTextStyle = TextStyle(
      fontSize: width * 0.043,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black,
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
        backgroundColor: Colors.red,
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

  void videoDenetleyici() {
    _initializeVideoPlayer(_diceVideos[0]);
    videoController = false;
    showDamage = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    _effectPlayer.dispose();
    _effectPlayer2.dispose();
    _effectPlayer3.dispose();
    _effectPlayer4.dispose();
    _effectPlayer5.dispose();
    _effectPlayer6.dispose();
    _effectPlayer7.dispose();
    _effectPlayer8.dispose();
    _effectPlayer9.dispose();
    _effectPlayer10.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> loadVolumeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      musicSesSeviyesi = prefs.getDouble('musicSesSeviyesi') ?? 0.5;
      effectSesSeviyesi = prefs.getDouble('effectSesSeviyesi') ?? 1.0;
    });
    audioPlayer.setVolume(musicSesSeviyesi);
    _effectPlayer.setVolume(effectSesSeviyesi);
    _effectPlayer2.setVolume(effectSesSeviyesi);
    _effectPlayer3.setVolume(effectSesSeviyesi);
    _effectPlayer4.setVolume(effectSesSeviyesi);
    _effectPlayer5.setVolume(effectSesSeviyesi);
    _effectPlayer6.setVolume(effectSesSeviyesi);
    _effectPlayer7.setVolume(effectSesSeviyesi);
    _effectPlayer8.setVolume(effectSesSeviyesi);
    _effectPlayer9.setVolume(effectSesSeviyesi);
    _effectPlayer10.setVolume(effectSesSeviyesi);
  }

  void playDiceSound() async {
    await _effectPlayer.setVolume(effectSesSeviyesi);
    await _effectPlayer.play(
      AssetSource('sounds/effect_sounds/dice_sound.mp3'),
    );
  }

  void playArrowSound() async {
    await _effectPlayer3.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer3.play(
      AssetSource('sounds/effect_sounds/arrow_sound.mp3'),
    );
  }

  void playDaggerSound() async {
    await _effectPlayer4.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer4.play(
      AssetSource('sounds/effect_sounds/dagger_sound.mp3'),
    );
  }

  void playAxeSound() async {
    await _effectPlayer5.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer5.play(
      AssetSource('sounds/effect_sounds/axe_sound.mp3'),
    );
  }

  void playSwordSound() async {
    await _effectPlayer6.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer6.play(
      AssetSource('sounds/effect_sounds/sword_sound.mp3'),
    );
  }

  void playAttackSound() async {
    await _effectPlayer7.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer7.play(
      AssetSource('sounds/effect_sounds/attack_sound.mp3'),
    );
  }

  void playHeavyAttackSound() async {
    await _effectPlayer8.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer8.play(
      AssetSource('sounds/effect_sounds/heavy_attack_sound.mp3'),
    );
  }

  void playElectricityAttackSound() async {
    await _effectPlayer9.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer9.play(
      AssetSource('sounds/effect_sounds/electricity_sound.mp3'),
    );
  }

  void playUsePotSound() async {
    await _effectPlayer10.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer10.play(
      AssetSource('sounds/effect_sounds/use_pot.mp3'),
    );
  }

  void playSound() async {
    await audioPlayer.setVolume(musicSesSeviyesi);
    await audioPlayer.play(
      AssetSource('sounds/game_sounds/war_page_base_music.mp3'),
    );
    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer
          .play(AssetSource('sounds/game_sounds/war_page_base_music.mp3'));
    });
    setState(() {
      isPlaying = true;
      isPaused = false;
    });
  }

  void pauseSound() async {
    if (isPlaying) {
      position = await audioPlayer.getCurrentPosition();
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPaused = true;
      });
    }
  }

  void resumeSound() async {
    if (position != null) {
      await audioPlayer.seek(position!);
    }
    await audioPlayer.resume();
    setState(() {
      isPlaying = true;
      isPaused = false;
    });
  }

  void stopSound() async {
    setState(() {
      isPlaying = false;
      position = null;
    });
    await audioPlayer.stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused && isPlaying) {
      // Uygulama arka plana alındığında duraklatma işlemi
      pauseSound();
    } else if (state == AppLifecycleState.resumed && isPaused) {
      // Uygulama geri açıldığında kaldığı yerden devam ettirme işlemi
      resumeSound();
    }
  }

  // Zar videosu oynatma fonksiyonu
  void _initializeVideoPlayer(String videoAsset) {
    _controller = VideoPlayerController.asset(videoAsset)
      ..initialize().then((_) {
        setState(() {
          Future.delayed(const Duration(milliseconds: 200), () {
            _controller.play();
          });
        });
      })
      ..addListener(() {
        if (_controller.value.isCompleted) {
          setState(() {
            showDamage = true;
          });
        }
      });
  }

  // Zar sonuç belirleme işlemi
  int rollDice(bool isEnemy) {
    if (ozelZarDurum == true) {
      if (secilmisIradeTuru == true && isEnemy == false) {
        diceResult = Random().nextInt(5) + 16;
        secilmisIradeTuru = false;
        ozelZarDurum = false;
      } else if (manipulasyonTuru > 0 && isEnemy == true) {
        diceResult = Random().nextInt(5) + 1;
        manipulasyonTuru--;
        if (manipulasyonTuru == 0) {
          ozelZarDurum = false;
        }
      } else if (hileliZarTuru == true && isEnemy == false) {
        int diceResult1 = Random().nextInt(20) + 1;
        int diceResult2 = Random().nextInt(20) + 1;
        if (diceResult1 < diceResult2) {
          diceResult = diceResult2;
        } else {
          diceResult = diceResult1;
        }
        hileliZarTuru = false;
        ozelZarDurum = false;
      } else {
        diceResult = Random().nextInt(20) + 1;
        if (diceResult < 4 && isEnemy == false) {
          kaderinCagrisiTuru = false;
        }
      }
    } else {
      diceResult = Random().nextInt(20) + 1;
      if (diceResult < 4 && isEnemy == false) {
        kaderinCagrisiTuru = false;
      }
    }
    _controller.dispose();
    switch (diceResult) {
      case 1:
        _initializeVideoPlayer(_diceVideos[0]);
        break;
      case 2:
        _initializeVideoPlayer(_diceVideos[1]);
        break;
      case 3:
        _initializeVideoPlayer(_diceVideos[2]);
        break;
      case 4:
        _initializeVideoPlayer(_diceVideos[3]);
        break;
      case 5:
        _initializeVideoPlayer(_diceVideos[4]);
        break;
      case 6:
        _initializeVideoPlayer(_diceVideos[5]);
        break;
      case 7:
        _initializeVideoPlayer(_diceVideos[6]);
        break;
      case 8:
        _initializeVideoPlayer(_diceVideos[7]);
        break;
      case 9:
        _initializeVideoPlayer(_diceVideos[8]);
        break;
      case 10:
        _initializeVideoPlayer(_diceVideos[9]);
        break;
      case 11:
        _initializeVideoPlayer(_diceVideos[10]);
        break;
      case 12:
        _initializeVideoPlayer(_diceVideos[11]);
        break;
      case 13:
        _initializeVideoPlayer(_diceVideos[12]);
        break;
      case 14:
        _initializeVideoPlayer(_diceVideos[13]);
        break;
      case 15:
        _initializeVideoPlayer(_diceVideos[14]);
        break;
      case 16:
        _initializeVideoPlayer(_diceVideos[15]);
        break;
      case 17:
        _initializeVideoPlayer(_diceVideos[16]);
        break;
      case 18:
        _initializeVideoPlayer(_diceVideos[17]);
        break;
      case 19:
        _initializeVideoPlayer(_diceVideos[18]);
        break;
      case 20:
        _initializeVideoPlayer(_diceVideos[19]);
        break;
    }
    return diceResult;
  }

  // Zar efekti uygulama işlemi
  int applyNormalDiceEffect(int roll, int baseAttack) {
    if (roll == 1) {
      return 0;
    } else if (roll >= 2 && roll <= 5) {
      return baseAttack ~/ 2;
    } else if (roll >= 6 && roll <= 15) {
      return baseAttack;
    } else if (roll >= 16 && roll <= 19) {
      return (baseAttack * 1.5).toInt();
    } else if (roll == 20) {
      return baseAttack * 2;
    }
    return baseAttack;
  }

  // Düşman ve karakterdeki kırmızı animasyon efekti
  void animationBlood(String gelenAnimation) async {
    double opacity = 0.0;
    for (int k = 0; k < 2; k++) {
      opacity = 0.0;
      for (int i = 0; i < 20; i++) {
        await Future.delayed(const Duration(milliseconds: 15));
        opacity += 0.05;
        if (gelenAnimation == "playerOpacity") {
          playerOpacity = opacity;
        } else {
          enemyOpacity = opacity;
        }
        setState(() {});
        if (opacity >= 0.94) {
          for (int j = 0; j < 20; j++) {
            await Future.delayed(const Duration(milliseconds: 15));
            opacity -= 0.05;
            if (gelenAnimation == "playerOpacity") {
              playerOpacity = opacity;
            } else {
              enemyOpacity = opacity;
            }
            setState(() {});
            if (opacity <= 0.06) {
              opacity = 0.0;
              playerOpacity = 0.0;
              enemyOpacity = 0.0;
            }
          }
        }
      }
    }
  }

  // Can barı can azalma efekti
  Future<void> animateHealthReduction(
      {required bool isEnemy, required int damage}) async {
    if (!isEnemy) {
      animationBlood("playerOpacity");
    } else {
      animationBlood("");
    }
    for (int i = 0; i < damage; i++) {
      if ((isEnemy && widget.enemy.health <= 0) ||
          (!isEnemy && widget.character.health <= 0)) {
        break;
      }
      if (damage <= 25 && damage >= 0) {
        await Future.delayed(const Duration(milliseconds: 50));
      } else if (damage <= 50 && damage >= 26) {
        await Future.delayed(const Duration(milliseconds: 40));
      } else if (damage <= 75 && damage >= 51) {
        await Future.delayed(const Duration(milliseconds: 30));
      } else if (damage <= 100 && damage >= 76) {
        await Future.delayed(const Duration(milliseconds: 20));
      } else if (damage <= 200 && damage >= 101) {
        await Future.delayed(const Duration(milliseconds: 10));
      } else if (damage <= 500 && damage >= 201) {
        await Future.delayed(const Duration(milliseconds: 5));
      } else {
        await Future.delayed(const Duration(milliseconds: 3));
      }
      if (isEnemy) {
        widget.enemy.health--;
      } else {
        widget.character.health--;
      }
      setState(() {});
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Karakterin istatistiklerine göre saldırı değerini hesaplama fonksiyonu
  int calculatePlayerAttack() {
    int baseAttackValue = widget.saldiriDegeri;
    int totalEffect = 0;
    switch (widget.character.characterClass) {
      // Barbar strength değerinden tam varim almakta
      case 'Barbar':
        int strengthBonus = (baseAttackValue * (widget.strength / 100)).toInt();
        totalEffect += strengthBonus;

        int intelligenceBonus =
            (baseAttackValue * (((widget.intelligence) / 1.2) / 100)).toInt();
        totalEffect += intelligenceBonus;

        int dexterityBonus =
            (baseAttackValue * ((widget.dexterity / 1.2) / 100)).toInt();
        totalEffect += dexterityBonus;

        int charismaBonus =
            (baseAttackValue * ((widget.charisma / 1.2) / 100)).toInt();
        totalEffect += charismaBonus;

        baseAttackValue += totalEffect;
        break;

      // Paladin intelligence değerinden tam verim almakta
      case 'Paladin':
        int strengthBonus =
            (baseAttackValue * ((widget.strength / 1.2) / 100)).toInt();
        totalEffect += strengthBonus;

        int intelligenceBonus =
            (baseAttackValue * (widget.intelligence / 100)).toInt();
        totalEffect += intelligenceBonus;

        int dexterityBonus =
            (baseAttackValue * ((widget.dexterity / 1.2) / 100)).toInt();
        totalEffect += dexterityBonus;

        int charismaBonus =
            (baseAttackValue * ((widget.charisma / 1.2) / 100)).toInt();
        totalEffect += charismaBonus;

        baseAttackValue += totalEffect;
        break;

      // Hırsız charisma değerinden tam verim almakta
      case 'Hırsız':
        int strengthBonus =
            (baseAttackValue * ((widget.strength / 1.2) / 100)).toInt();
        totalEffect += strengthBonus;

        int intelligenceBonus =
            (baseAttackValue * ((widget.intelligence / 1.2) / 100)).toInt();
        totalEffect += intelligenceBonus;

        int dexterityBonus =
            (baseAttackValue * ((widget.dexterity / 1.2) / 100)).toInt();
        totalEffect += dexterityBonus;

        int charismaBonus = (baseAttackValue * (widget.charisma / 100)).toInt();
        totalEffect += charismaBonus;

        baseAttackValue += totalEffect;
        break;

      // Korucu dexterity değerinden tam verim almakta
      case 'Korucu':
        int strengthBonus =
            (baseAttackValue * ((widget.strength / 1.2) / 100)).toInt();
        totalEffect += strengthBonus;

        int intelligenceBonus =
            (baseAttackValue * ((widget.intelligence / 1.2) / 100)).toInt();
        totalEffect += intelligenceBonus;

        int dexterityBonus =
            (baseAttackValue * (widget.dexterity / 100)).toInt();
        totalEffect += dexterityBonus;

        int charismaBonus =
            (baseAttackValue * ((widget.charisma / 1.2) / 100)).toInt();
        totalEffect += charismaBonus;

        baseAttackValue += totalEffect;
        break;

      // Büyücü intelligence değerinden tam verim almakta
      case 'Büyücü':
        int strengthBonus =
            (baseAttackValue * ((widget.strength / 1.2) / 100)).toInt();
        totalEffect += strengthBonus;

        int intelligenceBonus =
            (baseAttackValue * (widget.intelligence / 100)).toInt();
        totalEffect += intelligenceBonus;

        int dexterityBonus =
            (baseAttackValue * ((widget.dexterity / 1.2) / 100)).toInt();
        totalEffect += dexterityBonus;

        int charismaBonus =
            (baseAttackValue * ((widget.charisma / 1.2) / 100)).toInt();
        totalEffect += charismaBonus;

        baseAttackValue += totalEffect;
        break;
    }
    if (gucPatlamasiTuru > 0) {
      baseAttackValue = (baseAttackValue * 1.5).toInt();
      gucPatlamasiTuru -= 1;
    }
    return max(0, baseAttackValue);
  }

  // Hasar azaltma fonksiyonu
  double calculateDamageReduction() {
    double baseDefenceValue = widget.savunmaDegeri / 100;
    if (sarsilmazVucutTuru > 0) {
      baseDefenceValue = (baseDefenceValue * 2);
      sarsilmazVucutTuru -= 1;
    }
    if (baseDefenceValue >= 1) {
      baseDefenceValue = 0.99;
    }
    return baseDefenceValue;
  }

  // Düşman saldırı fonksiyonu
  Future<void> enemyAttackAction() async {
    showDiceTurn = true;
    isPlayerDice = false;
    // Düşmanın dış etkensiz normal hasarı;
    if (sasirtmacaTuru == false &&
        zehirSaldirisiTuru == 0 &&
        dengesizRuzgarTuru == false &&
        halusinasyonTuru == false) {
      playDiceSound();
      enemyRoll = rollDice(true);
      enemyAttack = applyNormalDiceEffect(enemyRoll, widget.enemy.attackDamage);
      enemyAttack = max(
          0, enemyAttack - (enemyAttack * calculateDamageReduction()).toInt());
      await Future.delayed(const Duration(milliseconds: 3750));
      await animateHealthReduction(isEnemy: false, damage: enemyAttack);
      showTurnButton();
    }
    if (sasirtmacaTuru == true) {
      playDiceSound();
      enemyRoll = rollDice(true);
      if (enemyRoll > 15 || enemyRoll == 1) {
        setState(() {
          turnIndicator = "Düşman tüm hasarı kendine uyguladı!";
        });
        enemyAttack =
            applyNormalDiceEffect(enemyRoll, widget.enemy.attackDamage);
        await Future.delayed(const Duration(milliseconds: 3750));
        await animateHealthReduction(isEnemy: true, damage: enemyAttack);
        sasirtmacaTuru = false;
        showTurnButton();
      } else {
        int sasirtmacaHasari = widget.enemy.attackDamage ~/ 2;
        setState(() {
          turnIndicator = "Düşman hasarının yarısını kendisine uyguladı!";
        });
        enemyAttack = applyNormalDiceEffect(enemyRoll, sasirtmacaHasari);
        await Future.delayed(const Duration(milliseconds: 3750));
        await animateHealthReduction(isEnemy: true, damage: enemyAttack);
        await Future.delayed(const Duration(milliseconds: 1500));
        setState(() {
          isRollDice = false;
          showDamage = false;
          turnIndicator = "Yarısını da sana uyguladı!";
        });
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {
          showDamage = true;
        });
        enemyAttack = max(0,
            enemyAttack - (enemyAttack * calculateDamageReduction()).toInt());
        await Future.delayed(const Duration(milliseconds: 1000));
        await animateHealthReduction(isEnemy: false, damage: enemyAttack);
        sasirtmacaTuru = false;
        showTurnButton();
      }
    }
    if (zehirSaldirisiTuru > 0) {
      playDiceSound();
      enemyRoll = rollDice(true);
      enemyAttack = applyNormalDiceEffect(enemyRoll, widget.enemy.attackDamage);
      enemyAttack = max(
          0, enemyAttack - (enemyAttack * calculateDamageReduction()).toInt());
      await Future.delayed(const Duration(milliseconds: 3750));
      await animateHealthReduction(isEnemy: false, damage: enemyAttack);
      if (zehirSaldirisiEtkiDurumu) {
        zehirSaldirisiEtkisi = calculatePlayerAttack() ~/ 2;
        zehirSaldirisiEtkiDurumu = false;
      }
      if (zehirSaldirisiEtkisi != 0) {
        await Future.delayed(const Duration(milliseconds: 750));
        setState(() {
          isRollDice = false;
          showDamage = false;
          turnIndicator =
              "Zehir etkisi sayesinde düşman $zehirSaldirisiEtkisi puan "
              "zehir hasarı aldı!";
        });
        await animateHealthReduction(
            isEnemy: true, damage: zehirSaldirisiEtkisi);
        enemyIsDead();
      }
      zehirSaldirisiTuru--;
      showTurnButton();
    }
    if (dengesizRuzgarTuru == true) {
      if (playerRoll > 15 && playerRoll < 20) {
        playDiceSound();
        enemyRoll = rollDice(true);
        setState(() {
          turnIndicator = "Bu etkiyle beraber düşman kendisine hasar verdi!";
        });
        enemyAttack =
            applyNormalDiceEffect(enemyRoll, widget.enemy.attackDamage);
        await Future.delayed(const Duration(milliseconds: 3750));
        await animateHealthReduction(isEnemy: true, damage: enemyAttack);
        dengesizRuzgarTuru = false;
        showTurnButton();
      } else if (playerRoll == 20) {
        playDiceSound();
        enemyRoll = rollDice(true);
        setState(() {
          turnIndicator =
              "Bu etkiyle beraber düşman kendisine kritik hasar verdi!";
        });
        enemyAttack =
            applyNormalDiceEffect(enemyRoll, widget.enemy.attackDamage) * 2;
        await Future.delayed(const Duration(milliseconds: 3750));
        await animateHealthReduction(isEnemy: true, damage: enemyAttack);
        dengesizRuzgarTuru = false;
        showTurnButton();
      } else {
        playDiceSound();
        enemyRoll = rollDice(true);
        enemyAttack =
            applyNormalDiceEffect(enemyRoll, widget.enemy.attackDamage);
        enemyAttack = max(0,
            enemyAttack - (enemyAttack * calculateDamageReduction()).toInt());
        await Future.delayed(const Duration(milliseconds: 3750));
        await animateHealthReduction(isEnemy: false, damage: enemyAttack);
        dengesizRuzgarTuru = false;
        showTurnButton();
      }
    }
    if (halusinasyonTuru == true) {
      isRollDice = false;
      halusinasyonEnemyRoll = 0;
      while (halusinasyonRollList.contains(halusinasyonEnemyRoll)) {
        halusinasyonEnemyRoll = Random().nextInt(5) + 1;
      }
      if (halusinasyonRoll == halusinasyonEnemyRoll) {
        halusinasyonTuru = false;
        setState(() {
          turnIndicator = "Halüsinasyon başarısız oldu ve düşman saldırsı "
              "hedefini vurdu!";
        });
        await Future.delayed(const Duration(milliseconds: 1500));
        setState(() {
          isRollDice = true;
        });
        playDiceSound();
        enemyRoll = rollDice(true);
        enemyAttack =
            applyNormalDiceEffect(enemyRoll, widget.enemy.attackDamage);
        enemyAttack = max(0,
            enemyAttack - (enemyAttack * calculateDamageReduction()).toInt());
        await Future.delayed(const Duration(milliseconds: 3750));
        await animateHealthReduction(isEnemy: false, damage: enemyAttack);
        showTurnButton();
      } else {
        setState(() {
          turnIndicator = "Halüsinasyon başarılı oldu ve düşman saldırısı "
              "boşa gitti!";
        });
        await Future.delayed(const Duration(milliseconds: 1500));
        halusinasyonRollList.add(halusinasyonEnemyRoll);
        showTurnButton();
      }
    }
    if (widget.character.health < 1) {
      showResultDialog(
        "Kaybettin!\nOyun Bitti!\n\n"
        "Fakat bu kötü durumdan kaçınmak için birkaç seçeneğin var!\n",
        false,
      );
    }
  }

  // Savaş sonuçları dialogu
  void showResultDialog(String result, bool isPlayer) {
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
                    Column(
                      children: [
                        Text(
                          result,
                          style:
                              baseTextStyle.copyWith(fontSize: width * 0.055),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        if (isPlayer == false && widget.character.luckCards > 0)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${widget.character.luckCards} ",
                                    style: baseNumberStyle.copyWith(
                                        fontSize: width * 0.04),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                  Text(
                                    " tane şans kartın var.",
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.055),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                ],
                              ),
                              Text(
                                "Şans kartını kullanmak ister misin?",
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.055),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                            ],
                          ),
                        if (isPlayer == false &&
                            widget.character.luckCards == 0)
                          Text(
                            "Hiç şans kartın yok!\n"
                            "Şans kartı satın almak ister misin?",
                            style:
                                baseTextStyle.copyWith(fontSize: width * 0.055),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                      ],
                    ),
                    if (isPlayer == true)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green.shade700.withOpacity(0.25),
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
                          widget.character.totalDamageToEnemies +=
                              widget.enemy.maxHealth;
                          showDamage = false;
                          stopSound();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'İşte Bu!',
                          style:
                              baseNumberStyle.copyWith(fontSize: width * 0.04),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ),
                    if (isPlayer == false)
                      Column(
                        children: [
                          SizedBox(height: height * 0.015),
                          if (widget.character.luckCards > 0)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green.shade700.withOpacity(0.25),
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
                                useOneLuckCards();
                                Navigator.of(context).pop();
                                setState(() {
                                  isRollDice = false;
                                  showDamage = false;
                                  turnIndicator = "";
                                });
                              },
                              child: Text(
                                'Kullan',
                                style: baseNumberStyle.copyWith(
                                    fontSize: width * 0.04),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                            ),
                          if (widget.character.luckCards == 0)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green.shade700.withOpacity(0.25),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MarketPage(
                                      character: widget.character,
                                    ),
                                  ),
                                ).then((_) {
                                  showResultDialog(
                                    "Kaybettin!\nOyun Bitti!\n\n"
                                    "Fakat bu kötü durumdan kaçınmak için "
                                    "birkaç seçeneğin var!\n",
                                    false,
                                  );
                                });
                              },
                              child: Text(
                                'Satın Al',
                                style: baseNumberStyle.copyWith(
                                    fontSize: width * 0.04),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                            ),
                          SizedBox(height: height * 0.01),
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
                              stopSound();
                              int damageTaken =
                                  widget.enemy.maxHealth - widget.enemy.health;
                              widget.character.totalDamageToEnemies +=
                                  damageTaken;
                              widget.character.saveCharacterData();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Oyunu Bitir!',
                              style: baseNumberStyle.copyWith(
                                  fontSize: width * 0.04),
                              textAlign: TextAlign.center,
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

  // --------------------------------------------------------------------------
  // Ölümden Kurtuluş Seçenekleri;
  // 1 Tane Şans Kartı Kullanımı
  void useOneLuckCards() async {
    showButton = false;
    playerRoll = Random().nextInt(6) + 1;
    await Future.delayed(const Duration(milliseconds: 250));
    int luckCardCanYenilemesi = 0;
    switch (playerRoll) {
      case 1:
        luckCardCanYenilemesi = 50;
        break;
      case 2:
        luckCardCanYenilemesi = 55;
        break;
      case 3:
        luckCardCanYenilemesi = 60;
        break;
      case 4:
        luckCardCanYenilemesi = 65;
        break;
      case 5:
        luckCardCanYenilemesi = 70;
        break;
      case 6:
        luckCardCanYenilemesi = 75;
        break;
    }
    if (widget.character.luckCards > 0) {
      widget.character.health = 0;
      widget.character.health += luckCardCanYenilemesi;
      widget.character.usesLuckCards++;
      widget.character.luckCards--;
      widget.character.saveCharacterData();
    }
    if (widget.enemy.health > 0) {
      setState(() {
        turnIndicator = "Şans kartı seni kurtardı ve $luckCardCanYenilemesi "
            "can değerinde canını yeniledi!!!";
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() {
        turnIndicator = "Sıra Sende!\nBu şansı iyi değerlendir!";
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() {
        playerRoll = 0;
        showButton = true;
      });
    }
  }

  // --------------------------------------------------------------------------
  // Yetenekler için destek fonksiyon grupları
  void generalBoolForPlayer(bool throwDice) {
    showDiceTurn = true;
    isPlayerDice = true;
    showDamage = false;
    if (throwDice) {
      playDiceSound();
    }
  }

  void useManaPoint() {
    if (widget.character.magicBar > 0) {
      widget.character.magicBar -= 1;
    }
  }

  void regManaPoint() {
    if (widget.character.magicBar < maxMagicBar) {
      widget.character.magicBar += 1;
    }
  }

  void enemyIsDead() {
    if (widget.enemy.health < 1) {
      showResultDialog("Düşmanı alt etmeyi başardın!", true);
    }
  }

  void showTurnButton() {
    setState(() {
      showButton = true;
    });
  }

  // --------------------------------------------------------------------------
  // Genel Yetenekler;
  // Genel normal saldırı işlemi
  void normalAttack() async {
    generalBoolForPlayer(true);
    playAttackSound();
    isRollDice = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator = "Normal bir saldırı yaptın!";
    });
    if (kaderinCagrisiTuru == true && playerRoll > 15) {
      playerAttack = (calculatePlayerAttack() * 1.5).toInt();
    } else {
      playerAttack = calculatePlayerAttack();
    }
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    if (yildirimRuhuTuru > 0) {
      await Future.delayed(const Duration(milliseconds: 500));
      spiritRoll = Random().nextInt(5) + 1;
      yildirimRuhuTuru--;
      if (kaderinCagrisiTuru == true && playerRoll > 15) {
        spiritAttack = ((spiritRoll * 10) * 1.5).toInt();
      } else {
        spiritAttack = (spiritRoll * 10).toInt();
      }
      setState(() {
        turnIndicator = "Yıldırım Ruhu düşmana $spiritAttack hasar vurdu!";
      });
      await animateHealthReduction(isEnemy: true, damage: spiritAttack);
      await Future.delayed(const Duration(milliseconds: 750));
    }
    if (ormaninYankisiSayac > 0) {
      ormaninYankisiSayac--;
    }
    if (ormaninYankisiTuru == true) {
      if (widget.character.magicBar < maxMagicBar) {
        widget.character.magicBar += 1;
        ormaninYankisiTuru = false;
      } else {
        ormaninYankisiTuru = true;
      }
    }
    showTurnButton();
    enemyIsDead();
  }

  // Can potu kullanımı
  void healthPot() async {
    playUsePotSound();
    if (widget.character.health < widget.character.maxHealth &&
        widget.character.healthPot > 0) {
      widget.character.health += 25;
      widget.character.healthPot--;
      diceResult = Random().nextInt(4) + 1;
      if (diceResult == 1) {
        widget.character.bosSise++;
      }
      while (widget.character.health > widget.character.maxHealth) {
        widget.character.health--;
      }
    }
    setState(() {
      turnSkillIndicator = "Pot kullandın ve 25 can yeniledin!";
    });
    await Future.delayed(const Duration(milliseconds: 1250));
    setState(() {
      turnSkillIndicator = "Sıra Tekrar Sende!";
    });
  }

  // Mana potu kullanımı
  void manaPot() async {
    playUsePotSound();
    if (widget.character.magicBar < maxMagicBar &&
        widget.character.manaPot > 0) {
      widget.character.magicBar += 1;
      widget.character.manaPot--;
      diceResult = Random().nextInt(4) + 1;
      if (diceResult == 1) {
        widget.character.bosSise++;
      }
    }
    setState(() {
      turnSkillIndicator = "Pot kullandın ve 1 aksiyon puanı yeniledin!";
    });
    await Future.delayed(const Duration(milliseconds: 1250));
    setState(() {
      turnSkillIndicator = "Sıra tekrar sende!";
    });
  }

  // --------------------------------------------------------------------------
  // Barbar Yetenekleri;
  // Barbarın "Kemik Kıran" yeteneği
  void kemikKiran() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playHeavyAttackSound();
    firstSkillCD = widget.character.firstSkillCooldown + 1;
    isRollDice = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator = "Düşmana ağır bir saldırı indirdin!";
    });
    playerAttack = calculatePlayerAttack() * 2;
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    showTurnButton();
    enemyIsDead();
  }

  // Barbarın "Kükreme" yeteneği
  void kukreme() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playAxeSound();
    secondSkillCD = widget.character.secondSkillCooldown + 1;
    isRollDice = true;
    ozelTurEffect = true;
    tekrarTurKarakterde = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator =
          "Düşmana korku salarak onu saldırısından mahrum bıraktın!";
    });
    playerAttack = calculatePlayerAttack();
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    showTurnButton();
    enemyIsDead();
  }

  // Barbarın "Öfke Hasatı" yeteneği
  void ofkeHasati() async {
    generalBoolForPlayer(false);
    thirdSkillCD = widget.character.thirdSkillCooldown + 1;
    isRollDice = false;
    setState(() {
      turnIndicator = "25 puan canını harcayarak aksiyon puanı kazandın!";
    });
    if (widget.character.magicBar < maxMagicBar &&
        widget.character.health > 25) {
      widget.character.health -= 25;
      widget.character.magicBar += 1;
    }
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // Barbarın "Güç Patlaması" yeteneği
  void gucPatlamasi() async {
    generalBoolForPlayer(false);
    useManaPoint();
    fourthSkillCD = widget.character.fourthSkillCooldown + 1;
    isRollDice = false;
    gucPatlamasiTuru = 3;
    setState(() {
      turnIndicator = "Saldırılarını 3 tur boyunca %50 arttırdın!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // Barbarın "Sarsılmaz Vücut" yeteneği
  void sarsilmazVucut() async {
    generalBoolForPlayer(false);
    useManaPoint();
    fifthSkillCD = widget.character.fifthSkillCooldown + 1;
    isRollDice = false;
    sarsilmazVucutTuru = 2;
    setState(() {
      turnIndicator = "Savunmanı 2 tur boyunca 2 katına çıkarttın!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // --------------------------------------------------------------------------
  // Paladin Yetenekleri;
  // Paladinin "Kutsanmış" yeteneği
  void kutsanmis() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playSwordSound();
    firstSkillCD = widget.character.firstSkillCooldown + 1;
    isRollDice = true;
    playerRoll = rollDice(false); // İlk zar atışı
    setState(() {
      turnIndicator = "Kutsal enerjinle düşmana önce kendin hasar verdin!";
    });
    playerAttack = calculatePlayerAttack();
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    await Future.delayed(const Duration(milliseconds: 1500));
    isRollDice = false;
    showDamage = false;
    setState(() {
      turnIndicator = "Sonra da...";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    isRollDice = true;
    playDiceSound();
    playerRoll = rollDice(false); // İkinci zar atışı
    setState(() {
      turnIndicator = "Kutsal enerjin hasar verdi!";
    });
    playerAttack = calculatePlayerAttack();
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    showTurnButton();
    enemyIsDead();
  }

  // Paladinin "Kutsal Odak" yeteneği
  void kutsalOdak() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playSwordSound();
    secondSkillCD = widget.character.secondSkillCooldown + 1;
    isRollDice = true;
    ozelTurEffect = true;
    tekrarTurKarakterde = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator = "Kutsal bir iradeyle saldırına odaklanıyorsun!";
    });
    playerAttack = calculatePlayerAttack();
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    showTurnButton();
    enemyIsDead();
  }

  // Paladinin "Seçilmiş İrade" yeteneği
  void secilmisIrade() async {
    generalBoolForPlayer(false);
    useManaPoint();
    thirdSkillCD = widget.character.thirdSkillCooldown + 1;
    isRollDice = false;
    secilmisIradeTuru = true;
    ozelZarDurum = true;
    setState(() {
      turnIndicator = "Sonraki tur için şansını arttırdın!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  //Paladinin "Paladinin Duası" yeteneği
  void palanininDuasi() async {
    generalBoolForPlayer(false);
    regManaPoint();
    fourthSkillCD = widget.character.fourthSkillCooldown + 1;
    isRollDice = false;
    setState(() {
      turnIndicator = "Duan yanıt buldu ve aksiyon puanın yenilendi!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  //Paladinin "Ruhani Vücut" yeteneği
  void ruhaniVucut() async {
    generalBoolForPlayer(false);
    useManaPoint();
    fifthSkillCD = widget.character.fifthSkillCooldown + 1;
    isRollDice = false;
    playerRoll = Random().nextInt(5) + 1;
    playerAttack = playerRoll * 10;
    if (widget.character.health < widget.character.maxHealth) {
      widget.character.health += playerAttack;
      while (widget.character.health > widget.character.maxHealth) {
        widget.character.health--;
      }
    }
    setState(() {
      turnIndicator = "$playerAttack puan kadar can yeniledin!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // --------------------------------------------------------------------------
  // Hırsız Yetenekleri;
  // Hırsızın "Şaşırtmaca" yeteneği
  void sasirtmaca() async {
    generalBoolForPlayer(false);
    useManaPoint();
    firstSkillCD = widget.character.firstSkillCooldown + 1;
    isRollDice = false;
    sasirtmacaTuru = true;
    setState(() {
      turnIndicator = "Düşmana şaşırtmaca etkisi uyguladın!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // Hırsızın "Manipülasyon" yeteneği
  void manipulasyon() async {
    generalBoolForPlayer(false);
    useManaPoint();
    secondSkillCD = widget.character.secondSkillCooldown + 1;
    isRollDice = false;
    manipulasyonTuru = 3;
    ozelZarDurum = true;
    setState(() {
      turnIndicator = "Düşmanın şansını 3 turluğuna manipüle ettin!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // Hırsızın "Ruh Hırsızı" yeteneği
  void ruhHirsizi() async {
    generalBoolForPlayer(false);
    playDaggerSound();
    thirdSkillCD = widget.character.thirdSkillCooldown + 1;
    isRollDice = false;
    playerRoll = Random().nextInt(5) + 1;
    playerAttack = playerRoll * 10;
    if (widget.character.magicBar < maxMagicBar ||
        widget.character.health < widget.character.maxHealth) {
      if (widget.character.magicBar < maxMagicBar) {
        widget.character.magicBar += 1;
      }
      if (widget.character.health < widget.character.maxHealth) {
        widget.character.health += playerAttack;
        while (widget.character.health > widget.character.maxHealth) {
          widget.character.health--;
        }
      }
    }
    setState(() {
      turnIndicator = "Düşmanın $playerAttack canını çaldın!";
    });
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    showTurnButton();
    enemyIsDead();
  }

  // Hırsızın "Hileli Zar" yeteneği
  void hileliZar() async {
    generalBoolForPlayer(false);
    useManaPoint();
    fourthSkillCD = widget.character.fourthSkillCooldown + 1;
    isRollDice = false;
    ozelZarDurum = true;
    hileliZarTuru = true;
    ozelTurEffect = true;
    tekrarTurKarakterde = true;
    setState(() {
      turnIndicator = "Atılan zar sayısını arttırdın!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // Hırsızın "Ölümcül Vuruş" yeteneği
  void olumculVurus() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playHeavyAttackSound();
    fifthSkillCD = widget.character.fifthSkillCooldown + 1;
    isRollDice = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator = "Düşmana ciddi bir hasar uyguladın!";
    });
    playerAttack = calculatePlayerAttack() * 3;
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    int toSelfAttack1 = (widget.character.health * (1 / 2)).toInt();
    int toSelfAttack2_5 = (widget.character.health * (4 / 10)).toInt();
    int toSelfAttack6_15 = (widget.character.health * (1 / 4)).toInt();
    int toSelfAttack16_19 = (widget.character.health * (1 / 10)).toInt();
    if (playerRoll < 20) {
      setState(() {
        isRollDice = false;
        showDamage = false;
      });
      if (playerRoll == 1) {
        setState(() {
          turnIndicator =
              "Fakat zar değerinden dolayı $toSelfAttack1 kadar hasarı "
              "kendine vurdun!";
        });
        await animateHealthReduction(isEnemy: false, damage: toSelfAttack1);
        await Future.delayed(const Duration(milliseconds: 250));
      } else if (playerRoll > 1 && playerRoll < 6) {
        setState(() {
          turnIndicator =
              "Fakat zar değerinden dolayı $toSelfAttack2_5 kadar hasarı "
              "kendine vurdun!";
        });
        await animateHealthReduction(isEnemy: false, damage: toSelfAttack2_5);
        await Future.delayed(const Duration(milliseconds: 250));
      } else if (playerRoll > 5 && playerRoll < 16) {
        setState(() {
          turnIndicator =
              "Fakat zar değerinden dolayı $toSelfAttack6_15 kadar hasarı "
              "kendine vurdun!";
        });
        await animateHealthReduction(isEnemy: false, damage: toSelfAttack6_15);
        await Future.delayed(const Duration(milliseconds: 250));
      } else if (playerRoll > 15 && playerRoll < 20) {
        setState(() {
          turnIndicator =
              "Fakat zar değerinden dolayı $toSelfAttack16_19 kadar hasarı "
              "kendine vurdun!";
        });
        await animateHealthReduction(isEnemy: false, damage: toSelfAttack16_19);
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }
    if (widget.enemy.health < 1) {
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    showTurnButton();
    enemyIsDead();
  }

  // --------------------------------------------------------------------------
  // Korucu Yetenekleri;
  // Korucunun "Çevik Adım" yeteneği
  void cevikAdim() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playArrowSound();
    firstSkillCD = widget.character.firstSkillCooldown + 1;
    isRollDice = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator = "Çevik bir saldırı yaptın!";
    });
    if (ormaninYankisiSayac > 0) {
      ormaninYankisiSayac--;
    }
    if (ormaninYankisiTuru == true) {
      if (widget.character.magicBar < maxMagicBar) {
        widget.character.magicBar += 1;
        ormaninYankisiTuru = false;
      } else {
        ormaninYankisiTuru = true;
      }
    }
    playerAttack = calculatePlayerAttack();
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    if (playerRoll > 10) {
      setState(() {
        isRollDice = false;
        showDamage = false;
        turnIndicator = "Şansın sayesinde bir tur daha kazandın!";
      });
      ozelTurEffect = true;
      tekrarTurKarakterde = true;
      showTurnButton();
      enemyIsDead();
    } else {
      showTurnButton();
      enemyIsDead();
    }
  }

  // Korucunun "Zehirli Saldırı" yeteneği
  void zehirliSaldiri() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playArrowSound();
    secondSkillCD = widget.character.secondSkillCooldown + 1;
    isRollDice = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator = "Düşmanı zehirledin!";
    });
    zehirSaldirisiTuru = 3;
    zehirSaldirisiEtkiDurumu = true;
    if (ormaninYankisiSayac > 0) {
      ormaninYankisiSayac--;
    }
    if (ormaninYankisiTuru == true) {
      if (widget.character.magicBar < maxMagicBar) {
        widget.character.magicBar += 1;
        ormaninYankisiTuru = false;
      } else {
        ormaninYankisiTuru = true;
      }
    }
    playerAttack = calculatePlayerAttack();
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    showTurnButton();
    enemyIsDead();
  }

  // Korucunun "Dengesiz Rüzgar" yeteneği
  void dengesizRuzgar() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playArrowSound();
    thirdSkillCD = widget.character.thirdSkillCooldown + 1;
    isRollDice = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator = "Dengesiz rüzgar yeteneğiyle sert bir saldırı yaptın!";
    });
    playerAttack = calculatePlayerAttack() * 2;
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    if (ormaninYankisiSayac > 0) {
      ormaninYankisiSayac--;
    }
    if (ormaninYankisiTuru == true) {
      if (widget.character.magicBar < maxMagicBar) {
        widget.character.magicBar += 1;
        ormaninYankisiTuru = false;
      } else {
        ormaninYankisiTuru = true;
      }
    }
    setState(() {
      isRollDice = false;
      showDamage = false;
    });
    if (playerRoll < 16) {
      setState(() {
        turnIndicator = "Fakat saldırının ardından dengesiz rüzgar düşmanı "
            "etkileyemedi!";
      });
    } else {
      setState(() {
        turnIndicator = "Saldırının ardından dengesiz rüzgar başarıyla "
            "düşmanı etkiledi!";
      });
      dengesizRuzgarTuru = true;
    }
    showTurnButton();
    enemyIsDead();
  }

  // Korucunun "Doğanın Hediyesi" yeteneği
  void doganinHediyesi() async {
    generalBoolForPlayer(false);
    useManaPoint();
    fourthSkillCD = widget.character.fourthSkillCooldown + 1;
    isRollDice = false;
    ozelTurEffect = true;
    tekrarTurKarakterde = true;
    playerRoll = Random().nextInt(4) + 1;
    playerAttack = (playerRoll * 7.5).toInt();
    if (widget.character.health < widget.character.maxHealth) {
      widget.character.health += playerAttack;
      while (widget.character.health > widget.character.maxHealth) {
        widget.character.health--;
      }
    }
    if (ormaninYankisiSayac > 0) {
      ormaninYankisiSayac--;
    }
    if (ormaninYankisiTuru == true) {
      if (widget.character.magicBar < maxMagicBar) {
        widget.character.magicBar += 1;
        ormaninYankisiTuru = false;
      } else {
        ormaninYankisiTuru = true;
      }
    }
    setState(() {
      turnIndicator = "$playerAttack puan kadar can yeniledin!";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // Korucunun "Ormanın Yankısı" yeteneği
  void ormaninYankisi() async {
    generalBoolForPlayer(false);
    regManaPoint();
    fifthSkillCD = widget.character.fifthSkillCooldown + 1;
    isRollDice = false;
    ormaninYankisiTuru = true;
    ormaninYankisiSayac = 5;
    setState(() {
      turnIndicator = "2 aksiyon puanı yeniledin!\nBiri bu tur diğeri "
          "ise sonraki tur yada aksiyon barından bir bar eksilince yenilenecek.";
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    showTurnButton();
    enemyIsDead();
  }

  // --------------------------------------------------------------------------
  // Büyücü Yetenekleri;
  // Büyücünün "Yarının Arzusu" yeteneği
  void yarininArzusu() async {
    generalBoolForPlayer(false);
    useManaPoint();
    firstSkillCD = widget.character.firstSkillCooldown + 1;
    ozelTurEffect = true;
    isRollDice = false;
    turGecikmesi = 1;
    yarininArzusuTuru = true;
    yarininArzusuSayac = 1;
    setState(() {
      turnIndicator = "Aksiyonunu sonraki tura sakladın!";
    });
    await Future.delayed(const Duration(milliseconds: 750));
    if (yildirimRuhuTuru > 0) {
      await Future.delayed(const Duration(milliseconds: 500));
      spiritRoll = Random().nextInt(5) + 1;
      yildirimRuhuTuru--;
      if (kaderinCagrisiTuru == true && playerRoll > 15) {
        spiritAttack = ((spiritRoll * 10) * 1.5).toInt();
      } else {
        spiritAttack = (spiritRoll * 10).toInt();
      }
      setState(() {
        turnIndicator = "Aksiyonunu sonraki tura sakladın!\n"
            "Yıldırım Ruhu düşmana $spiritAttack hasar vurdu!";
      });
      await animateHealthReduction(isEnemy: true, damage: spiritAttack);
      await Future.delayed(const Duration(milliseconds: 750));
    }
    showTurnButton();
    enemyIsDead();
  }

  // Büyücünün "Büyü Üstadı" yeteneği
  void buyuUstadi() async {
    generalBoolForPlayer(false);
    regManaPoint();
    secondSkillCD = widget.character.secondSkillCooldown + 1;
    isRollDice = false;
    int yenilenenCan = 0;
    if (widget.character.health < widget.character.maxHealth) {
      switch (widget.character.magicBar) {
        case 1:
          yenilenenCan = 25;
          widget.character.health += 25;
          break;
        case 2:
          yenilenenCan = 30;
          widget.character.health += 30;
          break;
        case 3:
          yenilenenCan = 40;
          widget.character.health += 40;
          break;
        default:
          yenilenenCan = 50;
          widget.character.health += 50;
          break;
      }
      while (widget.character.health > widget.character.maxHealth) {
        widget.character.health--;
      }
    }
    setState(() {
      turnIndicator =
          "$yenilenenCan puan kadar can yeniledin!\nve\n1 Aksiyon Barı yeniledin!";
    });
    await Future.delayed(const Duration(milliseconds: 750));
    if (yildirimRuhuTuru > 0) {
      await Future.delayed(const Duration(milliseconds: 500));
      spiritRoll = Random().nextInt(5) + 1;
      yildirimRuhuTuru--;
      if (kaderinCagrisiTuru == true && playerRoll > 15) {
        spiritAttack = ((spiritRoll * 10) * 1.5).toInt();
      } else {
        spiritAttack = (spiritRoll * 10).toInt();
      }
      setState(() {
        turnIndicator = "$yenilenenCan puan kadar can yeniledin!\n"
            "Yıldırım Ruhu düşmana $spiritAttack hasar vurdu!";
      });
      await animateHealthReduction(isEnemy: true, damage: spiritAttack);
      await Future.delayed(const Duration(milliseconds: 750));
    }
    showTurnButton();
    enemyIsDead();
  }

  // Büyücünün "Yıldırım Ruhu" yeteneği
  void yildirimRuhu() async {
    generalBoolForPlayer(true);
    useManaPoint();
    playElectricityAttackSound();
    thirdSkillCD = widget.character.thirdSkillCooldown + 1;
    yildirimRuhuTuru = 2;
    isRollDice = true;
    playerRoll = rollDice(false);
    setState(() {
      turnIndicator = "Bir yıldırım ruhu çağırdın!";
    });
    if (kaderinCagrisiTuru == true && playerRoll > 15) {
      playerAttack = (calculatePlayerAttack() * 1.5).toInt();
    } else {
      playerAttack = calculatePlayerAttack();
    }
    playerAttack = applyNormalDiceEffect(playerRoll, playerAttack);
    await Future.delayed(const Duration(milliseconds: 3750));
    await animateHealthReduction(isEnemy: true, damage: playerAttack);
    showTurnButton();
    enemyIsDead();
  }

  // Büyücünün "Halüsinasyon" yeteneği
  void halusinasyon() async {
    generalBoolForPlayer(false);
    useManaPoint();
    fourthSkillCD = widget.character.fourthSkillCooldown + 1;
    isRollDice = false;
    halusinasyonTuru = true;
    halusinasyonRoll = Random().nextInt(5) + 1;
    halusinasyonRollList = [0];
    setState(() {
      turnIndicator = "Düşmanı halüsine ettin!";
    });
    await Future.delayed(const Duration(milliseconds: 750));
    if (yildirimRuhuTuru > 0) {
      await Future.delayed(const Duration(milliseconds: 500));
      spiritRoll = Random().nextInt(5) + 1;
      yildirimRuhuTuru--;
      if (kaderinCagrisiTuru == true && playerRoll > 15) {
        spiritAttack = ((spiritRoll * 10) * 1.5).toInt();
      } else {
        spiritAttack = (spiritRoll * 10).toInt();
      }
      setState(() {
        turnIndicator = "Düşmanı halüsine ettin!\n"
            "Yıldırım Ruhu düşmana $spiritAttack hasar vurdu!";
      });
      await animateHealthReduction(isEnemy: true, damage: spiritAttack);
      await Future.delayed(const Duration(milliseconds: 750));
    }
    showTurnButton();
    enemyIsDead();
  }

  // Büyücünün "Kaderin Çağrısı" yeteneği
  void kaderinCagrisi() async {
    generalBoolForPlayer(false);
    useManaPoint();
    fifthSkillCD = widget.character.fifthSkillCooldown + 1;
    isRollDice = false;
    kaderinCagrisiTuru = true;
    setState(() {
      turnIndicator = "Kaderin çağrısı yeteneğini aktif ettin!";
    });
    await Future.delayed(const Duration(milliseconds: 750));
    if (yildirimRuhuTuru > 0) {
      await Future.delayed(const Duration(milliseconds: 500));
      spiritRoll = Random().nextInt(5) + 1;
      yildirimRuhuTuru--;
      if (kaderinCagrisiTuru == true && playerRoll > 15) {
        spiritAttack = ((spiritRoll * 10) * 1.5).toInt();
      } else {
        spiritAttack = (spiritRoll * 10).toInt();
      }
      setState(() {
        turnIndicator = "Yıldırım Ruhu düşmana $spiritAttack hasar vurdu!";
      });
      await animateHealthReduction(isEnemy: true, damage: spiritAttack);
      await Future.delayed(const Duration(milliseconds: 750));
    }
    showTurnButton();
    enemyIsDead();
  }

  // Yetenek ve Karakter bilgileri gösterme fonksiyon grubu
  void showInfo(String infoTitle, String infoText, bool isPlayerInfo) {
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
                      infoTitle,
                      style: baseTextStyle.copyWith(fontSize: width * 0.06),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.015),
                    Flexible(
                      child: SingleChildScrollView(
                        child: RichText(
                          text: _buildRichText(infoText, width),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ),
                    ),
                    if (isPlayerInfo && widget.character.luckCards == 0)
                      Column(
                        children: [
                          SizedBox(height: height * 0.01),
                          Text(
                            "Elinde hiç şans kartı kalmamış, bu kart seni kritik "
                            "ölümlerden koruyan önemli bir eşya!\n Şans Kartı "
                            "satın almak ister misin?",
                            style:
                                baseTextStyle.copyWith(fontSize: width * 0.05),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          SizedBox(height: height * 0.015),
                        ],
                      ),
                    if (isPlayerInfo && widget.character.luckCards == 0)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green.shade700.withOpacity(0.25),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketPage(
                                character: widget.character,
                              ),
                            ),
                          ).then((_) {
                            showInfo(
                              "Karakter İstatistikleri",
                              "Saldırı Değeri (AP): ${widget.saldiriDegeri}\n"
                                  "Savunma Değeri (DP): ${widget.savunmaDegeri}\n"
                                  "Maksimum Can (HP): ${widget.character.maxHealth}\n"
                                  "Maksimum Aksiyon (MP): $maxMagicBar\n"
                                  "Güç Değeri: ${widget.strength}\n"
                                  "Zeka Değeri: ${widget.intelligence}\n"
                                  "Beceri Değeri: ${widget.dexterity}\n"
                                  "Karizma Değeri: ${widget.charisma}\n\n"
                                  "Irk: ${widget.character.race}\n"
                                  "Sınıf: ${widget.character.characterClass}\n"
                                  "Şans Kartı Sayısı: ${widget.character.luckCards}\n\n"
                                  "Can Potu Sayısı: ${widget.character.healthPot}\n"
                                  "Aksiyon Potu Sayısı: ${widget.character.manaPot}",
                              true,
                            );
                          });
                        },
                        child: Text(
                          'Satın Al!',
                          style:
                              baseNumberStyle.copyWith(fontSize: width * 0.04),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
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
                        'Bilgileri Kapat',
                        style: baseNumberStyle.copyWith(fontSize: width * 0.04),
                        textAlign: TextAlign.center,
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

  TextSpan _buildRichText(String infoText, double width) {
    List<TextSpan> spans = [];
    final RegExp regExp = RegExp(r"(\d+|'[^']+'|''[^']*''|:(.*?)(\n|$))");
    infoText.splitMapJoin(
      regExp,
      onMatch: (Match match) {
        String matchedText = match.group(0)!;
        if (matchedText.startsWith(":")) {
          spans.add(
            TextSpan(
              text: ":",
              style: TextStyle(
                fontSize: width * 0.05,
                fontFamily: "CormorantGaramond-Regular",
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
          spans.add(
            TextSpan(
              text: matchedText.substring(1),
              style: TextStyle(
                fontSize: width * 0.0375,
                fontFamily: "LibreBaskerville-Bold",
                color: Colors.red,
              ),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: matchedText,
              style: TextStyle(
                fontSize: width * 0.0375,
                fontFamily: "LibreBaskerville-Bold",
                color: Colors.red,
              ),
            ),
          );
        }
        return '';
      },
      onNonMatch: (String text) {
        spans.add(
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: width * 0.05,
              fontFamily: "CormorantGaramond-Regular",
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        );
        return '';
      },
    );
    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double canYuzdesi = widget.character.health > 0
        ? widget.character.health / widget.character.maxHealth
        : 0;
    double healthPercentage =
        (widget.enemy.health / widget.enemy.maxHealth).clamp(0.0, 1.0);
    final String battleText = "${widget.enemy.name} ile Savaş";

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: battleText,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textScaler: const TextScaler.linear(1),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);
    final double textWidth = textPainter.width;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
    );
    TextStyle baseNumberStyle = const TextStyle(
      fontFamily: "LibreBaskerville-Bold",
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/backgrounds/primary/general_page_bg.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              left: (width - textWidth) / 2,
              top: height * 0.075,
              child: Text(
                battleText,
                style: baseTextStyle.copyWith(
                    fontSize: width * 0.065, color: Colors.black87),
                textAlign: TextAlign.center,
                textScaler: const TextScaler.linear(1),
              ),
            ),
            if (widget.character.playerName == "Saitskuruls")
              Positioned(
                left: width * 0.465,
                top: height * 0.035,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      widget.character.saveCharacterData();
                      Navigator.of(context).pop();
                    },
                    customBorder: const CircleBorder(),
                    child: Icon(
                      CupertinoIcons.multiply_circle_fill,
                      size: width * 0.07,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            // Karakter bilgi, görsel, can çubuğu, aksiyon barı ve pot bilgileri
            Positioned(
              left: width * 0.1,
              top: height * 0.15,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.question_circle_fill,
                      size: width * 0.08,
                    ),
                    color: const Color(0xFF303746),
                    onPressed: () {
                      showInfo(
                        "Karakter İstatistikleri",
                        "Saldırı Değeri (AP): ${widget.saldiriDegeri}\n"
                            "Savunma Değeri (DP): ${widget.savunmaDegeri}\n"
                            "Maksimum Can (HP): ${widget.character.maxHealth}\n"
                            "Maksimum Aksiyon (MP): $maxMagicBar\n"
                            "Güç Değeri: ${widget.strength}\n"
                            "Zeka Değeri: ${widget.intelligence}\n"
                            "Beceri Değeri: ${widget.dexterity}\n"
                            "Karizma Değeri: ${widget.charisma}\n\n"
                            "Irk: ${widget.character.race}\n"
                            "Sınıf: ${widget.character.characterClass}\n"
                            "Şans Kartı Sayısı: ${widget.character.luckCards}\n\n"
                            "Can Potu Sayısı: ${widget.character.healthPot}\n"
                            "Aksiyon Potu Sayısı: ${widget.character.manaPot}",
                        true,
                      );
                    },
                  ),
                  // Oyuncu Görseli
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        widget.character.imagePath,
                        height: height * 0.105,
                        width: width * 0.225,
                      ),
                      Container(
                        height: height * 0.105,
                        width: width * 0.225,
                        color: Colors.red.withOpacity(playerOpacity),
                      ),
                      Row(
                        children: [
                          if (gucPatlamasiTuru != 0 || kaderinCagrisiTuru)
                            Icon(
                              Remix.sword_fill,
                              size: width * 0.05,
                              color: Colors.red,
                            ),
                          if (sarsilmazVucutTuru != 0)
                            Icon(
                              Icons.shield,
                              size: width * 0.05,
                              color: Colors.blue,
                            ),
                          if (secilmisIradeTuru || hileliZarTuru)
                            Icon(
                              Remix.sparkling_2_fill,
                              size: width * 0.05,
                              color: Colors.yellow,
                            ),
                          if (ormaninYankisiTuru)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Remix.add_line,
                                      size: width * 0.025,
                                      color: Colors.green.shade600,
                                    ),
                                    SizedBox(height: height * 0.0125),
                                  ],
                                ),
                                Icon(
                                  Remix.add_circle_fill,
                                  size: width * 0.05,
                                  color: Colors.green,
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Remix.add_line,
                                      size: width * 0.03,
                                      color: Colors.green.shade600,
                                    ),
                                    SizedBox(height: height * 0.005),
                                  ],
                                ),
                              ],
                            ),
                          if (yarininArzusuTuru)
                            Icon(
                              Remix.arrow_right_up_box_fill,
                              size: width * 0.05,
                              color: Colors.cyanAccent,
                            ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: width * 0.045,
                      ),
                      SizedBox(width: width * 0.01),
                      Stack(
                        children: [
                          Container(
                            height: height * 0.02,
                            width: width * 0.24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: canYuzdesi,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                '${widget.character.health} / ${widget.character.maxHealth}',
                                style: baseNumberStyle.copyWith(
                                    fontSize: width * 0.025,
                                    color: Colors.white,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5.0,
                                        color: Colors.black,
                                      ),
                                    ]),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.electric_bolt,
                        color: Colors.blue,
                        size: width * 0.045,
                      ),
                      SizedBox(width: width * 0.01),
                      Row(
                        children: List.generate(
                          maxMagicBar,
                          (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.005,
                              ),
                              child: CircleAvatar(
                                radius: width * 0.015,
                                backgroundColor:
                                    index < widget.character.magicBar
                                        ? Colors.blue
                                        : Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.drop_fill,
                            color: Colors.red,
                            size: width * 0.045,
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            '${widget.character.healthPot}',
                            style: baseNumberStyle.copyWith(
                                fontSize: width * 0.035, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      SizedBox(width: width * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            CupertinoIcons.drop_fill,
                            color: Colors.blue,
                            size: width * 0.045,
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            '${widget.character.manaPot}',
                            style: baseNumberStyle.copyWith(
                                fontSize: width * 0.035, color: Colors.black87),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Düşman bilgi, görsel, can ve saldırı değerleri
            Positioned(
              right: width * 0.1,
              top: height * 0.15,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.question_circle_fill,
                      size: width * 0.08,
                    ),
                    color: const Color(0xFF303746),
                    onPressed: () {
                      showInfo(
                        widget.enemy.name,
                        widget.enemy.info,
                        false,
                      );
                    },
                  ),
                  // Düşman Görseli
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        widget.enemy.imagePath,
                        height: height * 0.105,
                        width: width * 0.225,
                      ),
                      Container(
                        height: height * 0.105,
                        width: width * 0.225,
                        color: Colors.red.withOpacity(enemyOpacity),
                      ),
                      Row(
                        children: [
                          if (tekrarTurKarakterde)
                            Icon(
                              Remix.pulse_fill,
                              size: width * 0.05,
                              color: Colors.orange,
                            ),
                          if (sasirtmacaTuru || dengesizRuzgarTuru)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Remix.star_s_fill,
                                      size: width * 0.0325,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(height: height * 0.015),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Remix.star_s_fill,
                                      size: width * 0.0275,
                                      color: Colors.deepOrange,
                                    ),
                                    Icon(
                                      Remix.star_s_fill,
                                      size: width * 0.05,
                                      color: Colors.purpleAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (manipulasyonTuru != 0)
                            Icon(
                              Remix.scroll_to_bottom_line,
                              size: width * 0.05,
                              color: Colors.cyanAccent,
                            ),
                          if (zehirSaldirisiTuru != 0)
                            Icon(
                              Remix.skull_fill,
                              size: width * 0.05,
                              color: Colors.green.shade700,
                            ),
                          if (yildirimRuhuTuru != 0)
                            Icon(
                              Icons.electric_bolt,
                              size: width * 0.05,
                              color: Colors.blueAccent.shade700,
                            ),
                          if (halusinasyonTuru)
                            Icon(
                              Remix.eye_off_fill,
                              size: width * 0.05,
                              color: Colors.purple,
                            ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: width * 0.045,
                      ),
                      SizedBox(width: width * 0.01),
                      Stack(
                        children: [
                          Container(
                            height: height * 0.02,
                            width: width * 0.24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: width * 0.24 * healthPercentage,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                '${widget.enemy.health}',
                                style: baseNumberStyle.copyWith(
                                    fontSize: width * 0.025,
                                    color: Colors.white,
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5.0,
                                        color: Colors.black,
                                      ),
                                    ]),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.005),
                  Row(
                    children: [
                      Text(
                        'Temel Hasar: ',
                        style: TextStyle(
                          fontSize: width * 0.0425,
                          fontFamily: "CormorantGaramond-Regular",
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      Text(
                        '${widget.enemy.attackDamage}',
                        style: TextStyle(
                          fontSize: width * 0.0375,
                          fontFamily: "LibreBaskerville-Bold",
                          color: Colors.purple,
                        ),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Yeteneklerin gösterildiği kısım
            if (!showDiceTurn)
              Positioned(
                bottom: height * 0.15,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Tur yazıları
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.05,
                        left: width * 0.05,
                      ),
                      child: Text(
                        turnSkillIndicator,
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontFamily: "LibreBaskerville-Bold",
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    // 1. satır genel tüm sınıfların kullanacağı yeteneklerin
                    // olduğu ve gösterildiği kısım
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Genel Normal Saldırı
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              normalAttack();
                            },
                            onLongPress: () {
                              showInfo(
                                "Normal Saldırı",
                                "Tüm sınıflar, savaşın temeli olan 'Normal Saldırı'"
                                    " yeteneğini kullanarak düşmanlarına temel "
                                    "saldırı güçlerini uygularlar. Bu saldırı, "
                                    "doğrudan fiziksel veya büyüsel güçlerine "
                                    "dayanarak düşmanlarına hasar verir ve aksiyon "
                                    "barı gerektirmeden hızlı bir şekilde "
                                    "uygulanabilir. Her sınıfın uzmanlık alanına "
                                    "göre saldırı şekli farklılık gösterebilir, "
                                    "ancak sonuç aynıdır; rakibe doğrudan zarar "
                                    "vermek."
                                    "\n\n"
                                    "Hasar: 1 x AP\n"
                                    "Sonraki Tur: Düşmanın",
                                false,
                              );
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/normal_saldiri.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        // Can Potu
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => widget.character.health <
                                        widget.character.maxHealth &&
                                    widget.character.healthPot > 0
                                ? healthPot()
                                : null,
                            onLongPress: () {
                              showInfo(
                                "Can Potu",
                                "Can potu çok hızlı kullanıma sahip bir can "
                                    "yenileme eşyasıdır ve oyuncunun canını '25' "
                                    "puan yeniler. Kullanım sonrası tur "
                                    "yine oyuncuda kalır."
                                    "\n\n"
                                    "İyileşme: 25 HP\n"
                                    "Sonraki Tur: Oyuncunun",
                                false,
                              );
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/can_potu.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                              colorFilter: widget.character.health <
                                          widget.character.maxHealth &&
                                      widget.character.healthPot > 0
                                  ? null
                                  : ColorFilter.mode(
                                      Colors.deepOrange.shade600
                                          .withOpacity(0.7),
                                      BlendMode.modulate,
                                    ),
                            ),
                          ),
                        ),
                        // Aksiyon Potu
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () =>
                                widget.character.magicBar < maxMagicBar &&
                                        widget.character.manaPot > 0
                                    ? manaPot()
                                    : null,
                            onLongPress: () {
                              showInfo(
                                "Aksiyon Potu",
                                "Aksiyon potu çok hızlı kullanıma sahip bir aksiyon"
                                    " barı yenileme eşyasıdır ve oyuncunun aksiyon "
                                    "barını '1' puan yeniler. Kullanım "
                                    "sonrası tur yine oyuncuda kalır."
                                    "\n\n"
                                    "İyileşme: 1 MP\n"
                                    "Sonraki Tur: Oyuncunun",
                                false,
                              );
                            },
                            splashColor:
                                Colors.lightGreenAccent.withOpacity(0.3),
                            highlightColor:
                                Colors.lightGreenAccent.withOpacity(0.15),
                            child: Ink.image(
                              image: const AssetImage(
                                "assets/images/icons/skills/mana_potu.png",
                              ),
                              width: width * 0.175,
                              height: width * 0.175,
                              fit: BoxFit.fill,
                              colorFilter:
                                  widget.character.magicBar < maxMagicBar &&
                                          widget.character.manaPot > 0
                                      ? null
                                      : ColorFilter.mode(
                                          Colors.deepOrange.shade600
                                              .withOpacity(0.7),
                                          BlendMode.modulate,
                                        ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    // 2. satır sınıf yeteneklerinin sıralandığı kısım
                    // --------------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ----------------------------------------------------
                        // Barbar Yetenekleri;
                        // Kemik Kıran Yeteneği
                        if (widget.character.characterClass == 'Barbar' &&
                            widget.character.firstSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      firstSkillCD == 0
                                  ? kemikKiran()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Kemik Kıran",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "mevcut turda düşmana, Normal Saldırı "
                                      "Değerinin '2 katı' kadar bir hasar "
                                      "uygular."
                                      "\n\n"
                                      "Kulanım Bedeli: 1 MP\n"
                                      "Verilen Hasar: 2 x AP\n"
                                      "Sonraki Tur: Düşmanın",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/kemik_kiran.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                firstSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (firstSkillCD != 0)
                                    Column(
                                      children: [
                                        Text(
                                          "$firstSkillCD",
                                          style: baseNumberStyle.copyWith(
                                              fontSize: width * 0.06,
                                              color: Colors.white,
                                              shadows: const [
                                                Shadow(
                                                  offset: Offset(0, 0),
                                                  blurRadius: 25.0,
                                                  color: Colors.cyan,
                                                ),
                                              ]),
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              const TextScaler.linear(1),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Kükreme Yeteneği
                        if (widget.character.characterClass == 'Barbar' &&
                            widget.character.secondSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      secondSkillCD == 0
                                  ? kukreme()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Kükreme",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "bulunduğu turda düşmana, Normal Saldırı "
                                      "Değerinin yanında onları sonraki tur "
                                      "boyunca korkuya sürükler ve 'saldırı "
                                      "yapamaz duruma' getirir."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Verilen Hasar:  1 x AP\n"
                                      "Sonraki Tur: Oyuncunun",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/kukreme.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                secondSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (secondSkillCD != 0)
                                    Text(
                                      "$secondSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Öfke Hasatı Yeteneği
                        if (widget.character.characterClass == 'Barbar' &&
                            widget.character.thirdSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar <
                                          maxMagicBar &&
                                      widget.character.health > 25 &&
                                      thirdSkillCD == 0
                                  ? ofkeHasati()
                                  : bottomAlert(
                                      widget.character.magicBar == maxMagicBar
                                          ? "Aksiyon Barı tamamen dolu!!!"
                                          : widget.character.health <= 25
                                              ? "Yeteri miktarda Can Değeri yok!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Öfke Hasatı",
                                  "Bu yetenek ile oyuncu '25 Can Puanı' feda "
                                      "ederek '1 Aksion Barı' kazanır. Ek "
                                      "olarak bu yetenek öyle hızlıdır ki, "
                                      "oyuncu bir tur daha saldırı yapabilir."
                                      "\n\n"
                                      "Kullanım Bedeli: 25 HP\n"
                                      "Alınan İyileşme: 1 MP\n"
                                      "Sonraki Tur: Oyuncunun",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/ofke_hasati.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter: widget.character.magicBar <
                                                maxMagicBar &&
                                            widget.character.health > 25 &&
                                            thirdSkillCD == 0
                                        ? null
                                        : ColorFilter.mode(
                                            Colors.deepOrange.shade600
                                                .withOpacity(0.7),
                                            BlendMode.modulate,
                                          ),
                                  ),
                                  if (thirdSkillCD != 0)
                                    Text(
                                      "$thirdSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Güç Patlaması Yeteneği
                        if (widget.character.characterClass == 'Barbar' &&
                            widget.character.fourthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      gucPatlamasiTuru == 0 &&
                                      fourthSkillCD == 0
                                  ? gucPatlamasi()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : gucPatlamasiTuru > 0
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Güç Patlaması",
                                  "Bu yetenek '1 Aksiyon Barı' harcayarak "
                                      "oyuncunun Saldırı Değerini, sonraki "
                                      "turla beraber '3 tur' boyunca '1.5 "
                                      "katına' çıkartır. Ancak bu ritüel zaman "
                                      "aldığı için tur düşmana geçer."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Güçlendirme: 1.5 x AP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Tur Devamlılığı: 3 Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/guc_patlamasi.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                gucPatlamasiTuru == 0 &&
                                                fourthSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (fourthSkillCD != 0)
                                    Text(
                                      "$fourthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Sarsılmaz Vücut Yeteneği
                        if (widget.character.characterClass == 'Barbar' &&
                            widget.character.fifthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      sarsilmazVucutTuru == 0 &&
                                      fifthSkillCD == 0
                                  ? sarsilmazVucut()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : sarsilmazVucutTuru > 0
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Sarsılmaz Vücut",
                                  "Bu yetenek '1 Aksiyon Barı' harcayarak "
                                      "oyuncunun Savunma Değerini, bulunduğu "
                                      "turla beraber '2 tur' boyunca '2 katına'"
                                      " çıkartır. Ancak bu ritüel zaman "
                                      "aldığı için tur düşmana geçer."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Güçlendirme: 2 x DP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Tur Devamlılığı: 2 Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/sarsilmaz_vucut.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                sarsilmazVucutTuru == 0 &&
                                                fifthSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (fifthSkillCD != 0)
                                    Text(
                                      "$fifthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // ----------------------------------------------------
                        // Paladin Yetenekleri;
                        // Kutsanmış Yeteneği
                        if (widget.character.characterClass == 'Paladin' &&
                            widget.character.firstSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      firstSkillCD == 0
                                  ? kutsanmis()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Kutsanmış",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "bulunduğu turda düşmana, 'art arda 2 "
                                      "kez' Normal Saldırı Değeri kadar hasar "
                                      "uygular."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Verilen Hasar: 1 x AP\n"
                                      "Atılan Zar: 2 Adet\n"
                                      "Sonraki Tur: Düşmanın",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/kutsanmis.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                firstSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (firstSkillCD != 0)
                                    Text(
                                      "$firstSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Kutsal Odak Yeteneği
                        if (widget.character.characterClass == 'Paladin' &&
                            widget.character.secondSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      secondSkillCD == 0
                                  ? kutsalOdak()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Kutsal Odak",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "bulunduğu turda düşmana, Normal Saldırı "
                                      "Değeri kadar hasar uygular. Fakat bu "
                                      "yetenekteki odak etkisi sayesinde "
                                      "oyuncu, düşmana bir kez daha "
                                      "saldırabilir."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Verilen Hasar: 1 x AP\n"
                                      "Sonraki Tur: Oyuncunun",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/kutsal_odak.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                secondSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (secondSkillCD != 0)
                                    Text(
                                      "$secondSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Seçilmiş İrade Yeteneği
                        if (widget.character.characterClass == 'Paladin' &&
                            widget.character.thirdSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      secilmisIradeTuru == false &&
                                      thirdSkillCD == 0
                                  ? secilmisIrade()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : secilmisIradeTuru
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Seçilmiş İrade",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "sonraki tur oyuncu için atılan zarın "
                                      "'Zar Değerini' arttırır. Ancak bu "
                                      "ritüel zaman aldığı için tur düşmana "
                                      "geçer."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Güçlendirme: Zar Değeri\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Etki: Sonraki Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/secilmis_irade.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                secilmisIradeTuru == false &&
                                                thirdSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (thirdSkillCD != 0)
                                    Text(
                                      "$thirdSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Paladinin Duası Yeteneği
                        if (widget.character.characterClass == 'Paladin' &&
                            widget.character.fourthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar <
                                          maxMagicBar &&
                                      fourthSkillCD == 0
                                  ? palanininDuasi()
                                  : bottomAlert(
                                      widget.character.magicBar == maxMagicBar
                                          ? "Aksiyon Barı tamamen dolu!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Paladin'in Duası",
                                  "Bu yetenek oyuncunun '1 Aksiyon Barı' "
                                      "yenilemesini sağlar. Ancak bu ritüel "
                                      "zaman aldığı için tur düşmana geçer."
                                      "\n\n"
                                      "İyileşme: 1 MP\n"
                                      "Sonraki Tur: Düşmanın",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/paladinin_duasi.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter: widget.character.magicBar <
                                                maxMagicBar &&
                                            fourthSkillCD == 0
                                        ? null
                                        : ColorFilter.mode(
                                            Colors.deepOrange.shade600
                                                .withOpacity(0.7),
                                            BlendMode.modulate,
                                          ),
                                  ),
                                  if (fourthSkillCD != 0)
                                    Text(
                                      "$fourthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Ruhani Vücut Yeteneği
                        if (widget.character.characterClass == 'Paladin' &&
                            widget.character.fifthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      widget.character.health <
                                          widget.character.maxHealth &&
                                      fifthSkillCD == 0
                                  ? ruhaniVucut()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : widget.character.health ==
                                                  widget.character.maxHealth
                                              ? "Can Değeri tamamen dolu!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Ruhani Vücut",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve şansa "
                                      "bağlı olarak oyuncunun Can Değerini "
                                      "'10-50 Puan' aralığında iyileştirir. "
                                      "Ancak bu ritüel zaman aldığı için tur "
                                      "düşmana geçer."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "İyileşme: 10-50 HP\n"
                                      "Sonraki Tur: Düşmanın",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/ruhani_vucut.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter: widget.character.magicBar >
                                                0 &&
                                            widget.character.health <
                                                widget.character.maxHealth &&
                                            fifthSkillCD == 0
                                        ? null
                                        : ColorFilter.mode(
                                            Colors.deepOrange.shade600
                                                .withOpacity(0.7),
                                            BlendMode.modulate,
                                          ),
                                  ),
                                  if (fifthSkillCD != 0)
                                    Text(
                                      "$fifthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // ----------------------------------------------------
                        // Hırsız Yetenekleri;
                        // Şaşırtmaca Yeteneği
                        if (widget.character.characterClass == 'Hırsız' &&
                            widget.character.firstSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      firstSkillCD == 0
                                  ? sasirtmaca()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Şaşırtmaca",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve şansa "
                                      "bağlı olarak düşmanın zihnini bulandırır. "
                                      "Ancak bu ritüel zaman aldığı için tur "
                                      "düşmana geçer.\n\n"
                                      "Zihni bulanan düşman, 'kendi hasarının' "
                                      "tamamını yada hasarının yarısını "
                                      "kendisine isabet ettirir. Eğer hasarın "
                                      "yarısı düşmana isabet ederse, kalan "
                                      "yarısı oyuncuya isabet eder."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Zayıflatma: Saldırı Bozma\n"
                                      "Sonraki Tur: Düşmanın",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/sasirtmaca.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                firstSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (firstSkillCD != 0)
                                    Text(
                                      "$firstSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Manipülaston Yeteneği
                        if (widget.character.characterClass == 'Hırsız' &&
                            widget.character.secondSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      manipulasyonTuru == 0 &&
                                      secondSkillCD == 0
                                  ? manipulasyon()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : manipulasyonTuru > 0
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Manipülasyon",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve '3 tur' "
                                      "boyunca düşman için atılan zarın 'Zar "
                                      "Değerini' azaltır. Ancak bu ritüel zaman "
                                      "aldığı için tur düşmana geçer."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Zayıflatma: Zar Değeri\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Tur Devamlılığı: 3 Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/manipulasyon.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                manipulasyonTuru == 0 &&
                                                secondSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (secondSkillCD != 0)
                                    Text(
                                      "$secondSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Ruh Hırsızı Yeteneği
                        if (widget.character.characterClass == 'Hırsız' &&
                            widget.character.thirdSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  (widget.character.magicBar < maxMagicBar ||
                                              widget.character.health <
                                                  widget.character.maxHealth) &&
                                          thirdSkillCD == 0
                                      ? ruhHirsizi()
                                      : bottomAlert(
                                          widget.character.health ==
                                                  widget.character.maxHealth
                                              ? "Can Değeri tamamen dolu!!!"
                                              : widget.character.magicBar ==
                                                      maxMagicBar
                                                  ? "Aksiyon Barı tamamen dolu!!!"
                                                  : "Yetenek bekleme süresi içinde!!!",
                                        ),
                              onLongPress: () {
                                showInfo(
                                  "Ruh Hırsızı",
                                  "Bu yetenek ile oyuncu, düşmanın Can "
                                      "Değerinden '10-50 Puan' kadar Can "
                                      "Değerini kendisi için çalmasını sağlar. "
                                      "Aynı zamanda, bu hamle oyuncuya '1 Aksiyon "
                                      "Barı' yenileme fırsatı verir."
                                      "\n\n"
                                      "Zayıflatma: 10-50 HP\n"
                                      "İyileşme: 1 MP ve 10-50 HP\n"
                                      "Sonraki Tur: Düşmanın",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/ruh_hirsizi.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter: (widget.character.magicBar <
                                                    maxMagicBar ||
                                                widget.character.health <
                                                    widget
                                                        .character.maxHealth) &&
                                            thirdSkillCD == 0
                                        ? null
                                        : ColorFilter.mode(
                                            Colors.deepOrange.shade600
                                                .withOpacity(0.7),
                                            BlendMode.modulate,
                                          ),
                                  ),
                                  if (thirdSkillCD != 0)
                                    Text(
                                      "$thirdSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Hileli Zar Yeteneği
                        if (widget.character.characterClass == 'Hırsız' &&
                            widget.character.fourthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      fourthSkillCD == 0
                                  ? hileliZar()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Hileli Zar",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "oyuncuya mevcut tur için '2 farklı' zar "
                                      "atma şansı ve tekrar saldırma hakkı verir."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Güçlendirme: Zar Değeri\n"
                                      "Sonraki Tur: Oyuncunun",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/hileli_zar.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                fourthSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (fourthSkillCD != 0)
                                    Text(
                                      "$fourthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Ölümcül Vuruş Yeteneği
                        if (widget.character.characterClass == 'Hırsız' &&
                            widget.character.fifthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      fifthSkillCD == 0
                                  ? olumculVurus()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Ölümcül Vuruş",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve oyuncu "
                                      "şansa bağlı olarak düşmana büyük bir "
                                      "hasar uygular. Bu saldırı, oyuncu "
                                      "şansına göre yön değiştirebilir ve hem "
                                      "düşman hemde oyuncu büyük hasarlar "
                                      "alabilir. Kullanırken dikkatli olunması "
                                      "gerekir."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Verilen Hasar: 3 x AP\n"
                                      "Hasar Tepmesi: Değişken\n"
                                      "Sonraki Tur: Düşmanın",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/olumcul_vurus.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                fifthSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (fifthSkillCD != 0)
                                    Text(
                                      "$fifthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // ----------------------------------------------------
                        // Korucu Yetenekleri;
                        // Çevik Adım Yeteneği
                        if (widget.character.characterClass == 'Korucu' &&
                            widget.character.firstSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      firstSkillCD == 0
                                  ? cevikAdim()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Çevik Adım",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve mevcut "
                                      "turda düşmana, Normal Saldırı Değeri "
                                      "kadar hasar uygular. Ek olarak hasarın "
                                      "yanında '%50 şansla' oyuncuya bir kez "
                                      "daha aksiyon alma fırsatı sunar."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Verilen Hasar: 1 x AP\n"
                                      "Sonraki Tur: Değişken",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/cevik_adim.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                firstSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (firstSkillCD != 0)
                                    Text(
                                      "$firstSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Zehirli Saldırı Yeteneği
                        if (widget.character.characterClass == 'Korucu' &&
                            widget.character.secondSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      zehirSaldirisiTuru == 0 &&
                                      secondSkillCD == 0
                                  ? zehirliSaldiri()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : zehirSaldirisiTuru > 0
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Zehirli Saldırı",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve mevcut "
                                      "turda düşmana, Normal Saldırı Değeri "
                                      "kadar hasar uygular. Ek olarak düşmanı, "
                                      "'3 tur' boyunca zehir etkisine maruz "
                                      "bırakır. Zehir etkisi Normal Saldırı "
                                      "Değerinin 'yarısı' kadar etkilidir."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Verilen Hasar: 1 x AP\n"
                                      "Güçlendirme: 0.5 x AP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Etki: Sonraki Tur\n"
                                      "Tur Devamlılığı: 3 Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/zehirli_saldiri.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                zehirSaldirisiTuru == 0 &&
                                                secondSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (secondSkillCD != 0)
                                    Text(
                                      "$secondSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Dengesiz Rüzgar Yeteneği
                        if (widget.character.characterClass == 'Korucu' &&
                            widget.character.thirdSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      thirdSkillCD == 0
                                  ? dengesizRuzgar()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Dengesiz Rüzgar",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve mevcut "
                                      "turda düşmana, Normal Saldırı Değerinin "
                                      "'2 katı' kadar bir hasar uygular. Şansa "
                                      "bağlı olarak bu yetenek 'sonraki tur' "
                                      "düşmanın saldırısını kendisine "
                                      "uygulamasını sağlar. Eğer oyuncu çok "
                                      "şanslıysa düşmana kendine kendi "
                                      "Saldırı Değerinin '2 katını' uygulatır."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Verilen Hasar: 2 x AP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Etki: Sonraki Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/dengesiz_ruzgar.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                thirdSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (thirdSkillCD != 0)
                                    Text(
                                      "$thirdSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Doğanın Hediyesi Yeteneği
                        if (widget.character.characterClass == 'Korucu' &&
                            widget.character.fourthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      widget.character.health <
                                          widget.character.maxHealth &&
                                      fourthSkillCD == 0
                                  ? doganinHediyesi()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : widget.character.health ==
                                                  widget.character.maxHealth
                                              ? "Can Değeri tamamen dolu!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Doğanın Hediyesi",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve şansa "
                                      "bağlı olarak oyuncunun Can Değerini "
                                      "'7-30 Puan' aralığında iyileştirir. Ek "
                                      "olarak bu yetenek öyle hızlıdır ki, "
                                      "oyuncu bir tur daha saldırı yapabilir."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "İyileşme: 7-30 Can Değeri\n"
                                      "Sonraki Tur: Oyuncunun",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/doganin_hediyesi.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter: widget.character.magicBar >
                                                0 &&
                                            widget.character.health <
                                                widget.character.maxHealth &&
                                            fourthSkillCD == 0
                                        ? null
                                        : ColorFilter.mode(
                                            Colors.deepOrange.shade600
                                                .withOpacity(0.7),
                                            BlendMode.modulate,
                                          ),
                                  ),
                                  if (fourthSkillCD != 0)
                                    Text(
                                      "$fourthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Ormanın Yankısı Yeteneği
                        if (widget.character.characterClass == 'Korucu' &&
                            widget.character.fifthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar <
                                          maxMagicBar &&
                                      !ormaninYankisiTuru &&
                                      ormaninYankisiSayac == 0 &&
                                      fifthSkillCD == 0
                                  ? ormaninYankisi()
                                  : bottomAlert(
                                      widget.character.magicBar == maxMagicBar
                                          ? "Aksiyon Barı tamamen dolu!!!"
                                          : ormaninYankisiTuru
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Ormanın Yankısı",
                                  "Bu yetenek oyuncuya '2 tur' boyunca, tur "
                                      "başına '1 Aksiyon Barı' yenilemesine "
                                      "olanak tanır. Ancak bu ritüel zaman "
                                      "aldığı için tur düşmana geçer."
                                      "\n\n"
                                      "İyileşme: 1+1 MP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Tur Devamlılığı: 2 Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/ormanin_yankisi.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter: widget.character.magicBar <
                                                maxMagicBar &&
                                            !ormaninYankisiTuru &&
                                            ormaninYankisiSayac == 0 &&
                                            fifthSkillCD == 0
                                        ? null
                                        : ColorFilter.mode(
                                            Colors.deepOrange.shade600
                                                .withOpacity(0.7),
                                            BlendMode.modulate,
                                          ),
                                  ),
                                  if (fifthSkillCD != 0)
                                    Text(
                                      "$fifthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // ----------------------------------------------------
                        // Büyücü Yetenekleri;
                        // Yarının Arzusu Yeteneği
                        if (widget.character.characterClass == 'Büyücü' &&
                            widget.character.firstSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      !yarininArzusuTuru &&
                                      yarininArzusuSayac <= 0 &&
                                      firstSkillCD == 0
                                  ? yarininArzusu()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : yarininArzusuTuru
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Yarının Arzusu",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve mevcut "
                                      "turun aksiyon hakkını sonraki tura "
                                      "devreder ve sonraki tur oyuncunun '2 "
                                      "kere' aksiyon almasını sağlar."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Etki: Sonraki Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/yarinin_arzusu.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                !yarininArzusuTuru &&
                                                yarininArzusuSayac <= 0 &&
                                                firstSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (firstSkillCD != 0)
                                    Text(
                                      "$firstSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Büyü Üstadı Yeteneği
                        if (widget.character.characterClass == 'Büyücü' &&
                            widget.character.secondSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  (widget.character.magicBar < maxMagicBar ||
                                              widget.character.health <
                                                  widget.character.maxHealth) &&
                                          secondSkillCD == 0
                                      ? buyuUstadi()
                                      : bottomAlert(
                                          widget.character.health ==
                                                  widget.character.maxHealth
                                              ? "Can Değeri tamamen dolu!!!"
                                              : widget.character.magicBar ==
                                                      maxMagicBar
                                                  ? "Aksiyon Barı tamamen dolu!!!"
                                                  : "Yetenek bekleme süresi içinde!!!",
                                        ),
                              onLongPress: () {
                                showInfo(
                                  "Büyü Üstadı",
                                  "Bu yetenek oyuncunun '1 Aksiyon Barını' "
                                      "yeniler ve ardından oyuncunun toplam "
                                      "Aksiyon Barı miktarına göre oyuncunun "
                                      "Can Değerini 25-50 Puan kadar yeniler. "
                                      "Ancak bu ritüel zaman aldığı için tur "
                                      "düşmana geçer."
                                      "\n\n"
                                      "İyileşme: 1 MP\n"
                                      "Ekstra İyileşme: 25-50 HP\n"
                                      "Sonraki Tur: Düşmanın",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/buyu_ustadi.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter: (widget.character.magicBar <
                                                    maxMagicBar ||
                                                widget.character.health <
                                                    widget
                                                        .character.maxHealth) &&
                                            secondSkillCD == 0
                                        ? null
                                        : ColorFilter.mode(
                                            Colors.deepOrange.shade600
                                                .withOpacity(0.7),
                                            BlendMode.modulate,
                                          ),
                                  ),
                                  if (secondSkillCD != 0)
                                    Text(
                                      "$secondSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Yıldırım Ruhu Yeteneği
                        if (widget.character.characterClass == 'Büyücü' &&
                            widget.character.thirdSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      yildirimRuhuTuru == 0 &&
                                      thirdSkillCD == 0
                                  ? yildirimRuhu()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : yildirimRuhuTuru > 0
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Yıldırım Ruhu",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve savaşa "
                                      "bir yıldırım ruhu çağırır. Çağrılan ruh, "
                                      "çağrıldığı an düşmana oyuncunun Normal "
                                      "Saldırı Değeri kadar hasar verir ve "
                                      "sonraki '2 tur' boyunca ruh kendine "
                                      "özel bir hasarla saldırılarına devam "
                                      "eder. 2 turun sonunda ise ruh kaybolur. "
                                      "Çağırma ritüeli uzun sürdüğü için tur "
                                      "düşmana geçer."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Verilen Hasar: 1 x AP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Etki: Sonraki Tur\n"
                                      "Tur Devamlılığı: 2 Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/yildirim_ruhu.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                yildirimRuhuTuru == 0 &&
                                                thirdSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (thirdSkillCD != 0)
                                    Text(
                                      "$thirdSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Halüsinasyon Yeteneği
                        if (widget.character.characterClass == 'Büyücü' &&
                            widget.character.fourthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      !halusinasyonTuru &&
                                      fourthSkillCD == 0
                                  ? halusinasyon()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : halusinasyonTuru
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Halüsinasyon",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve savaş "
                                      "meydanına '4 halüsinasyon kopyası' "
                                      "oluşturur. Bu durum düşmanın doğru "
                                      "vücudu bulana kadar saldırılar "
                                      "uygulamasına neden olur. Ancak bu ritüel "
                                      "zaman aldığı için tur düşmana geçer. "
                                      "Düşman herhangi bir kopyaya uyguladığı "
                                      "her hasar sonrası o kopya yok olur, ta "
                                      "ki gerçek oyuncuya hasar uygulayana dek. "
                                      "Düşman gerçek oyuncuya hasar "
                                      "uyguladığında yetenek bozulur."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Etki: Sonraki Tur\n"
                                      "Tur Devamlılığı: 1-5 Tur",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/halusinasyon.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                !halusinasyonTuru &&
                                                fourthSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (fourthSkillCD != 0)
                                    Text(
                                      "$fourthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        // Kaderin Çağrısı Yeteneği
                        if (widget.character.characterClass == 'Büyücü' &&
                            widget.character.fifthSkillLock)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.character.magicBar > 0 &&
                                      !kaderinCagrisiTuru &&
                                      fifthSkillCD == 0
                                  ? kaderinCagrisi()
                                  : bottomAlert(
                                      widget.character.magicBar == 0
                                          ? "Yeteri miktarda Aksiyon Barı yok!!!"
                                          : kaderinCagrisiTuru
                                              ? "Yetenek hala aktif!!!"
                                              : "Yetenek bekleme süresi içinde!!!",
                                    ),
                              onLongPress: () {
                                showInfo(
                                  "Kaderin Çağrısı",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "etkisini savaş sonuna kadar "
                                      "sürdürebilecek bir 'hasar güçlendirmesi' "
                                      "oluşturur. Ancak bu ritüel zaman aldığı "
                                      "için tur düşmana geçer. Bu güçlendirme "
                                      "her şanslı zar atışı sonrası oyuncunun "
                                      "Saldırı Değerine ek olarak Normal "
                                      "Saldırı Değerinin 'yarısı' kadar bir 'ek "
                                      "hasar' sağlar. Eğer oyuncu şanssız bir "
                                      "zar atışı yaparsa büyü bozulur fakat "
                                      "yapmazsa yetenek hep aktif kalır."
                                      "\n\n"
                                      "Kullanım Bedeli: 1 MP\n"
                                      "Güçlendirme: 0.5 x AP\n"
                                      "Sonraki Tur: Düşmanın\n"
                                      "Etki: Sonraki Tur\n"
                                      "Devamlılık: Tüm Turlar\n"
                                      "Tur Devamlılığı: 1-2-3 Zar Değerleri",
                                  false,
                                );
                              },
                              splashColor:
                                  Colors.lightGreenAccent.withOpacity(0.3),
                              highlightColor:
                                  Colors.lightGreenAccent.withOpacity(0.15),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Ink.image(
                                    image: const AssetImage(
                                      "assets/images/icons/skills/kaderin_cagrisi.png",
                                    ),
                                    width: width * 0.175,
                                    height: width * 0.175,
                                    fit: BoxFit.fill,
                                    colorFilter:
                                        widget.character.magicBar > 0 &&
                                                !kaderinCagrisiTuru &&
                                                fifthSkillCD == 0
                                            ? null
                                            : ColorFilter.mode(
                                                Colors.deepOrange.shade600
                                                    .withOpacity(0.7),
                                                BlendMode.modulate,
                                              ),
                                  ),
                                  if (fifthSkillCD != 0)
                                    Text(
                                      "$fifthSkillCD",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.06,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 25.0,
                                              color: Colors.cyan,
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            // Zar atılma sırasında olacak scaffold ağacı
            if (showDiceTurn)
              Positioned(
                top: height * 0.45,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isRollDice) SizedBox(height: height * 0.15),
                    Padding(
                      padding: EdgeInsets.only(
                        right: width * 0.05,
                        left: width * 0.05,
                      ),
                      child: Text(
                        turnIndicator,
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.045, color: Colors.black87),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    // Zar videosu gösterme kısmı
                    if (isRollDice)
                      Padding(
                        padding: EdgeInsets.only(
                          right: width * 0.08,
                          left: width * 0.08,
                        ),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    // Zar altı yazısı gösterme kısmı
                    if (showDamage) ...[
                      SizedBox(height: height * 0.02),
                      // Oyuncunun hasar yazısını gösterme
                      if (playerRoll != 1 && playerAttack != 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tur sonunda ",
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.04,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                            Text(
                              "$playerAttack ",
                              style: baseNumberStyle.copyWith(
                                  fontSize: width * 0.03,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                            Text(
                              "puan hasar uygulandı!",
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.04,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                          ],
                        ),
                      ],
                      // Düşmanın hasar yazısını gösterme
                      if (enemyRoll != 1 && enemyAttack != 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tur sonunda ",
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.04,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                            Text(
                              "$enemyAttack ",
                              style: baseNumberStyle.copyWith(
                                  fontSize: width * 0.03,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                            Text(
                              "puan hasar uygulandı!",
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.04,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                          ],
                        ),
                      ],
                      // Hasar uygulanamadı yazısını gösterme
                      if ((playerRoll == 1 || playerAttack == 0) &&
                          (enemyRoll == 1 || enemyAttack == 0)) ...[
                        Text(
                          "Bu tur hasar uygulanamadı!",
                          style: baseTextStyle.copyWith(
                              fontSize: width * 0.04, color: Colors.black87),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
                    ]
                  ],
                ),
              ),
            // Devam butonu kısmı
            if (showButton)
              Positioned(
                bottom: height * 0.09,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.06,
                    right: width * 0.06,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.black.withOpacity(0.2);
                          }
                          return null;
                        },
                      ),
                    ),
                    onPressed: () {
                      // Düşman zarı attıktan sonra olacaklar
                      if (!isPlayerDice) {
                        setState(() {
                          turnIndicator = "";
                          turnSkillIndicator = "Sıra sende!";
                          showDiceTurn = false;
                          isRollDice = false;
                          enemyAttack = 0;
                          enemyRoll = 0;
                        });
                      }
                      // Oyuncu zarı attıktan sonra olacaklar
                      if (isPlayerDice) {
                        if (firstSkillCD != 0) {
                          firstSkillCD--;
                        }
                        if (secondSkillCD != 0) {
                          secondSkillCD--;
                        }
                        if (thirdSkillCD != 0) {
                          thirdSkillCD--;
                        }
                        if (fourthSkillCD != 0) {
                          fourthSkillCD--;
                        }
                        if (fifthSkillCD != 0) {
                          fifthSkillCD--;
                        }
                        // Oyuncu özel bir ek tur kazancı yoksa olacaklar
                        if (!ozelTurEffect || turGecikmesi > 0) {
                          setState(() {
                            turGecikmesi--;
                            turnIndicator = "Sıra düşmanda!";
                            isRollDice = true;
                            enemyAttackAction();
                          });
                        } else {
                          // Oyuncu özel bir tur kazancı varsa olacaklar
                          // Tur tekrar oyuncudaysa ve başka etki yoksa olanlar
                          if (tekrarTurKarakterde) {
                            if (widget.enemy.health > 0) {
                              setState(() {
                                turnSkillIndicator = "Tur tekrar sende!";
                                showDiceTurn = false;
                                tekrarTurKarakterde = false;
                                ozelTurEffect = false;
                              });
                            } else {
                              showResultDialog(
                                  "Düşmanı alt etmeyi başardın!", true);
                            }
                          }
                          // Yarının Arzusu Yeteneği etki kısmı
                          if (yarininArzusuTuru) {
                            if (widget.enemy.health > 0) {
                              setState(() {
                                turnSkillIndicator = "Yarının arzusu "
                                    "sayesinde tur tekrar sende!";
                                showDiceTurn = false;
                                yarininArzusuSayac--;
                                if (yarininArzusuSayac == 0) {
                                  yarininArzusuTuru = false;
                                  ozelTurEffect = false;
                                }
                              });
                            } else {
                              showResultDialog(
                                  "Düşmanı alt etmeyi başardın!", true);
                            }
                          }
                        }
                      }
                      // Butona basılınca kesin olacaklar
                      showButton = false;
                      showDamage = false;
                      playerAttack = 0;
                      playerRoll = 0;
                    },
                    child: Text(
                      "Devam Et",
                      style: baseTextStyle.copyWith(
                          fontSize: width * 0.06, color: Colors.green),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                  ),
                ),
              ),
            // Reklam Bannerı
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: _googleAds.warPageBannerAd != null
                    ? SizedBox(
                        width:
                            _googleAds.warPageBannerAd!.size.width.toDouble(),
                        height:
                            _googleAds.warPageBannerAd!.size.height.toDouble(),
                        child: AdWidget(
                          ad: _googleAds.warPageBannerAd!,
                        ),
                      )
                    : null,
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
