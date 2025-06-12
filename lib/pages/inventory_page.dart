import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/pages/daily_page.dart';
import 'package:corrupted_island_android/pages/production_page.dart';
import 'package:corrupted_island_android/pages/upgrade_page.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:corrupted_island_android/process_file/object_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  final Character character;

  const InventoryPage({
    super.key,
    required this.character,
  });

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with WidgetsBindingObserver {
  int saldiriDegeri = 0;
  int savunmaDegeri = 0;
  int strength = 0;
  int intelligence = 0;
  int dexterity = 0;
  int charisma = 0;
  String typeOfItem = "";
  bool isReadyForView = false;
  final AudioPlayer _effectPlayer = AudioPlayer();
  double effectSesSeviyesi = 1.0;

  // Sınıfa özel eşya sınırlaması;
  final Map<String, List<ItemType>> classItemRestrictions = {
    'Barbar': [
      // Özel Eşyalar
      ItemType.axe,
      ItemType.sword,
      ItemType.shield,
      // Genel Eşyalar
      ItemType.helmet,
      ItemType.armor,
      ItemType.gloves,
      ItemType.boots,
      ItemType.amulet,
      // Fonksiyonel Eşyalar
      ItemType.chests,
      ItemType.scrolls,
    ],
    'Paladin': [
      // Özel Eşyalar
      ItemType.axe,
      ItemType.sword,
      ItemType.bow,
      ItemType.shield,
      // Genel Eşyalar
      ItemType.helmet,
      ItemType.armor,
      ItemType.gloves,
      ItemType.boots,
      ItemType.amulet,
      // Fonksiyonel Eşyalar
      ItemType.chests,
      ItemType.scrolls,
    ],
    'Hırsız': [
      // Özel Eşyalar
      ItemType.dagger,
      ItemType.sword,
      ItemType.crossbow,
      ItemType.knife,
      // Genel Eşyalar
      ItemType.helmet,
      ItemType.armor,
      ItemType.gloves,
      ItemType.boots,
      ItemType.amulet,
      // Fonksiyonel Eşyalar
      ItemType.chests,
      ItemType.scrolls,
    ],
    'Korucu': [
      // Özel Eşyalar
      ItemType.dagger,
      ItemType.bow,
      ItemType.crossbow,
      ItemType.knife,
      // Genel Eşyalar
      ItemType.helmet,
      ItemType.armor,
      ItemType.gloves,
      ItemType.boots,
      ItemType.amulet,
      // Fonksiyonel Eşyalar
      ItemType.chests,
      ItemType.scrolls,
    ],
    'Büyücü': [
      // Özel Eşyalar
      ItemType.dagger,
      ItemType.staff,
      ItemType.runic,
      // Genel Eşyalar
      ItemType.helmet,
      ItemType.armor,
      ItemType.gloves,
      ItemType.boots,
      ItemType.amulet,
      // Fonksiyonel Eşyalar
      ItemType.chests,
      ItemType.scrolls,
    ],
  };

  @override
  void initState() {
    super.initState();
    if (widget.character.equippedItems.isEmpty) {
      widget.character.equippedItems = List.generate(7, (index) => null);
    }
    WidgetsBinding.instance.addObserver(this);
    _updateStats();
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

  void _updateStats() {
    setState(() {
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
    });
  }

  void checkReadyForView() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isReadyForView = true;
      if (widget.character.firstEntryStatusPage == 0) {
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
                      "Envanter Sayfası",
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
                              "Bu sayfa, karakterinizin oyun boyunca kazandığı veya "
                              "dükkanlardan satın aldığı eşyaları "
                              "yönetebileceğiniz ana merkezdir. Bu eşyaları üzerinize "
                              "kuşanabilir ve kuşanılmış eşyaları görebilir, bu "
                              "eşyaların sağladığı toplam değerleri ve seviyenizin "
                              "ilerleyişini takip edebilirsiniz. Ayrıca, "
                              "envanterinizde oyun içerisinde kazandığınız veya "
                              "satın aldığınız tüm eşyaları detaylarıyla "
                              "birlikte görebilir, inceleyebilir, kaldırabilir ve "
                              "ihtiyacınıza göre kullanabilirsiniz. Günlük ve Üretim "
                              "sayfalarına da buradan hızlıca geçiş yapabilirsiniz, "
                              "böylece karakter gelişiminizi, eşyalarınızı, "
                              "üretimlerinizi, günlükteki notlarınızı tek bir "
                              "noktadan kontrol edebilirsiniz.",
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
                        widget.character.firstEntryStatusPage++;
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

  void _saveCharacterData() async {
    await widget.character.saveCharacterData();
  }

  void showAttention(String bodyText) {
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
                      "Dikkat!",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      bodyText,
                      style: baseNumberStyle.copyWith(fontSize: width * 0.035),
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
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Tamam',
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
                      "Değerler Hakkında",
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
                              "    Seviye (Svy): Karakterin seviyesini belirtir. "
                              "Maksimum ulaşılabilecek seviye 10'dur\n\n"
                              "    Tecrübe Puanı (TP): Karakterin mevcut tecrübe "
                              "puanıdır. Bu puan belirli bir değere "
                              "ulaştığında karakter otomatik olarak seviye atlar.\n\n"
                              "    Saldırı Değeri (AP): Verilen ham hasar değeridir.\n\n"
                              "    Savunma Değeri (DP): Karaktere verilen hasarın %DP "
                              "değeri kadar azalmasını sağlar. Yani, karakter 50 DP'ye "
                              "sahipse alınan hasar %50 oranla azalacaktır.\n\n"
                              "    Statüler (STR-INT-DEX-CHR): Savaşlarda yapılan "
                              "aksiyon ve kullanılan yeteneklerin gücünü "
                              "arttırır. Yani daha güçlü ve yüksek hasarlar "
                              "çıkartmanın anahtarı, doğru statüyü doğru "
                              "miktarda arttırmaktır.\n\n"
                              "    Her statü değeri hasarı doğrudan artırır, ancak "
                              "her sınıf için belirli bir statü değeri "
                              "hasarı daha çok etkiler. İşte sınıflara göre en "
                              "çok etkiye sahip olan statü değerleri:\n\n"
                              "Barbar: (STR) Güç\n"
                              "Paladin: (INT) Zeka\n"
                              "Hırsız: (CHR) Karizma\n"
                              "Korucu: (DEX) Beceri\n"
                              "Büyücü: (INT) Zeka",
                              textAlign: TextAlign.start,
                              style: baseNumberStyle.copyWith(
                                  fontSize: width * 0.0375),
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

  void _showEquippedItemDetails(int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = TextStyle(
      fontSize: width * 0.06,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      shadows: const [
        Shadow(offset: Offset(-1, -1), color: Colors.black87),
        Shadow(offset: Offset(1, -1), color: Colors.black87),
        Shadow(offset: Offset(1, 1), color: Colors.black87),
        Shadow(offset: Offset(-1, 1), color: Colors.black87),
      ],
    );

    final item = widget.character.equippedItems[index];
    if (item != null) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backgrounds/secondary/equipment_bg.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.06,
                  bottom: height * 0.06,
                  right: width * 0.08,
                  left: width * 0.08,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        item.imagePath,
                        height: width * 0.35,
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        item.name,
                        style: baseTextStyle.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.01),
                      if (item.attackPoint != 0)
                        _buildItemStatRow(
                          "Saldırı Gücü: ",
                          item.attackPoint,
                          width,
                        ),
                      if (item.defensePoint != 0)
                        _buildItemStatRow(
                          "Savunma Gücü: ",
                          item.defensePoint,
                          width,
                        ),
                      if (item.strengthPoint != 0)
                        _buildItemStatRow(
                          "Güç: ",
                          item.strengthPoint,
                          width,
                        ),
                      if (item.intelligencePoint != 0)
                        _buildItemStatRow(
                          "Zeka: ",
                          item.intelligencePoint,
                          width,
                        ),
                      if (item.dexterityPoint != 0)
                        _buildItemStatRow(
                          "Beceri: ",
                          item.dexterityPoint,
                          width,
                        ),
                      if (item.charismaPoint != 0)
                        _buildItemStatRow(
                          "Karizma: ",
                          item.charismaPoint,
                          width,
                        ),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                            child: Text(
                              'Çıkar',
                              style:
                                  baseTextStyle.copyWith(color: Colors.green),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                            onPressed: () {
                              setState(() {
                                widget.character.inventory.addItem(
                                    widget.character.equippedItems[index]!);
                                widget.character.equippedItems[index] = null;
                                _updateStats();
                                _saveCharacterData();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: width * 0.02),
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
                            child: Text(
                              'Kapat',
                              style: baseTextStyle.copyWith(color: Colors.red),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
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
  }

  void _removeItem(int inventoryIndex) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final item = widget.character.inventory.items[inventoryIndex];

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
                      "Dikkat!",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      "Eşyayı envanterinizden kaldırmak istediğinize emin misiniz?",
                      style: baseNumberStyle.copyWith(fontSize: width * 0.035),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              left: width * 0.05,
                              right: width * 0.05,
                            ),
                          ),
                          onPressed: () {
                            if (item?.boundToPlayer == true) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              _attentionRemoveItem();
                            } else {
                              setState(() {
                                widget.character.inventory
                                    .removeItem(inventoryIndex);
                              });
                              _saveCharacterData();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            '  Kaldır  ',
                            style: baseNumberStyle.copyWith(
                                fontSize: width * 0.04),
                            textScaler: const TextScaler.linear(1),
                          ),
                        ),
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
                              left: width * 0.05,
                              right: width * 0.05,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Kaldırma',
                            style: baseNumberStyle.copyWith(
                                fontSize: width * 0.04),
                            textScaler: const TextScaler.linear(1),
                          ),
                        )
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

  void _attentionRemoveItem() {
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
                      "Dikkat!",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      "Bu eşya envanterden kaldırılamaz!",
                      style: baseNumberStyle.copyWith(fontSize: width * 0.035),
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
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Tamam',
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

  void _openChest(int inventoryIndex) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle generalTextStyle = TextStyle(
      fontSize: width * 0.03,
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.white,
    );

    final item = widget.character.inventory.items[inventoryIndex];
    String message = '';

    switch (item?.name) {
      case 'Kayalıklardaki Sandık':
        widget.character.inventory.removeItem(inventoryIndex);
        widget.character.inventory.addItem(gizemliEldiven);
        widget.character.gold += 200;
        message = 'Kayalıklardaki Sandık açıldı! '
            '200 altın ve Gizemli Eldiven kazandınız!';
        break;
    }

    setState(() {});
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: generalTextStyle,
            textAlign: TextAlign.left,
            textScaler: const TextScaler.linear(1),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.only(
            left: width * 0.01,
            right: width * 0.01,
            bottom: height * 0.01,
          ),
        ),
      );
    }
    _saveCharacterData();
    Navigator.of(context).pop();
  }

  void _equipItem(int inventoryIndex) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(offset: Offset(-1, -1), color: Colors.black87),
        Shadow(offset: Offset(1, -1), color: Colors.black87),
        Shadow(offset: Offset(1, 1), color: Colors.black87),
        Shadow(offset: Offset(-1, 1), color: Colors.black87),
      ],
    );

    final item = widget.character.inventory.items[inventoryIndex];
    if (item != null) {
      // Ekipmanın giyinebilirliğinin kontrol edildiği yer;
      if (classItemRestrictions[widget.character.characterClass]
              ?.contains(item.itemType) ??
          false) {
        typeOfItem = _getItemTypeName(item.itemType);
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/backgrounds/secondary/equipment_bg.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.06,
                    bottom: height * 0.06,
                    right: width * 0.08,
                    left: width * 0.08,
                  ),
                  child: (item.itemType == ItemType.chests ||
                          item.itemType == ItemType.scrolls ||
                          item.itemType == ItemType.others)
                      ? (item.itemType == ItemType.chests)
                          ? SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    item.imagePath,
                                    width: width * 0.35,
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Text(
                                    item.name,
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.06,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: WidgetStateProperty
                                              .resolveWith<Color?>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return Colors.black
                                                    .withOpacity(0.2);
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        child: Text(
                                          'Sandığı Aç',
                                          style: baseTextStyle.copyWith(
                                              fontSize: width * 0.055,
                                              color: Colors.green),
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              const TextScaler.linear(1),
                                        ),
                                        onPressed: () {
                                          _openChest(inventoryIndex);
                                        },
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: WidgetStateProperty
                                              .resolveWith<Color?>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.pressed)) {
                                                return Colors.black
                                                    .withOpacity(0.2);
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        child: Text(
                                          'Kapat',
                                          style: baseTextStyle.copyWith(
                                              fontSize: width * 0.055,
                                              color: Colors.red),
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              const TextScaler.linear(1),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.name,
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.06,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: height * 0.35,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        item.description,
                                        style: baseTextStyle.copyWith(
                                            fontSize: width * 0.045,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  TextButton(
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty
                                          .resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.black
                                                .withOpacity(0.2);
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    child: Text(
                                      'Kapat',
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.055,
                                          color: Colors.red),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Colors.black.withOpacity(0.2),
                                  highlightColor: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(35.0),
                                  onTap: () {
                                    _removeItem(inventoryIndex);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(height * 0.01),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Eşyayı Kaldır!",
                                          style: baseTextStyle.copyWith(
                                              fontSize: width * 0.05,
                                              color: Colors.red),
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              const TextScaler.linear(1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Image.asset(
                                item.imagePath,
                                height: width * 0.35,
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                "${item.name}\nKuşanılsın mı?",
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.045,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                              SizedBox(height: height * 0.02),
                              if (item.attackPoint != 0)
                                _buildItemStatRow(
                                  "Saldırı Gücü: ",
                                  item.attackPoint,
                                  width,
                                ),
                              if (item.defensePoint != 0)
                                _buildItemStatRow(
                                  "Savunma Gücü: ",
                                  item.defensePoint,
                                  width,
                                ),
                              if (item.strengthPoint != 0)
                                _buildItemStatRow(
                                  "Güç: ",
                                  item.strengthPoint,
                                  width,
                                ),
                              if (item.intelligencePoint != 0)
                                _buildItemStatRow(
                                  "Zeka: ",
                                  item.intelligencePoint,
                                  width,
                                ),
                              if (item.dexterityPoint != 0)
                                _buildItemStatRow(
                                  "Beceri: ",
                                  item.dexterityPoint,
                                  width,
                                ),
                              if (item.charismaPoint != 0)
                                _buildItemStatRow(
                                  "Karizma: ",
                                  item.charismaPoint,
                                  width,
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ekipman Türü: $typeOfItem",
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.04,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty
                                          .resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.black
                                                .withOpacity(0.2);
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        int slotIndex =
                                            _getSlotIndexForItemType(
                                                item.slotType);
                                        if (widget.character
                                                .equippedItems[slotIndex] !=
                                            null) {
                                          widget.character.inventory.addItem(
                                              widget.character
                                                  .equippedItems[slotIndex]!);
                                        }
                                        widget.character
                                            .equippedItems[slotIndex] = item;
                                        widget.character.inventory
                                            .items[inventoryIndex] = null;
                                        _updateStats();
                                        _saveCharacterData();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Evet',
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.055,
                                          color: Colors.green),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  TextButton(
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty
                                          .resolveWith<Color?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.black
                                                .withOpacity(0.2);
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    child: Text(
                                      'Hayır',
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.055,
                                          color: Colors.red),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
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
      } else {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/backgrounds/secondary/equipment_bg.png',
                    ),
                    fit: BoxFit.fill,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Ekipman Kuşanılamıyor!",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.06, color: Colors.white),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Bu eşya karakterin sınıfı ile uyumsuz olduğu için "
                        "kuşanılamamaktadır.",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.045, color: Colors.white),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.02),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.black.withOpacity(0.2),
                          highlightColor: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(35.0),
                          onTap: () {
                            _removeItem(inventoryIndex);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(height * 0.01),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Eşyayı Kaldır!",
                                  style: baseTextStyle.copyWith(
                                      fontSize: width * 0.05,
                                      color: Colors.red),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  Row _buildItemStatRow(String label, int value, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: width * 0.045,
            fontFamily: "CormorantGaramond-Regular",
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [
              Shadow(offset: Offset(-1, -1), color: Colors.black87),
              Shadow(offset: Offset(1, -1), color: Colors.black87),
              Shadow(offset: Offset(1, 1), color: Colors.black87),
              Shadow(offset: Offset(-1, 1), color: Colors.black87),
            ],
          ),
          textAlign: TextAlign.center,
          textScaler: const TextScaler.linear(1),
        ),
        Text(
          " $value",
          style: TextStyle(
            fontSize: width * 0.03375,
            fontFamily: "LibreBaskerville-Bold",
            color: Colors.white,
            shadows: const [
              Shadow(offset: Offset(-1, -1), color: Colors.black87),
              Shadow(offset: Offset(1, -1), color: Colors.black87),
              Shadow(offset: Offset(1, 1), color: Colors.black87),
              Shadow(offset: Offset(-1, 1), color: Colors.black87),
            ],
          ),
          textAlign: TextAlign.center,
          textScaler: const TextScaler.linear(1),
        ),
      ],
    );
  }

  String _getItemTypeName(ItemType itemType) {
    switch (itemType) {
      case ItemType.axe:
        return "Balta";
      case ItemType.sword:
        return "Kılıç";
      case ItemType.dagger:
        return "Hançer";
      case ItemType.bow:
        return "Yay";
      case ItemType.crossbow:
        return "Arbalet";
      case ItemType.staff:
        return "Asa";
      case ItemType.shield:
        return "Kalkan";
      case ItemType.armor:
        return "Zırh";
      case ItemType.helmet:
        return "Miğfer";
      case ItemType.gloves:
        return "Eldiven";
      case ItemType.boots:
        return "Ayakkabı";
      case ItemType.amulet:
        return "Tılsım";
      default:
        return "Bilinmeyen";
    }
  }

  int _getSlotIndexForItemType(SlotType itemType) {
    switch (itemType) {
      case SlotType.helmet:
        return 0;
      case SlotType.armor:
        return 1;
      case SlotType.gloves:
        return 2;
      case SlotType.boots:
        return 3;
      case SlotType.primaryWeapon:
        return 4;
      case SlotType.secondaryWeapon:
        return 5;
      case SlotType.amulet:
        return 6;
      default:
        return -1;
    }
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

    return PopScope(
      canPop: saldiriDegeri != 0,
      onPopInvoked: (finalResult) {
        if (saldiriDegeri == 0) {
          showAttention("Saldırı değeriniz (AP) sıfırdır!\nLütfen oyun "
              "devamlılığını bozmamak için bir silah kuşanın!!!");
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backgrounds/primary/general_page_bg.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  // Üst Bilgi Kısmı;
                  Padding(
                    padding: EdgeInsets.only(
                      top: statusBarHeight,
                      right: width * 0.06,
                      left: width * 0.06,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: width * 0.18,
                                      height: width * 0.18,
                                      child: CircularProgressIndicator(
                                        value: widget.character.xp /
                                            widget.character.maxXp,
                                        strokeWidth: width * 0.01,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Colors.green,
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: width * 0.085,
                                      backgroundImage: AssetImage(
                                        widget.character.imagePath,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Text(
                                        "${((widget.character.xp / widget.character.maxXp) * 100).toStringAsFixed(0)}%",
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.03,
                                            color: Colors.red[700],
                                            shadows: const [
                                              Shadow(
                                                  offset: Offset(-1, -1),
                                                  color: Colors.white),
                                              Shadow(
                                                  offset: Offset(1, -1),
                                                  color: Colors.white),
                                              Shadow(
                                                  offset: Offset(1, 1),
                                                  color: Colors.white),
                                              Shadow(
                                                  offset: Offset(-1, 1),
                                                  color: Colors.white),
                                            ]),
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.175,
                                  child: Text(
                                    widget.character.playerName,
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.04,
                                        color: Colors.black87),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: width * 0.04),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Svy: ",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    Text(
                                      "${widget.character.level}",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.03,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "TP: ",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    Text(
                                      "${widget.character.xp}",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.03,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "AP: ",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    Text(
                                      "$saldiriDegeri",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.03,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "DP: ",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    Text(
                                      "$savunmaDegeri",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.03,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: width * 0.02),
                            Container(
                              width: width * 0.0015,
                              height: height * 0.095,
                              color: Colors.black87,
                            ),
                            SizedBox(width: width * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "(STR) Güç: ",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    Text(
                                      "$strength",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.03,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "(INT) Zeka: ",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    Text(
                                      "$intelligence",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.03,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "(DEX) Beceri: ",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    Text(
                                      "$dexterity",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.03,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "(CHR) Karizma: ",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    Text(
                                      "$charisma",
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.03,
                                          color: Colors.black87),
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(0.2),
                                highlightColor: Colors.black.withOpacity(0.1),
                                onTap: () {
                                  if (saldiriDegeri != 0) {
                                    Navigator.pop(context, {});
                                  } else {
                                    showAttention(
                                        "Saldırı değeriniz (AP) sıfırdır!\nLütfen oyun "
                                        "devamlılığını bozmamak için bir silah kuşanın!!!");
                                  }
                                },
                                customBorder: const CircleBorder(),
                                child: Icon(
                                  CupertinoIcons.arrow_left_circle_fill,
                                  size: width * 0.1,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
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
                                  size: width * 0.1,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Ekipman Slotları ve Diğer Sayfalar;
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/backgrounds/primary/player_silhouette_bg.png',
                        fit: BoxFit.cover,
                        width: width,
                      ),
                      // Ekipman Stack'i için yazı;
                      Positioned(
                        top: (height * 0.03),
                        left: (width * 0.06),
                        child: Text(
                          "Kuşanılmış\n"
                          "Ekipmanlarım:",
                          style: baseTextStyle.copyWith(
                              fontSize: width * 0.04,
                              color: Colors.black87,
                              shadows: const [
                                Shadow(
                                    offset: Offset(-1, -1),
                                    color: Colors.white),
                                Shadow(
                                    offset: Offset(1, -1), color: Colors.white),
                                Shadow(
                                    offset: Offset(1, 1), color: Colors.white),
                                Shadow(
                                    offset: Offset(-1, 1), color: Colors.white),
                              ]),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ),
                      // Günlük sayfası geçiş butonu;
                      Positioned(
                        top: (height * 0.3375),
                        left: (width * 0.1),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(0.2),
                                highlightColor: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(35.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DailyPage(
                                        character: widget.character,
                                      ),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      widget.character.dailyController = false;
                                      _saveCharacterData();
                                    });
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.025,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(35.0),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.3),
                                      width: width * 0.002,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.025,
                                      right: width * 0.025,
                                    ),
                                    child: Text(
                                      "Günlük",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.035,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                                offset: Offset(-1, -1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(1, -1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(1, 1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(-1, 1),
                                                color: Colors.black),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (widget.character.dailyController == true)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: width * 0.025,
                                  height: width * 0.025,
                                  decoration: BoxDecoration(
                                    color: Colors.red[600],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Gelişim sayfası geçiş butonu;
                      Positioned(
                        top: (height * 0.405),
                        left: (width * 0.1),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(0.2),
                                highlightColor: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(35.0),
                                onTap: () {
                                  if (widget.character.level > 1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpgradePage(
                                          character: widget.character,
                                        ),
                                      ),
                                    ).then((_) {
                                      setState(() {
                                        _updateStats();
                                      });
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.025,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(35.0),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.3),
                                      width: width * 0.002,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.025,
                                      right: width * 0.025,
                                    ),
                                    child: Text(
                                      "Gelişim",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.035,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                                offset: Offset(-1, -1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(1, -1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(1, 1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(-1, 1),
                                                color: Colors.black),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (widget.character.skillPoints != 0 ||
                                widget.character.hizPoints != 0)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: width * 0.025,
                                  height: width * 0.025,
                                  decoration: BoxDecoration(
                                    color: Colors.red[600],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Üretim sayfası geçiş butonu;
                      Positioned(
                        top: (height * 0.405),
                        right: (width * 0.1),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(0.2),
                                highlightColor: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(35.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductionPage(
                                        character: widget.character,
                                      ),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      widget.character.productController =
                                          false;
                                      _saveCharacterData();
                                    });
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.025,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purpleAccent.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(35.0),
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.3),
                                      width: width * 0.002,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.025,
                                      right: width * 0.025,
                                    ),
                                    child: Text(
                                      "Üretim",
                                      style: baseTextStyle.copyWith(
                                          fontSize: width * 0.035,
                                          color: Colors.white,
                                          shadows: const [
                                            Shadow(
                                                offset: Offset(-1, -1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(1, -1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(1, 1),
                                                color: Colors.black),
                                            Shadow(
                                                offset: Offset(-1, 1),
                                                color: Colors.black),
                                          ]),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (widget.character.productController)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: width * 0.025,
                                  height: width * 0.025,
                                  decoration: BoxDecoration(
                                    color: Colors.red[600],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Ana ekipman slotları;
                      Positioned(
                        top: (height * 0.02),
                        left: (width * 0.5) - (width * 0.06875),
                        child: _buildEquipmentSlot('Miğfer', 0),
                      ),
                      Positioned(
                        top: (height * 0.135),
                        left: (width * 0.5) - (width * 0.06875),
                        child: _buildEquipmentSlot('Zırh', 1),
                      ),
                      Positioned(
                        top: (height * 0.25),
                        left: (width * 0.5) - (width * 0.06875),
                        child: _buildEquipmentSlot('Eldiven', 2),
                      ),
                      Positioned(
                        top: (height * 0.365),
                        left: (width * 0.5) - (width * 0.06875),
                        child: _buildEquipmentSlot('Ayakkabı', 3),
                      ),
                      Positioned(
                        top: (height * 0.205),
                        left: (width * 0.22),
                        child: _buildEquipmentSlot('Birincil\nSilah', 4),
                      ),
                      Positioned(
                        top: (height * 0.205),
                        right: (width * 0.22),
                        child: _buildEquipmentSlot('İkincil\nSilah', 5),
                      ),
                      Positioned(
                        top: (height * 0.09),
                        right: (width * 0.22),
                        child: _buildEquipmentSlot('Tılsım', 6),
                      ),
                    ],
                  ),
                  // Envanter Kısmı
                  Text(
                    "Envanter",
                    style: baseTextStyle.copyWith(
                        fontSize: width * 0.06,
                        color: Colors.black87,
                        shadows: const [
                          Shadow(offset: Offset(-1, -1), color: Colors.white),
                          Shadow(offset: Offset(1, -1), color: Colors.white),
                          Shadow(offset: Offset(1, 1), color: Colors.white),
                          Shadow(offset: Offset(-1, 1), color: Colors.white),
                        ]),
                  ),
                  SizedBox(height: height * 0.005),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.06,
                      right: width * 0.06,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          height: height * 0.3,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: widget.character.inventory.items.length,
                            itemBuilder: (context, index) {
                              return DragTarget<int>(
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return widget.character.inventory
                                              .items[index] !=
                                          null
                                      ? GestureDetector(
                                          onTap: () {
                                            _equipItem(index);
                                          },
                                          child: LongPressDraggable<int>(
                                            data: index,
                                            feedback: Material(
                                              color: Colors.transparent,
                                              child: Image.asset(
                                                widget.character.inventory
                                                    .items[index]!.imagePath,
                                                fit: BoxFit.fill,
                                                width: width * 0.2,
                                                height: width * 0.2,
                                              ),
                                            ),
                                            childWhenDragging: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              child: Container(
                                                color: Colors.white54,
                                                child: Center(
                                                  child: Text(
                                                    "Boş",
                                                    style:
                                                        baseTextStyle.copyWith(
                                                            fontSize:
                                                                width * 0.05,
                                                            color: Colors
                                                                .red[400]),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                        const TextScaler.linear(
                                                            1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              child: Image.asset(
                                                widget.character.inventory
                                                    .items[index]!.imagePath,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: Container(
                                            color: Colors.white54,
                                            child: Center(
                                              child: Text(
                                                "Boş",
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.05,
                                                    color: Colors.red[400]),
                                              ),
                                            ),
                                          ),
                                        );
                                },
                                onAcceptWithDetails: (details) {
                                  setState(() {
                                    final fromIndex = details.data;
                                    if (fromIndex != index) {
                                      final temp = widget
                                          .character.inventory.items[fromIndex];
                                      widget.character.inventory
                                              .items[fromIndex] =
                                          widget
                                              .character.inventory.items[index];
                                      widget.character.inventory.items[index] =
                                          temp;
                                    }
                                  });
                                  _saveCharacterData();
                                },
                                onLeave: (data) {
                                  if (data != null &&
                                      widget.character.inventory.items[index] ==
                                          null) {
                                    setState(() {
                                      widget.character.inventory.items[data] =
                                          widget
                                              .character.inventory.items[data];
                                    });
                                  }
                                },
                              );
                            },
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
      ),
    );
  }

  Widget _buildEquipmentSlot(String label, int index) {
    double width = MediaQuery.of(context).size.width;

    TextStyle emptyTextStyle = TextStyle(
      fontSize: width * 0.06,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.red[600],
    );

    TextStyle slotTextStyle = TextStyle(
      fontSize: width * 0.04,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      shadows: const [
        Shadow(offset: Offset(-1, -1), color: Colors.white),
        Shadow(offset: Offset(1, -1), color: Colors.white),
        Shadow(offset: Offset(1, 1), color: Colors.white),
        Shadow(offset: Offset(-1, 1), color: Colors.white),
      ],
    );

    return GestureDetector(
      onTap: () {
        if (widget.character.equippedItems[index] == null) {
          showAttention("Kuşanılmış eşya yok!");
        } else {
          _showEquippedItemDetails(index);
        }
      },
      child: Column(
        children: [
          Container(
            height: width * 0.1375,
            width: width * 0.1375,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: widget.character.equippedItems[index] != null
                ? Image.asset(
                    widget.character.equippedItems[index]!.imagePath,
                    fit: BoxFit.fill,
                  )
                : Container(
                    color: Colors.white54,
                    child: Center(
                      child: Text(
                        "Boş",
                        style: emptyTextStyle,
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ),
                  ),
          ),
          Text(
            label,
            style: slotTextStyle,
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(1),
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
