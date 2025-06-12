import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/pages/inventory_page.dart';
import 'package:corrupted_island_android/pages/market_page.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:corrupted_island_android/process_file/object_items.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  final Function(Item) onItemPurchased;
  final List<Item> inventoryItems;
  final int currentGold;
  final Function(int) updateGold;
  final List<Item> tookGamePageItems;
  final Character character;

  const ShopPage({
    super.key,
    required this.onItemPurchased,
    required this.inventoryItems,
    required this.currentGold,
    required this.updateGold,
    required this.tookGamePageItems,
    required this.character,
  });

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with WidgetsBindingObserver {
  late int remainingGold;
  List<Item> availableItems = [];
  bool isReadyForView = false;
  bool _showMaterials1 = false;
  bool _showMaterials2 = false;
  final AudioPlayer _effectPlayer = AudioPlayer();
  double effectSesSeviyesi = 1.0;

  @override
  void initState() {
    super.initState();
    remainingGold = widget.currentGold;
    WidgetsBinding.instance.addObserver(this);
    _loadAvailableItems();
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

  Future<void> _loadAvailableItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? equippedItemNames = prefs.getStringList('equippedItems');

    setState(() {
      availableItems = widget.tookGamePageItems.where((item) {
        bool isInInventory = widget.inventoryItems.contains(item);
        bool isEquipped = equippedItemNames?.contains(item.name) ?? false;
        return !isInInventory && !isEquipped;
      }).toList();
    });
  }

  void checkReadyForView() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isReadyForView = true;
      if (widget.character.firstEntryShopPage == 0) {
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
                      "Dükkan Sayfası",
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
                              "Burası, hikaye boyunca karşılaştığınız satıcılardan "
                              "eşyalar satın alabileceğiniz dükkan sayfası! Bu "
                              "sayfada, maceranızda size avantaj sağlayacak "
                              "ürünleri inceleyebilir ve ihtiyaçlarınıza göre "
                              "satın alabilirsiniz. Ayrıca, satın alım sırasında "
                              "envanter sayfanıza kolayca erişerek sahip olduğunuz "
                              "eşyaları gözden geçirebilir ve isterseniz gizemli "
                              "dükkana ulaşıp altın ve diğer ihtiyaçlarınızı "
                              "da giderebilirsiniz. Dükkan, yolculuğunuzda "
                              "güçlenmek için önemli bir destektir! Unutmamak "
                              "gerekli ki, silahınız ne kadar güçlüyse siz "
                              "de o kadar güçlüsünüz!",
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
                        widget.character.firstEntryShopPage++;
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

  Future<void> _saveGold() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentGold', remainingGold);
  }

  Future<void> _saveInventory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> inventoryItemNames =
        widget.inventoryItems.map((item) => item.name).toList();
    await prefs.setStringList('inventoryItems', inventoryItemNames);
  }

  void _buyItem(Item item, int price) {
    double width = MediaQuery.of(context).size.width;
    if (remainingGold >= price) {
      widget.onItemPurchased(item);
      setState(() {
        remainingGold -= price;
        widget.character.spentMoney += price;
        widget.character.purchasedItem++;
        availableItems.remove(item);
        widget.updateGold(remainingGold);
        _saveGold();
        _saveInventory();
        widget.character.saveCharacterData();
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Satın alındı!',
            style: TextStyle(
              fontSize: width * 0.04,
              color: Colors.black87,
              fontFamily: "LibreBaskerville-Bold",
            ),
            textAlign: TextAlign.left,
            textScaler: const TextScaler.linear(1),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Yeteri kadar altın yok!',
            style: TextStyle(
              fontSize: width * 0.04,
              color: Colors.black87,
              fontFamily: "LibreBaskerville-Bold",
            ),
            textAlign: TextAlign.left,
            textScaler: const TextScaler.linear(1),
          ),
        ),
      );
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
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          textScaler: const TextScaler.linear(1),
        ),
        Text(
          "$value",
          style: TextStyle(
            fontSize: width * 0.03375,
            fontFamily: "LibreBaskerville-Bold",
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          textScaler: const TextScaler.linear(1),
        ),
      ],
    );
  }

  void showExtraBuyDialog(String bodyText, String urun, int price) {
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
                      urun,
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.015),
                    Text(
                      bodyText,
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
                              left: width * 0.075,
                              right: width * 0.075,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'İptal',
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
                              left: width * 0.075,
                              right: width * 0.075,
                            ),
                          ),
                          onPressed: () {
                            switch (urun) {
                              case 'Boş Şişe':
                                if (remainingGold >= price) {
                                  setState(() {
                                    remainingGold -= price;
                                    widget.character.bosSise++;
                                    widget.character.spentMoney += price;
                                    widget.character.purchasedItem++;
                                    widget.updateGold(remainingGold);
                                    _saveGold();
                                    widget.character.saveCharacterData();
                                  });
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Satın alındı!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Yeteri kadar altın yok!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                }
                                break;
                              case 'Katalen':
                                if (remainingGold >= price) {
                                  setState(() {
                                    remainingGold -= price;
                                    widget.character.katalen += 200;
                                    widget.character.spentMoney += price;
                                    widget.character.purchasedItem++;
                                    widget.updateGold(remainingGold);
                                    _saveGold();
                                    widget.character.saveCharacterData();
                                  });
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Satın alındı!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Yeteri kadar altın yok!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                }
                                break;
                              case 'Organik Parçalar':
                                if (remainingGold >= price) {
                                  setState(() {
                                    remainingGold -= price;
                                    widget.character.organikParcalar += 100;
                                    widget.character.spentMoney += price;
                                    widget.character.purchasedItem++;
                                    widget.updateGold(remainingGold);
                                    _saveGold();
                                    widget.character.saveCharacterData();
                                  });
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Satın alındı!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Yeteri kadar altın yok!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                }
                                break;
                              case 'Can Potu':
                                if (remainingGold >= price) {
                                  setState(() {
                                    remainingGold -= price;
                                    widget.character.healthPot++;
                                    widget.character.spentMoney += price;
                                    widget.character.purchasedItem++;
                                    widget.updateGold(remainingGold);
                                    _saveGold();
                                    widget.character.saveCharacterData();
                                  });
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Satın alındı!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Yeteri kadar altın yok!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                }
                                break;
                              case 'Aksiyon Potu':
                                if (remainingGold >= price) {
                                  setState(() {
                                    remainingGold -= price;
                                    widget.character.manaPot++;
                                    widget.character.spentMoney += price;
                                    widget.character.purchasedItem++;
                                    widget.updateGold(remainingGold);
                                    _saveGold();
                                    widget.character.saveCharacterData();
                                  });
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Satın alındı!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Yeteri kadar altın yok!',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                          fontFamily: "LibreBaskerville-Bold",
                                        ),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  );
                                }
                                break;
                            }
                            widget.character.saveCharacterData();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Satın Al',
                            style: baseNumberStyle.copyWith(
                                fontSize: width * 0.04),
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
    );
    TextStyle baseNumberStyle = const TextStyle(
      fontFamily: "LibreBaskerville-Bold",
    );

    return Scaffold(
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
          ),
          Column(
            children: [
              SizedBox(height: statusBarHeight),
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                              'Dükkan',
                              style: baseTextStyle.copyWith(
                                  fontSize: width * 0.055,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                              textScaler: const TextScaler.linear(1),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.yellow[900],
                                ),
                                SizedBox(width: width * 0.005),
                                Text(
                                  '$remainingGold',
                                  style: baseNumberStyle.copyWith(
                                      fontSize: width * 0.05,
                                      color: Colors.black87),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            SizedBox(width: width * 0.1),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.teal,
                                width: width * 0.0035,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(0.2),
                                highlightColor: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InventoryPage(
                                        character: widget.character,
                                      ),
                                    ),
                                  ).then((_) {
                                    setState(() {});
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: width * 0.015,
                                    horizontal: width * 0.03,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.inventory_2,
                                        color: Colors.teal,
                                        size: width * 0.06,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Text(
                                        'Envantere Git',
                                        style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.purple,
                                width: width * 0.0035,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(0.2),
                                highlightColor: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MarketPage(
                                        character: widget.character,
                                      ),
                                    ),
                                  ).then((_) {
                                    setState(() {
                                      remainingGold = widget.character.gold;
                                    });
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: width * 0.015,
                                    horizontal: width * 0.03,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart,
                                        color: Colors.purple,
                                        size: width * 0.06,
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Text(
                                        'G. Dükkana Git',
                                        style: baseTextStyle.copyWith(
                                          fontSize: width * 0.04,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ],
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
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
                    setState(() {
                      _showMaterials1 = !_showMaterials1;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _showMaterials1 ? Icons.expand_less : Icons.expand_more,
                        color: Colors.black87,
                        size: width * 0.06,
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        "Hammaddeler",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.045, color: Colors.black87),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.lab_flask_solid,
                                color: Colors.cyan,
                                size: width * 0.06,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                "Boş Şişe",
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.045,
                                    color: Colors.black87),
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
                                  Icons.monetization_on,
                                  size: width * 0.05,
                                  color: Colors.yellow[900],
                                ),
                                Text(
                                  " Satın Al",
                                  style: baseTextStyle.copyWith(
                                      color: Colors.black87,
                                      fontSize: width * 0.035),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showExtraBuyDialog(
                                "10 altın karşılığında 1 adet boş şişe satın "
                                    "almak istiyor musun?",
                                "Boş Şişe",
                                10,
                              );
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
                                color: Colors.purple,
                                size: width * 0.06,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                "Katalen",
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.045,
                                    color: Colors.black87),
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
                                  Icons.monetization_on,
                                  size: width * 0.05,
                                  color: Colors.yellow[900],
                                ),
                                Text(
                                  " Satın Al",
                                  style: baseTextStyle.copyWith(
                                      color: Colors.black87,
                                      fontSize: width * 0.035),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showExtraBuyDialog(
                                "10 altın karşılığında 200 adet katalen satın "
                                    "almak istiyor musun?",
                                "Katalen",
                                10,
                              );
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
                                Icons.bubble_chart,
                                color: Colors.green,
                                size: width * 0.06,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                "Organik Parçalar",
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.045,
                                    color: Colors.black87),
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
                                  Icons.monetization_on,
                                  size: width * 0.05,
                                  color: Colors.yellow[900],
                                ),
                                Text(
                                  " Satın Al",
                                  style: baseTextStyle.copyWith(
                                      color: Colors.black87,
                                      fontSize: width * 0.035),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showExtraBuyDialog(
                                "10 altın karşılığında 100 adet organik parça "
                                    "satın almak istiyor musun?",
                                "Organik Parçalar",
                                10,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: _showMaterials1
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
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
                    setState(() {
                      _showMaterials2 = !_showMaterials2;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _showMaterials2 ? Icons.expand_less : Icons.expand_more,
                        color: Colors.black87,
                        size: width * 0.06,
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        "Potlar",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.045, color: Colors.black87),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/icons/buttons/can_potu_arkaplansiz.png",
                                fit: BoxFit.fill,
                                width: width * 0.085,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                "Can Potu",
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.045,
                                    color: Colors.black87),
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
                                  Icons.monetization_on,
                                  size: width * 0.05,
                                  color: Colors.yellow[900],
                                ),
                                Text(
                                  " Satın Al",
                                  style: baseTextStyle.copyWith(
                                      color: Colors.black87,
                                      fontSize: width * 0.035),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showExtraBuyDialog(
                                "20 altın karşılığında 1 adet can potu satın "
                                    "almak istiyor musun?",
                                "Can Potu",
                                20,
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/icons/buttons/mana_potu_arkaplansiz.png",
                                fit: BoxFit.fill,
                                width: width * 0.085,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                "Aksiyon Potu",
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.045,
                                    color: Colors.black87),
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
                                  Icons.monetization_on,
                                  size: width * 0.05,
                                  color: Colors.yellow[900],
                                ),
                                Text(
                                  " Satın Al",
                                  style: baseTextStyle.copyWith(
                                      color: Colors.black87,
                                      fontSize: width * 0.035),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showExtraBuyDialog(
                                "20 altın karşılığında 1 adet aksiyon potu "
                                    "satın almak istiyor musun?",
                                "Aksiyon Potu",
                                20,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                crossFadeState: _showMaterials2
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
              SizedBox(height: height * 0.005),
              Text(
                "Kuşanılabilen Eşyalar",
                style: baseTextStyle.copyWith(
                    fontSize: width * 0.05, color: Colors.black87),
                textAlign: TextAlign.center,
                textScaler: const TextScaler.linear(1),
              ),
              Expanded(
                child: availableItems.isEmpty
                    ? Center(
                        child: Text(
                          'Kuşanılabilecek bir eşya yok!',
                          style: baseTextStyle.copyWith(
                              fontSize: width * 0.09, color: Colors.black87),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.only(
                          left: width * 0.06,
                          right: width * 0.06,
                          bottom: height * 0.3,
                        ),
                        physics: const ClampingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: availableItems.length,
                        itemBuilder: (context, index) {
                          final item = availableItems[index];
                          int itemPrice = item.price;
                          return GestureDetector(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/backgrounds/secondary/shop_dialog_bg.png',
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
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              item.imagePath,
                                              height: width * 0.35,
                                            ),
                                            SizedBox(height: height * 0.02),
                                            Text(
                                              item.name,
                                              style: baseTextStyle.copyWith(
                                                  fontSize: width * 0.06,
                                                  color: Colors.black87),
                                              textAlign: TextAlign.center,
                                              textScaler:
                                                  const TextScaler.linear(1),
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
                                            SizedBox(height: height * 0.01),
                                            if (item.slotType ==
                                                    SlotType.primaryWeapon &&
                                                item.itemType == ItemType.axe)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Barbar ve Paladin',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.primaryWeapon &&
                                                item.itemType == ItemType.sword)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Barbar, Paladin ve Hırsız',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.primaryWeapon &&
                                                item.itemType == ItemType.bow)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Paladin ve Korucu',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.primaryWeapon &&
                                                item.itemType ==
                                                    ItemType.crossbow)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Hırsız ve Korucu',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.primaryWeapon &&
                                                item.itemType ==
                                                    ItemType.dagger)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Korucu, Büyücü ve Hırsız',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.primaryWeapon &&
                                                item.itemType == ItemType.staff)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Büyücü',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.secondaryWeapon &&
                                                item.itemType ==
                                                    ItemType.shield)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Barbar ve Paladin',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.secondaryWeapon &&
                                                item.itemType == ItemType.knife)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Hırsız ve Korucu',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.secondaryWeapon &&
                                                item.itemType == ItemType.runic)
                                              Text(
                                                'Kullanabilen Sınıflar:\n'
                                                'Büyücü',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            if (item.slotType ==
                                                    SlotType.helmet ||
                                                item.slotType ==
                                                    SlotType.armor ||
                                                item.slotType ==
                                                    SlotType.boots ||
                                                item.slotType ==
                                                    SlotType.gloves ||
                                                item.slotType ==
                                                    SlotType.amulet)
                                              Text(
                                                'Sınıf kullanım sınırı yok.',
                                                style: baseTextStyle.copyWith(
                                                    fontSize: width * 0.035,
                                                    color: Colors.black87),
                                                textAlign: TextAlign.center,
                                                textScaler:
                                                    const TextScaler.linear(1),
                                              ),
                                            SizedBox(height: height * 0.01),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Fiyat: $itemPrice Altın',
                                                  style:
                                                      baseNumberStyle.copyWith(
                                                          fontSize:
                                                              width * 0.055,
                                                          color:
                                                              Colors.black87),
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                      const TextScaler.linear(
                                                          1),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: height * 0.01),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  style: ButtonStyle(
                                                    overlayColor:
                                                        WidgetStateProperty
                                                            .resolveWith<
                                                                Color?>(
                                                      (Set<WidgetState>
                                                          states) {
                                                        if (states.contains(
                                                            WidgetState
                                                                .pressed)) {
                                                          return Colors.black
                                                              .withOpacity(0.2);
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _buyItem(item, itemPrice);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Satın Al',
                                                    style:
                                                        baseTextStyle.copyWith(
                                                            fontSize:
                                                                width * 0.065,
                                                            color:
                                                                Colors.green),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                        const TextScaler.linear(
                                                            1),
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.02),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    overlayColor:
                                                        WidgetStateProperty
                                                            .resolveWith<
                                                                Color?>(
                                                      (Set<WidgetState>
                                                          states) {
                                                        if (states.contains(
                                                            WidgetState
                                                                .pressed)) {
                                                          return Colors.black
                                                              .withOpacity(0.2);
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'İptal Et',
                                                    style:
                                                        baseTextStyle.copyWith(
                                                            fontSize:
                                                                width * 0.065,
                                                            color: Colors.red),
                                                    textAlign: TextAlign.center,
                                                    textScaler:
                                                        const TextScaler.linear(
                                                            1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/backgrounds/secondary/shop_slot_bg.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      item.imagePath,
                                      height: width * 0.15,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(height: height * 0.005),
                                    Text(
                                      '$itemPrice Altın',
                                      style: baseNumberStyle.copyWith(
                                          fontSize: width * 0.035,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                    SizedBox(height: height * 0.001),
                                    if (item.slotType == SlotType.primaryWeapon)
                                      Text(
                                        'AP: ${item.attackPoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType ==
                                            SlotType.secondaryWeapon &&
                                        item.itemType == ItemType.shield)
                                      Text(
                                        'DP: ${item.defensePoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType ==
                                            SlotType.secondaryWeapon &&
                                        item.itemType != ItemType.shield)
                                      Text(
                                        'AP: ${item.attackPoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if ((item.slotType == SlotType.helmet &&
                                            item.itemType == ItemType.helmet) ||
                                        (item.slotType == SlotType.armor &&
                                            item.itemType == ItemType.armor) ||
                                        (item.slotType == SlotType.gloves &&
                                            item.itemType == ItemType.gloves) ||
                                        (item.slotType == SlotType.boots &&
                                            item.itemType == ItemType.boots))
                                      Text(
                                        'DP: ${item.defensePoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType == SlotType.amulet &&
                                        item.strengthPoint >
                                            item.intelligencePoint &&
                                        item.strengthPoint >
                                            item.dexterityPoint &&
                                        item.strengthPoint > item.charismaPoint)
                                      Text(
                                        'Statü: ${item.strengthPoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType == SlotType.amulet &&
                                        item.strengthPoint ==
                                            item.intelligencePoint &&
                                        item.strengthPoint ==
                                            item.dexterityPoint &&
                                        item.strengthPoint ==
                                            item.charismaPoint)
                                      Text(
                                        'Statü: ${item.strengthPoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType == SlotType.amulet &&
                                        item.intelligencePoint >
                                            item.strengthPoint &&
                                        item.intelligencePoint >
                                            item.dexterityPoint &&
                                        item.intelligencePoint >
                                            item.charismaPoint)
                                      Text(
                                        'Statü: ${item.intelligencePoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType == SlotType.amulet &&
                                        item.dexterityPoint >
                                            item.strengthPoint &&
                                        item.dexterityPoint >
                                            item.intelligencePoint &&
                                        item.dexterityPoint >
                                            item.charismaPoint)
                                      Text(
                                        'Statü: ${item.dexterityPoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType == SlotType.amulet &&
                                        item.charismaPoint >
                                            item.strengthPoint &&
                                        item.charismaPoint >
                                            item.intelligencePoint &&
                                        item.charismaPoint >
                                            item.dexterityPoint)
                                      Text(
                                        'Statü: ${item.charismaPoint}',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.035,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType == SlotType.none &&
                                        item.itemType == ItemType.chests)
                                      Text(
                                        'Sandık',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.03,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    if (item.slotType == SlotType.none &&
                                        item.itemType == ItemType.scrolls)
                                      Text(
                                        'Parşömen',
                                        style: baseNumberStyle.copyWith(
                                            fontSize: width * 0.03,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
    );
  }
}

/* void playButtonSound() async {
    await _effectPlayer.setVolume(effectSesSeviyesi);
    await _effectPlayer.play(
      AssetSource('sounds/effect_sounds/button_sound.mp3'),
    );
   } */
