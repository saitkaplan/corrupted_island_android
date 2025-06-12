import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class DailyPage extends StatefulWidget {
  final Character character;

  const DailyPage({
    super.key,
    required this.character,
  });

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> with WidgetsBindingObserver {
  bool isReadyForView = false;
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
      if (widget.character.firstEntryDailyPage == 0) {
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
                      "Günlük Sayfası",
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
                              "Burası, maceranızın en önemli anlarını kaydettiğiniz "
                              "günlük sayfası! Yolculuk boyunca elde ettiğiniz "
                              "önemli ipuçlarını ve detaylarını burada toplar, "
                              "buradan kontrol edebilirsiniz. Böylece hiçbir "
                              "önemli bilgiyi gözden kaçırmazsınız. Günlük sayfası, "
                              "size hem hikayenize rehberlik eder hem de "
                              "maceranızın sırlarını aydınlatan bir yol arkadaşı olur!",
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
                        widget.character.firstEntryDailyPage++;
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
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
                        'Macera Günlükleri',
                        style: baseTextStyle.copyWith(fontSize: width * 0.055),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: widget.character.daily.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Günlükte şimdilik bir şey yok!",
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.055),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            left: width * 0.06,
                            right: width * 0.06,
                          ),
                          itemCount: widget.character.daily.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(
                                        "assets/images/backgrounds/secondary/daily_bg.png",
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.085,
                                        vertical: height * 0.055,
                                      ),
                                      child: Text(
                                        widget.character.daily[index],
                                        style: baseTextStyle.copyWith(
                                            fontSize: width * 0.045),
                                        textAlign: TextAlign.left,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
