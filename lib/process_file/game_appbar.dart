import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/pages/home_page.dart';
import 'package:corrupted_island_android/pages/market_page.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:corrupted_island_android/pages/inventory_page.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class GameAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Character character;
  final double effectSesSeviyesi;
  final VoidCallback onUpdate;

  const GameAppBar({
    super.key,
    required this.character,
    required this.effectSesSeviyesi,
    required this.onUpdate,
  });

  @override
  _GameAppBarState createState() => _GameAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _GameAppBarState extends State<GameAppBar> {
  late final AudioPlayer effectPlayer;

  @override
  void initState() {
    super.initState();
    effectPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late int maxMagicBar;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double canYuzdesi = widget.character.health > 0
        ? widget.character.health / widget.character.maxHealth
        : 0;

    TextStyle baseTextStyle = TextStyle(
      fontSize: width * 0.035,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      shadows: [
        Shadow(
          blurRadius: 3,
          color: Colors.white.withOpacity(0.25),
          offset: const Offset(1, 1),
        ),
      ],
    );

    TextStyle baseNumberStyle = TextStyle(
      fontSize: width * 0.0275,
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.white,
    );

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

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: width * 0.06),
              InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                highlightColor: Colors.black.withOpacity(0.1),
                onTap: () {
                  if (widget.character.isReadyOpenInventory) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventoryPage(
                          character: widget.character,
                        ),
                      ),
                    ).then((_) {
                      widget.onUpdate();
                    });
                  }
                },
                child: Row(
                  children: [
                    Container(
                      height: height * 0.06,
                      width: width * 0.12,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage(widget.character.imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.175,
                          child: Text(
                            widget.character.playerName,
                            style: baseTextStyle,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(height: height * 0.003),
                        Text(
                          widget.character.characterClass,
                          style: baseTextStyle,
                          textAlign: TextAlign.left,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                      style: baseNumberStyle,
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.003),
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                highlightColor: Colors.black.withOpacity(0.1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarketPage(
                        character: widget.character,
                      ),
                    ),
                  ).then((_) {
                    widget.onUpdate();
                  });
                },
                child: Icon(
                  Icons.shopping_cart,
                  size: width * 0.1,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: width * 0.02),
              InkWell(
                splashColor: Colors.black.withOpacity(0.2),
                highlightColor: Colors.black.withOpacity(0.1),
                onTap: () {
                  widget.character.saveCharacterData();
                  if (widget.character.isReadyOpenInventory) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }
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
              SizedBox(width: width * 0.06),
            ],
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
