import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/pages/daily_page.dart';
import 'package:corrupted_island_android/pages/inventory_page.dart';
import 'package:corrupted_island_android/pages/home_page.dart';
import 'package:corrupted_island_android/pages/market_page.dart';
import 'package:corrupted_island_android/pages/production_page.dart';
import 'package:corrupted_island_android/pages/upgrade_page.dart';
import 'package:corrupted_island_android/pages/war_page.dart';
import 'package:corrupted_island_android/process_file/object_enemies.dart';
import 'package:corrupted_island_android/process_file/game_appbar.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:corrupted_island_android/process_file/google_ads.dart';
import 'package:corrupted_island_android/process_file/story_progress.dart';
import 'package:corrupted_island_android/pages/shop_page.dart';
import 'package:corrupted_island_android/process_file/object_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final Character character;
  final String hikayeNoktasi;

  const GamePage({
    super.key,
    required this.character,
    required this.hikayeNoktasi,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  late StoryProgress storyProgress;
  late bool isGameOver;
  late int maxMagicBar;
  bool isDescriptionComplete = false;
  bool isTyping = true;
  String fullText = '';
  String displayedText = '';
  Timer? typingTimer;
  String hikaye = "";

  int saldiriDegeri = 0;
  int savunmaDegeri = 0;
  int strength = 0;
  int intelligence = 0;
  int dexterity = 0;
  int charisma = 0;

  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  Duration? position;
  double musicSesSeviyesi = 0.5;
  double effectSesSeviyesi = 1.0;

  late GoogleAds _googleAds;
  List<Item> dukkanItemleri = [];

  @override
  void initState() {
    _googleAds = GoogleAds();
    _googleAds.loadInterstitialAd(
      showAfterLoad: false,
      onAdClosed: () {},
    );
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    storyProgress = StoryProgress(
      character: widget.character,
      inventory: widget.character.inventory,
    );
    hikaye = widget.hikayeNoktasi;
    storyProgress.currentNode = hikaye;
    setStoryText();
    startTyping();
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
    widget.character.saveCharacterData();
    if (widget.character.health > 0) {
      isGameOver = false;
    } else {
      isGameOver = true;
    }
    loadAdData();
    loadVolumeSettings();
    playSound();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.character.firstEntryGamePage == 0) {
        firstLookThePages();
      }
    });
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    audioPlayer.dispose();
    _effectPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                      "Ana Oyun Sayfası",
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
                              "Burası, oyunun ana oyun sayfasıdır! Burada, hikayeyi "
                              "adım adım deneyimleyebileceğiniz ve yaptığınız "
                              "seçimlerle kaderinizi şekillendirebileceğiniz özel bir "
                              "yerdir. Burada yapacağınız seçimlerle hikayede ilerleyecek "
                              "ve yaptığınız her seçimle bambaşka hikayelerin ve anların "
                              "kilidini açabiliceksiniz. Bu sayfada, karakterinizin "
                              "can, aksiyon barı durumlarını ve diğer önemli değerleri "
                              "(şans kartı, altın, potlar gibi) görüntüleyebilirsiniz. "
                              "İhtiyaç duyduğunuzda potları kullanarak karakterinizi "
                              "güçlendirebilir ve maceranıza devam edebilirsiniz. "
                              "Ayrıca, oyun içi market ve envanter sayfalarına "
                              "buradan hızlıca erişim sağlayabilirsiniz. "
                              "Kısacası, burası hem karakterinizin durumunu "
                              "takip edebileceğiniz hem de hikayenin akışını "
                              "deneyimleyebileceğiniz en önemli sayfadır!",
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
                        widget.character.firstEntryGamePage++;
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

  void loadAdData() {
    _googleAds.loadGamePageBannerAd(
      adLoaded: () {
        setState(() {});
      },
    );
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

  void _loadEquipment() async {
    await widget.character.loadCharacterData();
    setState(() {
      _updateStats();
    });
  }

  void _updateStats() {
    saldiriDegeri = 0;
    savunmaDegeri = 0;
    strength = 0;
    intelligence = 0;
    dexterity = 0;
    charisma = 0;

    switch (widget.character.race) {
      case 'İnsan':
        strength += 10;
        intelligence += 10;
        dexterity += 10;
        charisma += 10;
        break;
      case 'Elf':
        strength += 5;
        intelligence += 10;
        dexterity += 20;
        charisma += 5;
        break;
      case 'Cüce':
        strength += 15;
        intelligence += 5;
        dexterity += 5;
        charisma += 15;
        break;
      case 'Yarı İnsan':
        strength += 5;
        intelligence += 5;
        dexterity += 10;
        charisma += 20;
        break;
      case 'Yarı Ork':
        strength += 20;
        intelligence += 5;
        dexterity += 5;
        charisma += 10;
        break;
      case 'Yarı Şeytan':
        strength += 5;
        intelligence += 20;
        dexterity += 5;
        charisma += 15;
        break;
    }

    for (var item in widget.character.equippedItems) {
      if (item != null) {
        saldiriDegeri += item.attackPoint;
        savunmaDegeri += item.defensePoint;
        strength += item.strengthPoint;
        intelligence += item.intelligencePoint;
        dexterity += item.dexterityPoint;
        charisma += item.charismaPoint;
      }
    }

    strength += widget.character.strengthPlus;
    intelligence += widget.character.intelligencePlus;
    dexterity += widget.character.dexterityPlus;
    charisma += widget.character.charismaPlus;
  }

  void playSound() async {
    await audioPlayer.setVolume(musicSesSeviyesi);
    await audioPlayer.play(
      AssetSource('sounds/game_sounds/game_page_base_music.mp3'),
    );
    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer
          .play(AssetSource('sounds/game_sounds/game_page_base_music.mp3'));
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

  void saveNode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("mevcutHikayeNoktası", storyProgress.currentNode);
  }

  void setStoryText() {
    final rawText =
        storyProgress.storyNodes[storyProgress.currentNode]!.description;
    fullText = storyProgress.processText(rawText);
    displayedText = '';
    isDescriptionComplete = false;
    isTyping = true;
  }

  void startTyping() {
    typingTimer?.cancel();
    typingTimer = Timer.periodic(
      const Duration(milliseconds: 25),
      (timer) {
        if (displayedText.length < fullText.length) {
          setState(() {
            displayedText += fullText[displayedText.length];
          });
        } else {
          timer.cancel();
          setState(() {
            isTyping = false;
            isDescriptionComplete = true;
          });
        }
      },
    );
  }

  void stopTyping() {
    typingTimer?.cancel();
  }

  void completeTyping() {
    typingTimer?.cancel();
    setState(() {
      displayedText = fullText;
      isTyping = false;
      isDescriptionComplete = true;
    });
  }

  void _openShopPage(List<Item> shopItems) async {
    stopTyping();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopPage(
          onItemPurchased: (item) {
            setState(() {
              widget.character.inventory.addItem(item);
            });
          },
          inventoryItems:
              widget.character.inventory.items.whereType<Item>().toList(),
          currentGold: widget.character.gold,
          updateGold: (newGold) {
            setState(() {
              widget.character.gold = newGold;
            });
          },
          tookGamePageItems: shopItems,
          character: widget.character,
        ),
      ),
    );
    setState(() {
      widget.character.entryShop += 1;
    });
    await widget.character.saveCharacterData();
    dukkanItemleri = [];
    startTyping();
  }

  void _openWarPage(Enemy enemy, String preNode, String currentNode) async {
    // Savaş öncesi kontrolleri
    setState(() {
      storyProgress.currentNode = preNode;
    });
    _loadEquipment();
    stopTyping();
    stopSound();

    // Savaş sayfası girişi
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WarPage(
          character: widget.character,
          enemy: enemy,
          saldiriDegeri: saldiriDegeri,
          savunmaDegeri: savunmaDegeri,
          strength: strength,
          intelligence: intelligence,
          dexterity: dexterity,
          charisma: charisma,
        ),
      ),
    );

    // Savaş sonrası kontrolleri
    setState(() {
      if (widget.character.health > 0) {
        isGameOver = false;
        widget.character.defeatedEnemies += 1;
        storyProgress.currentNode = currentNode;
      } else {
        isGameOver = true;
      }
    });
    switch (enemy.level) {
      case 1:
        widget.character.xp += 125;
        widget.character.totalEarnedXP += 125;
        break;
      case 2:
        widget.character.xp += 250;
        widget.character.totalEarnedXP += 250;
        break;
      case 3:
        widget.character.xp += 500;
        widget.character.totalEarnedXP += 500;
        break;
      case 4:
        widget.character.xp += 750;
        widget.character.totalEarnedXP += 750;
        break;
      case 5:
        widget.character.xp += 1000;
        widget.character.totalEarnedXP += 1000;
        break;
    }
    levelControl();
    await widget.character.saveCharacterData();
    startTyping();
    playSound();
  }

  void _openInventoryPage() async {
    stopTyping();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InventoryPage(
          character: widget.character,
        ),
      ),
    );
    setState(() {});
    await widget.character.saveCharacterData();
    startTyping();
    playSound();
  }

  void _openUpgradePage() async {
    stopTyping();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpgradePage(
          character: widget.character,
        ),
      ),
    );
    setState(() {});
    await widget.character.saveCharacterData();
    startTyping();
    playSound();
  }

  void _openDailyPage() async {
    stopTyping();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyPage(
          character: widget.character,
        ),
      ),
    );
    setState(() {});
    await widget.character.saveCharacterData();
    startTyping();
    playSound();
  }

  void _openProductionPage() async {
    stopTyping();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductionPage(
          character: widget.character,
        ),
      ),
    );
    setState(() {});
    await widget.character.saveCharacterData();
    startTyping();
    playSound();
  }

  void _openMarketPage() async {
    stopTyping();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarketPage(
          character: widget.character,
        ),
      ),
    );
    setState(() {});
    await widget.character.saveCharacterData();
    startTyping();
    playSound();
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
                      "Karakter Metrikleri",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.drop_fill,
                              color: Colors.red,
                              size: width * 0.06,
                            ),
                            Icon(
                              CupertinoIcons.arrow_right,
                              color: Colors.black87,
                              size: width * 0.04,
                            ),
                            Text(
                              " Can Potu",
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.0425),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                          ],
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.black.withOpacity(0.2);
                                }
                                return null;
                              },
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.arrowtriangle_right_fill,
                                size: width * 0.04,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                'Kullan',
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.04),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              if (widget.character.health <
                                      widget.character.maxHealth &&
                                  widget.character.healthPot > 0) {
                                widget.character.health += 25;
                                widget.character.healthPot--;
                                while (widget.character.health >
                                    widget.character.maxHealth) {
                                  widget.character.health--;
                                }
                              }
                            });
                            widget.character.saveCharacterData();
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.drop_fill,
                              color: Colors.blue,
                              size: width * 0.06,
                            ),
                            Icon(
                              CupertinoIcons.arrow_right,
                              color: Colors.black87,
                              size: width * 0.04,
                            ),
                            Text(
                              " Aksiyon Potu",
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.0425),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                          ],
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.black.withOpacity(0.2);
                                }
                                return null;
                              },
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.arrowtriangle_right_fill,
                                size: width * 0.04,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                'Kullan',
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.04),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              if (widget.character.magicBar < maxMagicBar &&
                                  widget.character.manaPot > 0) {
                                widget.character.magicBar += 1;
                                widget.character.manaPot--;
                              }
                            });
                            widget.character.saveCharacterData();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      "Diğer Metrik Bilgiler",
                      style: baseTextStyle.copyWith(fontSize: width * 0.06),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Icon(
                          Icons.card_membership,
                          color: Colors.red,
                          size: width * 0.06,
                        ),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.black87,
                          size: width * 0.04,
                        ),
                        Text(
                          " Mevcut Şans Kartı Miktarı",
                          style:
                              baseTextStyle.copyWith(fontSize: width * 0.0425),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: Colors.yellow[900],
                          size: width * 0.06,
                        ),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.black87,
                          size: width * 0.04,
                        ),
                        Text(
                          " Mevcut Altın Miktarı",
                          style:
                              baseTextStyle.copyWith(fontSize: width * 0.0425),
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

  void levelControl() {
    List<int> maxXpList = [
      0,
      1000,
      2500,
      5000,
      7500,
      10000,
      15000,
      20000,
      25000,
      50000,
      100000000,
    ];
    int currentLevel = widget.character.level;
    int currentXp = widget.character.xp;
    // Level atlamayı kontrol eden fonksiyon
    while (currentXp >= maxXpList[currentLevel] && currentLevel < 10) {
      currentXp -= maxXpList[currentLevel];
      currentLevel += 1;
      widget.character.maxXp = maxXpList[currentLevel];
      switch (currentLevel) {
        case 2:
          widget.character.skillPoints += 2;
          _openUpgradePage();
          break;
        case 3:
          widget.character.skillPoints += 1;
          widget.character.hizPoints += 2;
          break;
        case 4:
          widget.character.skillPoints += 1;
          widget.character.hizPoints += 2;
          break;
        case 5:
          widget.character.skillPoints += 1;
          widget.character.hizPoints += 2;
          break;
        case 6:
          widget.character.skillPoints += 1;
          widget.character.hizPoints += 1;
          break;
        case 7:
          widget.character.skillPoints += 2;
          widget.character.hizPoints += 1;
          break;
        case 8:
          widget.character.skillPoints += 2;
          widget.character.hizPoints += 1;
          break;
        case 9:
          widget.character.skillPoints += 2;
          widget.character.hizPoints += 2;
          break;
        case 10:
          widget.character.skillPoints += 3;
          widget.character.hizPoints += 4;
          break;
      }
    }
    widget.character.level = currentLevel;
    widget.character.xp = currentXp;
  }

  // Yapılan seçimlerin işlendiği bölge;
  Future<void> makeChoice(BuildContext context, StoryChoice choice) async {
    // Ana adım kontrolü ve ilerlemesi;
    setState(() {
      storyProgress.currentNode = choice.nextNode;
      setStoryText();
      startTyping();
    });

    // Test alanı seçimleri;
    // ------------------------------------------------------------------------
    if (storyProgress.currentNode == "test-alanı-dükkan") {
      List<Item> shopItems = [
        firstKilic,
        firstHancer,
        firstYay,
        firstArmor,
        firstHelmet,
        gizemliEldiven,
        kayaliklardakiSandik,
        maceraCagrisi,
        // --------------------------------------------------------------------
        odulBalta,
        odulArbalet,
        odulAsa,
        odulKalkan,
        odulBicak,
        odulRunik,
        randomOdulMigferTier1,
        randomOdulZirhTier1,
        randomOdulEldivenTier1,
        randomOdulAyakkabiTier1,
        odulZirh,
        odulTilsimTier1,
        odulTilsimTier2,
        // --------------------------------------------------------------------
        t1ShopSword1,
        t1ShopSword2,
        t1ShopSword3,
        t1ShopBow1,
        t1ShopBow2,
        t1ShopBow3,
        t1ShopDagger1,
        t1ShopDagger2,
        t1ShopDagger3,
        t1ShopAxe,
        t1ShopCrossbow,
        t1ShopStaff,
        t1ShopHelmet1,
        t1ShopHelmet2,
        t1ShopHelmet3,
        t1ShopArmor1,
        t1ShopArmor2,
        t1ShopArmor3,
        t1ShopBoot1,
        t1ShopBoot2,
        t1ShopBoot3,
        t1ShopAmulet,
        // --------------------------------------------------------------------
        t2ShopSword1,
        t2ShopBow1,
        t2ShopDagger1,
        t2ShopSword2,
        t2ShopBow2,
        t2ShopDagger2,
        t2ShopShield1,
        t2ShopKnife1,
        t2ShopRunic1,
        t2ShopShield2,
        t2ShopKnife2,
        t2ShopRunic2,
        t2ShopArmor1,
        t2ShopArmor2,
        t2ShopArmor3,
        t2ShopHelmet1,
        t2ShopArmor4,
        t2ShopHelmet2,
        t2ShopGlove1,
        t2ShopBoot1,
        t2ShopAmulet1,
        t2ShopAmulet2,
        t2ShopAmulet3,
        t2ShopAmulet4,
        t2ShopAmulet5,
        t2ShopAmulet6,
        t2ShopAmulet7,
        t2ShopAmulet8,
        t2ShopAmulet9,
        // --------------------------------------------------------------------
        t3ShopSword,
        t3ShopBow,
        t3ShopDagger,
        t3ShopAxe1,
        t3ShopCrossbow1,
        t3ShopStaff1,
        t3ShopAxe2,
        t3ShopCrossbow2,
        t3ShopStaff2,
        t3ShopShield1,
        t3ShopKnife1,
        t3ShopRunic1,
        t3ShopShield2,
        t3ShopKnife2,
        t3ShopRunic2,
        t3ShopArmor1,
        t3ShopHelmet1,
        t3ShopHelmet2,
        t3ShopArmor2,
        t3ShopGlove1,
        t3ShopGlove2,
        t3ShopArmor3,
        t3ShopBoot1,
        t3ShopBoot2,
        t3ShopAmulet1,
        t3ShopAmulet2,
        t3ShopAmulet3,
        t3ShopAmulet4,
        t3ShopAmulet5,
        t3ShopAmulet6,
        t3ShopAmulet7,
        t3ShopAmulet8,
        t3ShopAmulet9,
        t3ShopAmulet10,
        t3ShopAmulet11,
        t3ShopAmulet12,
      ];
      for (Item item in shopItems) {
        bool isAlreadyInShop = dukkanItemleri
            .any((existingItem) => existingItem.name == item.name);

        if (!isAlreadyInShop) {
          dukkanItemleri.add(item);
        }
      }
      _openShopPage(dukkanItemleri);
    }
    if (storyProgress.currentNode == "test-alanı-savaş") {
      Enemy enemy = exampleEnemies;
      String currentNode = storyProgress.currentNode;
      String previousNode = "test-alanı";
      _openWarPage(enemy, previousNode, currentNode);
    }
    if (storyProgress.currentNode == "test-alanı-malzeme-temel") {
      widget.character.gold += 100;
      widget.character.healthPot += 10;
      widget.character.manaPot += 10;
    }
    if (storyProgress.currentNode == "test-alanı-malzeme-şanskartı") {
      widget.character.luckCards += 1;
    }
    if (storyProgress.currentNode == "test-alanı-malzeme-sıfırlama") {
      widget.character.resetCards += 1;
    }
    if (storyProgress.currentNode == "test-alanı-malzeme-üretim") {
      widget.character.katalen += 500;
      widget.character.organikParcalar += 500;
      widget.character.bosSise += 10;
    }
    if (storyProgress.currentNode == "test-alanı-seviye") {
      switch (widget.character.level) {
        case 1:
          widget.character.xp += 1000;
          widget.character.totalEarnedXP += 1000;
          break;
        case 2:
          widget.character.xp += 2500;
          widget.character.totalEarnedXP += 2500;
          break;
        case 3:
          widget.character.xp += 5000;
          widget.character.totalEarnedXP += 5000;
          break;
        case 4:
          widget.character.xp += 7500;
          widget.character.totalEarnedXP += 7500;
          break;
        case 5:
          widget.character.xp += 10000;
          widget.character.totalEarnedXP += 10000;
          break;
        case 6:
          widget.character.xp += 15000;
          widget.character.totalEarnedXP += 15000;
          break;
        case 7:
          widget.character.xp += 20000;
          widget.character.totalEarnedXP += 20000;
          break;
        case 8:
          widget.character.xp += 25000;
          widget.character.totalEarnedXP += 25000;
          break;
        case 9:
          widget.character.xp += 50000;
          widget.character.totalEarnedXP += 50000;
          break;
        case 10:
          widget.character.xp += 0;
          widget.character.totalEarnedXP += 0;
          break;
      }
    }
    if (storyProgress.currentNode == "test-alanı-değerfulle") {
      switch (widget.character.race) {
        case 'İnsan':
          widget.character.health = 200;
          widget.character.magicBar = 3;
          break;
        case 'Elf':
          widget.character.health = 150;
          widget.character.magicBar = 4;
          break;
        case 'Cüce':
          widget.character.health = 250;
          widget.character.magicBar = 2;
          break;
        case 'Yarı İnsan':
          widget.character.health = 175;
          widget.character.magicBar = 4;
          break;
        case 'Yarı Ork':
          widget.character.health = 300;
          widget.character.magicBar = 1;
          break;
        case 'Yarı Şeytan':
          widget.character.health = 100;
          widget.character.magicBar = 6;
          break;
      }
    }
    if (storyProgress.currentNode == "test-alanı-oyunsonu") {
      widget.character.health -= 300;
      if (widget.character.health > 0) {
        isGameOver = false;
      } else {
        isGameOver = true;
      }
    }

    // Ana içerik;
    // ------------------------------------------------------------------------
    if (storyProgress.currentNode == "qo1-giriş1") {
      switch (widget.character.characterClass) {
        case 'Barbar':
          widget.character.inventory.addItem(firstKilic);
          break;
        case 'Paladin':
          widget.character.inventory.addItem(firstKilic);
          break;
        case 'Hırsız':
          widget.character.inventory.addItem(firstHancer);
          break;
        case 'Korucu':
          widget.character.inventory.addItem(firstYay);
          break;
        case 'Büyücü':
          widget.character.inventory.addItem(firstHancer);
          break;
      }
      widget.character.inventory.addItem(maceraCagrisi);
    }
    if (storyProgress.currentNode == "qo1-giriş2") {
      widget.character.inventory.addItem(firstHelmet);
      widget.character.inventory.addItem(firstArmor);
      widget.character.gold += 200;
      widget.character.healthPot += 10;
      widget.character.manaPot += 10;
      widget.character.bosSise += 10;
    }
    if (storyProgress.currentNode == "qo1-giriş3") {
      _openInventoryPage();
    }
    if (storyProgress.currentNode == "qo1-iskele1") {
      widget.character.daily = List.from(widget.character.daily)
        ..add(
          "    Adadaki lanet güçleniyor, sebebi bulunmalı. Gisen Limanı'nda "
          "hazırlık yap, Kensum Harabeleri'ne git. Adanın güneybatı "
          "çeyreği kontrol altında ama yozlaşma tamamen bitmiş değil, "
          "dikkatli ol!",
        );
    }
    if (storyProgress.currentNode == "qo1-iskele2") {
      _openDailyPage();
    }
    if (storyProgress.currentNode == "qo1-market2") {
      _openMarketPage();
    }
    if (storyProgress.currentNode == "qo1-lüksdükkan2") {
      List<Item> shopItems = [
        t3ShopSword,
        t3ShopBow,
        t3ShopDagger,
        t3ShopAxe1,
        t3ShopCrossbow1,
        t3ShopStaff1,
        t3ShopAxe2,
        t3ShopCrossbow2,
        t3ShopStaff2,
        t3ShopShield1,
        t3ShopKnife1,
        t3ShopRunic1,
        t3ShopShield2,
        t3ShopKnife2,
        t3ShopRunic2,
        t3ShopArmor1,
        t3ShopHelmet1,
        t3ShopHelmet2,
        t3ShopArmor2,
        t3ShopGlove1,
        t3ShopGlove2,
        t3ShopArmor3,
        t3ShopBoot1,
        t3ShopBoot2,
        t3ShopAmulet1,
        t3ShopAmulet2,
        t3ShopAmulet3,
        t3ShopAmulet4,
        t3ShopAmulet5,
        t3ShopAmulet6,
        t3ShopAmulet7,
        t3ShopAmulet8,
        t3ShopAmulet9,
        t3ShopAmulet10,
        t3ShopAmulet11,
        t3ShopAmulet12,
      ];
      for (Item item in shopItems) {
        bool isAlreadyInShop = dukkanItemleri
            .any((existingItem) => existingItem.name == item.name);

        if (!isAlreadyInShop) {
          dukkanItemleri.add(item);
        }
      }
      _openShopPage(dukkanItemleri);
    }
    if (storyProgress.currentNode == "qo1-normaldükkan2") {
      List<Item> shopItems = [
        t2ShopSword1,
        t2ShopBow1,
        t2ShopDagger1,
        t2ShopSword2,
        t2ShopBow2,
        t2ShopDagger2,
        t2ShopShield1,
        t2ShopKnife1,
        t2ShopRunic1,
        t2ShopShield2,
        t2ShopKnife2,
        t2ShopRunic2,
        t2ShopArmor1,
        t2ShopArmor2,
        t2ShopArmor3,
        t2ShopHelmet1,
        t2ShopArmor4,
        t2ShopHelmet2,
        t2ShopGlove1,
        t2ShopBoot1,
        t2ShopAmulet1,
        t2ShopAmulet2,
        t2ShopAmulet3,
        t2ShopAmulet4,
        t2ShopAmulet5,
        t2ShopAmulet6,
        t2ShopAmulet7,
        t2ShopAmulet8,
        t2ShopAmulet9,
      ];
      for (Item item in shopItems) {
        bool isAlreadyInShop = dukkanItemleri
            .any((existingItem) => existingItem.name == item.name);

        if (!isAlreadyInShop) {
          dukkanItemleri.add(item);
        }
      }
      _openShopPage(dukkanItemleri);
    }
    if (storyProgress.currentNode == "qo1-sönükdükkan2") {
      List<Item> shopItems = [
        t1ShopSword1,
        t1ShopSword2,
        t1ShopSword3,
        t1ShopBow1,
        t1ShopBow2,
        t1ShopBow3,
        t1ShopDagger1,
        t1ShopDagger2,
        t1ShopDagger3,
        t1ShopAxe,
        t1ShopCrossbow,
        t1ShopStaff,
        t1ShopHelmet1,
        t1ShopHelmet2,
        t1ShopHelmet3,
        t1ShopArmor1,
        t1ShopArmor2,
        t1ShopArmor3,
        t1ShopBoot1,
        t1ShopBoot2,
        t1ShopBoot3,
        t1ShopAmulet,
      ];
      for (Item item in shopItems) {
        bool isAlreadyInShop = dukkanItemleri
            .any((existingItem) => existingItem.name == item.name);

        if (!isAlreadyInShop) {
          dukkanItemleri.add(item);
        }
      }
      _openShopPage(dukkanItemleri);
    }
    if (storyProgress.currentNode == "qo1-üretim2") {
      _openProductionPage();
    }

    // if (storyProgress.currentNode == "") {}
    // ------------------------------------------------------------------------
    // Kritik seçim sayacı;
    if (storyProgress.currentNode == "qo1-dükkan2" ||
        storyProgress.currentNode == "qo1-baskın" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "") {
      widget.character.criticalChoice += 1;
      widget.character.xp += 100;
      widget.character.totalEarnedXP += 100;
    }

    // Her olay başı bonus xp ödüllendirmesi;
    if (storyProgress.currentNode == "qo1-giriş1" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "" ||
        storyProgress.currentNode == "") {
      widget.character.xp += 250;
      widget.character.totalEarnedXP += 250;
    }

    // Her seçim sonrası yapılan işlemler
    widget.character.totalChoice++;
    widget.character.xp += 50;
    widget.character.totalEarnedXP += 50;
    levelControl();
    widget.character.isReadyOpenInventory = true;
    await widget.character.saveCharacterData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final currentNode = storyProgress.storyNodes[storyProgress.currentNode]!;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
    );
    TextStyle baseNumberStyle = const TextStyle(
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.black87,
    );

    return PopScope(
      canPop: false,
      child: isGameOver
          ? Scaffold(
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: statusBarHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05),
                        Text(
                          "Oyun Bitti",
                          style: baseTextStyle.copyWith(
                              fontSize: width * 0.075, color: Colors.red[800]),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        SizedBox(height: height * 0.05),
                        Text(
                          "Merhum",
                          style: baseTextStyle.copyWith(
                              fontSize: width * 0.075, color: Colors.black87),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        SizedBox(height: height * 0.02),
                        CircleAvatar(
                          radius: width * 0.25,
                          backgroundImage: AssetImage(
                            widget.character.imagePath,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          widget.character.playerName,
                          style: baseTextStyle.copyWith(
                              fontSize: width * 0.075, color: Colors.black87),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.09,
                            right: width * 0.09,
                          ),
                          child: Text(
                            'Hakkında yazılan son bir kayıt:\n\n'
                            'Maceracı ${widget.character.playerName}, ${widget.character.race} ırkının cesur bir mensubu olarak, kader çizgisini ${widget.character.totalChoice} farklı seçimle şekillendirdi. '
                            'Bunların ${widget.character.criticalChoice} tanesi, onun yolunu tamamen değiştiren kader anlarıydı. '
                            'Karşısına çıkan ${widget.character.defeatedEnemies} düşmanı alt ederek yolunu temizledi; bu zaferler için ${widget.character.entryShop} farklı dükkanda duraklayıp '
                            '${widget.character.spentMoney} altın harcayarak ${widget.character.purchasedItem} farklı ekipman edindi. '
                            'Tüm bu savaşlar boyunca düşmanlarına toplam ${widget.character.totalDamageToEnemies} hasar verdi ve '
                            'bu tecrübelerle ${widget.character.totalEarnedXP} deneyim kazanarak ${widget.character.level}. seviyeye ulaştı. '
                            'Zorlu anlarda ${widget.character.usesLuckCards} kez şansa sarılarak ölümün kıyısından döndü.\n\n'
                            '${widget.character.playerName}’in bu yolculuğu, sadece Mocartim Adası’nın değil, tüm maceracılar loncasının hafızasına kazınacak bir destanın parçası haline geldi...',
                            style: baseNumberStyle.copyWith(
                                fontSize: width * 0.0375),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.green.shade700
                                      .withOpacity(0.75);
                                }
                                return Colors.green.shade600;
                              },
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.05,
                              ),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            shadowColor: WidgetStateProperty.all<Color>(
                                Colors.grey.shade300),
                            elevation: WidgetStateProperty.all<double>(10.0),
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.grey.shade300.withOpacity(0.25);
                                }
                                return Colors.transparent;
                              },
                            ),
                          ),
                          onPressed: () {
                            _resetGamePreferences();
                            stopSound();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          child: Text(
                            "Ana Menüye Dön",
                            style: baseTextStyle.copyWith(
                              fontSize: width * 0.1,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(3, 3),
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.75),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
                        SizedBox(height: height * 0.075),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Scaffold(
              extendBodyBehindAppBar: true,
              appBar: GameAppBar(
                character: widget.character,
                effectSesSeviyesi: effectSesSeviyesi,
                onUpdate: () {
                  setState(() {});
                },
              ),
              body: GestureDetector(
                onTap: () {
                  if (isTyping) {
                    completeTyping();
                  }
                },
                child: Container(
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
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: width * 0.06),
                                Icon(
                                  Icons.card_membership,
                                  color: Colors.red,
                                  size: width * 0.06,
                                ),
                                SizedBox(width: width * 0.01),
                                Text(
                                  "${widget.character.luckCards}",
                                  style: baseNumberStyle.copyWith(
                                      fontSize: width * 0.04),
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
                                  style: baseNumberStyle.copyWith(
                                      fontSize: width * 0.04),
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
                                  style: baseNumberStyle.copyWith(
                                      fontSize: width * 0.04),
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
                                  style: baseNumberStyle.copyWith(
                                      fontSize: width * 0.04),
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
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06,
                            ),
                            child: Column(
                              children: [
                                if (currentNode.image != null)
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const RadialGradient(
                                        center: Alignment.center,
                                        radius: 0.5,
                                        colors: [
                                          Colors.white,
                                          Colors.transparent,
                                        ],
                                        stops: [0.85, 1.0],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: Image.asset(
                                      currentNode.image!,
                                      height: width * 0.7,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                SizedBox(height: height * 0.02),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: width * 0.03,
                                    left: width * 0.03,
                                  ),
                                  child: Text(
                                    displayedText,
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.05,
                                        color: Colors.black87),
                                    textAlign: TextAlign.justify,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isDescriptionComplete)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.01,
                              horizontal: width * 0.04,
                            ),
                            child: Column(
                              children: currentNode.choices
                                  .where((choice) =>
                                      choice.condition == null ||
                                      choice.condition!(widget.character))
                                  .map(
                                    (choice) => Padding(
                                      padding: EdgeInsets.only(
                                        top: height * 0.01,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(35.0),
                                          onTap: () {
                                            makeChoice(context, choice);
                                            saveNode();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: height * 0.01,
                                              horizontal: width * 0.025,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .lightGreenAccent.shade400
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(35.0),
                                            ),
                                            child: Text(
                                              choice.displayText,
                                              style: baseTextStyle.copyWith(
                                                  fontSize: width * 0.04,
                                                  color: Colors.black87),
                                              textAlign: TextAlign.left,
                                              textScaler:
                                                  const TextScaler.linear(1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            child: _googleAds.gamePageBannerAd != null
                                ? SizedBox(
                                    width: _googleAds
                                        .gamePageBannerAd!.size.width
                                        .toDouble(),
                                    height: _googleAds
                                        .gamePageBannerAd!.size.height
                                        .toDouble(),
                                    child: AdWidget(
                                      ad: _googleAds.gamePageBannerAd!,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
