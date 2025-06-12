import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/pages/game_page.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:corrupted_island_android/process_file/object_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> with WidgetsBindingObserver {
  Race? selectedRace;
  CharacterClass? selectedClass;
  final TextEditingController _nameController = TextEditingController();
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer2 = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _raceScrollController = ScrollController();
  bool showLeftGlow = false;
  bool showRightGlow = true;
  bool _showLeftRaceGlow = false;
  bool _showRightRaceGlow = true;
  bool isPlaying = false;
  bool isPaused = false;
  Duration? position;
  double musicSesSeviyesi = 0.5;
  double effectSesSeviyesi = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_scrollListener);
    _raceScrollController.addListener(_raceScrollListener);
    loadVolumeSettings();
    playSound();
    playVoice();
  }

  @override
  void dispose() {
    _nameController.dispose();
    audioPlayer.dispose();
    _effectPlayer.dispose();
    _effectPlayer2.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _raceScrollController.dispose();
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
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final double offset = _scrollController.offset;
    final double maxScroll = _scrollController.position.maxScrollExtent;

    setState(() {
      showLeftGlow = offset > 0;
      showRightGlow = offset < maxScroll;
    });
  }

  void _raceScrollListener() {
    if (!_raceScrollController.hasClients) return;

    final double offset = _raceScrollController.offset;
    final double maxScroll = _raceScrollController.position.maxScrollExtent;

    setState(() {
      _showLeftRaceGlow = offset > 0;
      _showRightRaceGlow = offset < maxScroll;
    });
  }

  // Yasaklı kelimeler listesi
  List<String> yasakliKelimeListesi = [
    // İngilizce
    'damn', 'hell', 'crap', 'bitch', 'bastard', 'asshole', 'shit', 'fuck',
    // Türkçe
    'şerefsiz', 'puşt', 'orospu', 'siktir', 'yarrak', 'seviş', 'pıttık',
    'amk', 'am', 'sik', 'sikiş', 'amcık', 'oç', 'sie', 'emcuk', 'yarrah',
    'kahpe', 'gahpe', 'kancık', 'gancık', 'ananınamı', 'babanınyarrağı',
    'yarrağı', 'yarra', 'daşşak', 'gavat', 'pezeveng', 'pezevenk', 's2ş',
    'eşşeğinsiki', 'siki', 'seks', 'sex', 'amoş', 'nah', 'sokuş', 'sevişmek',
    // İspanyolca
    'mierda', 'puta', 'cabrón', 'joder', 'gilipollas', 'coño', 'carajo',
    'pendejo',
    // Diğerleri
    'omg', 'wtf', 'stfu', 'fml', 'gtfo',
  ];

  final RegExp harflerVeBosluklar = RegExp(r'^[A-Z][a-zA-Z\s]*$');
  bool isimGecerliMi(String isim) {
    bool yasakliKelimeVarMi = yasakliKelimeListesi.any(
      (kelime) => isim.toLowerCase().contains(kelime.toLowerCase()),
    );
    bool ilkHarfBuyukMuVeHarfKontrolu = harflerVeBosluklar.hasMatch(isim);
    return !yasakliKelimeVarMi && ilkHarfBuyukMuVeHarfKontrolu;
  }

  void playVoice() async {
    await _effectPlayer.setVolume(effectSesSeviyesi); // Ses seviyesi
    await _effectPlayer.play(
      AssetSource('sounds/voice_sounds/creation_entry_voice.mp3'),
    );
  }

  void playSound() async {
    await audioPlayer.setVolume(musicSesSeviyesi);
    await audioPlayer.play(
      AssetSource('sounds/game_sounds/create_page_base_music.mp3'),
    );
    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer
          .play(AssetSource('sounds/game_sounds/create_page_base_music.mp3'));
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
      await _effectPlayer.stop();
      await _effectPlayer2.stop();
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

  void showSkillInfo(
    String infoTitle,
    String infoText1,
    String skillImage1,
    String infoText2,
    String skillImage2,
    String infoText3,
    String skillImage3,
    String infoText4,
    String skillImage4,
    String infoText5,
    String skillImage5,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = TextStyle(
      fontSize: width * 0.06,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    TextStyle baseNumberStyle = TextStyle(
      fontSize: width * 0.05,
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
                      style: baseTextStyle,
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.015),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSkillSection(skillImage1, infoText1, width),
                            SizedBox(height: height * 0.05),
                            _buildSkillSection(skillImage2, infoText2, width),
                            SizedBox(height: height * 0.05),
                            _buildSkillSection(skillImage3, infoText3, width),
                            SizedBox(height: height * 0.05),
                            _buildSkillSection(skillImage4, infoText4, width),
                            SizedBox(height: height * 0.05),
                            _buildSkillSection(skillImage5, infoText5, width),
                            SizedBox(height: height * 0.05),
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
                        'Bilgileri Kapat',
                        style: baseNumberStyle,
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

  void showRaceInfo(String infoText) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = TextStyle(
      fontSize: width * 0.075,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    TextStyle baseNumberStyle = TextStyle(
      fontSize: width * 0.05,
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
                      "Irka Özel Statüler",
                      style: baseTextStyle,
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Flexible(
                      child: SingleChildScrollView(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: _buildRichText(infoText, width),
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
                        'Bilgileri Kapat',
                        style: baseNumberStyle,
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

  Widget _buildSkillSection(String skillImage, String infoText, double width) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          skillImage,
          width: width * 0.25,
        ),
        SizedBox(height: height * 0.02),
        RichText(
          textAlign: TextAlign.center,
          textScaler: const TextScaler.linear(1),
          text: _buildRichText(infoText, width),
        ),
      ],
    );
  }

  TextSpan _buildRichText(String infoText, double width) {
    TextStyle blackTextStyle = TextStyle(
      fontSize: width * 0.05,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    TextStyle redTextStyle = TextStyle(
      fontSize: width * 0.04,
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.red[800],
    );

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
              style: blackTextStyle,
            ),
          );
          spans.add(
            TextSpan(
              text: matchedText.substring(1),
              style: redTextStyle,
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: matchedText,
              style: redTextStyle,
            ),
          );
        }
        return '';
      },
      onNonMatch: (String text) {
        spans.add(
          TextSpan(
            text: text,
            style: blackTextStyle,
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
    final double buttonHeight = height * 0.06;
    final double buttonWidth = width * 0.25;

    TextStyle baseTextStyle = const TextStyle(
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 3,
          color: Colors.black87,
          offset: Offset(1, 1),
        ),
      ],
    );
    TextStyle baseNumberStyle = TextStyle(
      fontSize: width * 0.035,
      fontFamily: "LibreBaskerville-Bold",
      color: Colors.white,
      shadows: const [
        Shadow(
          blurRadius: 3,
          color: Colors.black87,
          offset: Offset(1, 1),
        ),
      ],
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backgrounds/primary/creation_page_bg.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: height * 0.5,
                right: width * 0.05,
                left: width * 0.05,
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    Text(
                      'Bu dünyada sen kimsin?\nŞimdi seçme zamanı:',
                      style: baseTextStyle.copyWith(
                          fontSize: width * 0.075, color: Colors.white),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    // IRK SEÇİMİ BUTONLARI
                    SizedBox(height: height * 0.03),
                    Text(
                      'Irkını Seç:',
                      style: baseTextStyle.copyWith(
                          fontSize: width * 0.055, color: Colors.teal.shade400),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    SizedBox(
                      height: buttonHeight,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            controller: _raceScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: races.map((race) {
                                bool isSelected = selectedRace == race;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRace = race;
                                      selectedClass = null;
                                    });
                                  },
                                  child: Container(
                                    width: buttonWidth,
                                    height: buttonHeight,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.015,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.green.withOpacity(0.8)
                                          : Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.greenAccent
                                            : Colors.black.withOpacity(0.3),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        race.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily:
                                              "CormorantGaramond-Regular",
                                          fontSize: width * 0.045,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          // Sol glow
                          if (_showLeftRaceGlow)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: width * 0.08,
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Colors.transparent,
                                      Colors.blueAccent.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          // Sağ glow
                          if (_showRightRaceGlow)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: width * 0.08,
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.transparent,
                                      Colors.blueAccent.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // SEÇİLEN IRKIN GÖSTERİMİ
                    if (selectedRace != null) ...[
                      SizedBox(height: height * 0.025),
                      Image.asset(
                        selectedRace!.imagePath,
                        height: width * 0.7,
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        selectedRace!.tanimRace,
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.045, color: Colors.white),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.025),
                      Text(
                        "Irka Özel Değerler",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.055,
                            color: Colors.teal.shade400),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.005),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Maksimum Can Miktarı: ',
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.04,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                  Text(
                                    '${selectedRace!.health}',
                                    style: baseNumberStyle,
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.005),
                              Row(
                                children: [
                                  Text(
                                    'Maksimum Aksiyon Barı: ',
                                    style: baseTextStyle.copyWith(
                                        fontSize: width * 0.04,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                  Text(
                                    '${selectedRace!.magicBar}',
                                    style: baseNumberStyle,
                                    textAlign: TextAlign.center,
                                    textScaler: const TextScaler.linear(1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.question_circle_fill,
                              size: width * 0.08,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              switch (selectedRace!.name) {
                                case 'İnsan':
                                  showRaceInfo(
                                    "İnsanlar dengeli statü değerlerine "
                                    "sahiplerdir.\n\n"
                                    "Temel İnsan statü değerleri;\n"
                                    "Güç: 10\n"
                                    "Zeka: 10\n"
                                    "Beceri: 10\n"
                                    "Karizma: 10\n\n"
                                    "Ana statülerin sınıflara göre ham saldırı "
                                    "değerlerini etkilediği durumlar:\n\n"
                                    "Barbar: Güç\n"
                                    "Paladin: Zeka\n"
                                    "Hırsız: Karizma\n"
                                    "Korucu: Beceri\n"
                                    "Büyücü: Zeka\n\n"
                                    "Bu değerler karakterin saldırı değerini "
                                    "pozitif yönde etkiler.",
                                  );
                                  break;
                                case 'Elf':
                                  showRaceInfo(
                                    "Elfler beceri statüsünde pozitif bir etkiye "
                                    "sahiplerdir.\n\n"
                                    "Temel Elf statü değerleri;\n"
                                    "Güç: 5\n"
                                    "Zeka: 10\n"
                                    "Beceri: 20\n"
                                    "Karizma: 5\n\n"
                                    "Ana statülerin sınıflara göre ham saldırı "
                                    "değerlerini etkilediği durumlar:\n\n"
                                    "Barbar: Güç\n"
                                    "Paladin: Zeka\n"
                                    "Hırsız: Karizma\n"
                                    "Korucu: Beceri\n"
                                    "Büyücü: Zeka\n\n"
                                    "Bu değerler karakterin saldırı değerini "
                                    "pozitif yönde etkiler.",
                                  );
                                  break;
                                case 'Cüce':
                                  showRaceInfo(
                                    "Cüceler güç ve karizma statülerinde pozitif "
                                    "birer etkiye sahiplerdir.\n\n"
                                    "Temel Cüce statü değerleri;\n"
                                    "Güç: 15\n"
                                    "Zeka: 5\n"
                                    "Beceri: 5\n"
                                    "Karizma: 15\n\n"
                                    "Ana statülerin sınıflara göre ham saldırı "
                                    "değerlerini etkilediği durumlar:\n\n"
                                    "Barbar: Güç\n"
                                    "Paladin: Zeka\n"
                                    "Hırsız: Karizma\n"
                                    "Korucu: Beceri\n"
                                    "Büyücü: Zeka\n\n"
                                    "Bu değerler karakterin saldırı değerini "
                                    "pozitif yönde etkiler.",
                                  );
                                  break;
                                case 'Yarı İnsan':
                                  showRaceInfo(
                                    "Yarı İnsanlar karizma statüsünde pozitif "
                                    "bir etkiye sahiplerdir.\n\n"
                                    "Temel Yarı İnsan statü değerleri;\n"
                                    "Güç: 5\n"
                                    "Zeka: 5\n"
                                    "Beceri: 10\n"
                                    "Karizma: 20\n\n"
                                    "Ana statülerin sınıflara göre ham saldırı "
                                    "değerlerini etkilediği durumlar:\n\n"
                                    "Barbar: Güç\n"
                                    "Paladin: Zeka\n"
                                    "Hırsız: Karizma\n"
                                    "Korucu: Beceri\n"
                                    "Büyücü: Zeka\n\n"
                                    "Bu değerler karakterin saldırı değerini "
                                    "pozitif yönde etkiler.",
                                  );
                                  break;
                                case 'Yarı Ork':
                                  showRaceInfo(
                                    "Yarı Orklar güç statüsünde pozitif bir "
                                    "etkiye sahiplerdir.\n\n"
                                    "Temel Yarı Ork statü değerleri;\n"
                                    "Güç: 20\n"
                                    "Zeka: 5\n"
                                    "Beceri: 5\n"
                                    "Karizma: 10\n\n"
                                    "Ana statülerin sınıflara göre ham saldırı "
                                    "değerlerini etkilediği durumlar:\n\n"
                                    "Barbar: Güç\n"
                                    "Paladin: Zeka\n"
                                    "Hırsız: Karizma\n"
                                    "Korucu: Beceri\n"
                                    "Büyücü: Zeka\n\n"
                                    "Bu değerler karakterin saldırı değerini "
                                    "pozitif yönde etkiler.",
                                  );
                                  break;
                                case 'Yarı Şeytan':
                                  showRaceInfo(
                                    "Yarı Şeytanlar zeka statüsünde pozitif bir "
                                    "etkiye sahiplerdir.\n\n"
                                    "Temel Yarı Şeytan statü değerleri;\n"
                                    "Güç: 5\n"
                                    "Zeka: 20\n"
                                    "Beceri: 5\n"
                                    "Karizma: 15\n\n"
                                    "Ana statülerin sınıflara göre ham saldırı "
                                    "değerlerini etkilediği durumlar:\n\n"
                                    "Barbar: Güç\n"
                                    "Paladin: Zeka\n"
                                    "Hırsız: Karizma\n"
                                    "Korucu: Beceri\n"
                                    "Büyücü: Zeka\n\n"
                                    "Bu değerler karakterin saldırı değerini "
                                    "pozitif yönde etkiler.",
                                  );
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                    // SINIF SEÇİMİ BUTONLARI
                    if (selectedRace != null) ...[
                      SizedBox(height: height * 0.03),
                      Text(
                        'Sınıfını Seç:',
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.055,
                            color: Colors.teal.shade400),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.005),
                      SizedBox(
                        height: buttonHeight,
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: classes.map((cClass) {
                                  bool isSelected = selectedClass == cClass;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedClass = cClass;
                                      });
                                    },
                                    child: Container(
                                      width: buttonWidth,
                                      height: buttonHeight,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.015,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.green.withOpacity(0.8)
                                            : Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.greenAccent
                                              : Colors.black.withOpacity(0.3),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          cClass.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                "CormorantGaramond-Regular",
                                            fontSize: width * 0.045,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            // Sol glow
                            if (showLeftGlow)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: width * 0.08,
                                  height: buttonHeight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft,
                                      colors: [
                                        Colors.transparent,
                                        Colors.blueAccent.withOpacity(0.4),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            // Sağ glow
                            if (showRightGlow)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: width * 0.08,
                                  height: buttonHeight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        Colors.blueAccent.withOpacity(0.4),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    // SEÇİLEN SINIF GÖSTERİMİ
                    if (selectedClass != null) ...[
                      SizedBox(height: height * 0.025),
                      Image.asset(
                        selectedClass!.imagePath,
                        height: width * 0.7,
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        selectedClass!.tanimClass,
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.04, color: Colors.white),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.025),
                      Text(
                        "Kuşanımlar ve Yetenekler",
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.055,
                            color: Colors.teal.shade400),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.005),
                      Row(
                        children: [
                          Text(
                            'Silahlar: ',
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.04,
                                color: Colors.teal.shade400),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          Text(
                            selectedClass!.weaponTypes.join(', '),
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.04, color: Colors.white),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Diğerleri: ',
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.04,
                                color: Colors.teal.shade400),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          Text(
                            "Savunma Teçhizatları ve Tılsım",
                            style: baseTextStyle.copyWith(
                                fontSize: width * 0.04, color: Colors.white),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.005),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Yetenekler: ',
                                style: baseTextStyle.copyWith(
                                    fontSize: width * 0.04,
                                    color: Colors.teal.shade400),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  selectedClass!.magicTypes.join('\n'),
                                  style: baseTextStyle.copyWith(
                                      fontSize: width * 0.04,
                                      color: Colors.white),
                                  textScaler: const TextScaler.linear(1),
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.question_circle_fill,
                              size: width * 0.08,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              if (selectedClass!.name == 'Barbar') {
                                showSkillInfo(
                                  "Barbar Yetenekleri",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "mevcut turda düşmana, Normal Saldırı "
                                      "Değerinin '2 katı' kadar bir hasar "
                                      "uygular.",
                                  "assets/images/icons/skills/kemik_kiran.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "bulunduğu turda düşmana, Normal Saldırı "
                                      "Değerinin yanında onları sonraki tur "
                                      "boyunca korkuya sürükler ve 'saldırı "
                                      "yapamaz duruma' getirir.",
                                  "assets/images/icons/skills/kukreme.png",
                                  "Bu yetenek ile oyuncu '25 Can Puanı' feda "
                                      "ederek '1 Aksion Barı' kazanır. Ek "
                                      "olarak bu yetenek öyle hızlıdır ki, "
                                      "oyuncu bir tur daha saldırı yapabilir.",
                                  "assets/images/icons/skills/ofke_hasati.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcayarak "
                                      "oyuncunun Saldırı Değerini, sonraki "
                                      "turla beraber '3 tur' boyunca '1.5 "
                                      "katına' çıkartır. Ancak bu ritüel zaman "
                                      "aldığı için tur düşmana geçer.",
                                  "assets/images/icons/skills/guc_patlamasi.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcayarak "
                                      "oyuncunun Savunma Değerini, bulunduğu "
                                      "turla beraber '2 tur' boyunca '2 katına'"
                                      " çıkartır. Ancak bu ritüel zaman "
                                      "aldığı için tur düşmana geçer.",
                                  "assets/images/icons/skills/sarsilmaz_vucut.png",
                                );
                              } else if (selectedClass!.name == 'Paladin') {
                                showSkillInfo(
                                  "Paladin Yetenekleri",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "bulunduğu turda düşmana, 'art arda 2 "
                                      "kez' Normal Saldırı Değeri kadar hasar "
                                      "uygular.",
                                  "assets/images/icons/skills/kutsanmis.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "bulunduğu turda düşmana, Normal Saldırı "
                                      "Değeri kadar hasar uygular. Fakat bu "
                                      "yetenekteki odak etkisi sayesinde "
                                      "oyuncu, düşmana bir kez daha "
                                      "saldırabilir.",
                                  "assets/images/icons/skills/kutsal_odak.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "sonraki tur oyuncu için atılan zarın "
                                      "'Zar Değerini' arttırır. Ancak bu "
                                      "ritüel zaman aldığı için tur düşmana "
                                      "geçer.",
                                  "assets/images/icons/skills/secilmis_irade.png",
                                  "Bu yetenek oyuncunun '1 Aksiyon Barı' "
                                      "yenilemesini sağlar. Ancak bu ritüel "
                                      "zaman aldığı için tur düşmana geçer.",
                                  "assets/images/icons/skills/paladinin_duasi.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve şansa "
                                      "bağlı olarak oyuncunun Can Değerini "
                                      "'10-50 Puan' aralığında iyileştirir. "
                                      "Ancak bu ritüel zaman aldığı için tur "
                                      "düşmana geçer.",
                                  "assets/images/icons/skills/ruhani_vucut.png",
                                );
                              } else if (selectedClass!.name == 'Hırsız') {
                                showSkillInfo(
                                  "Hırsız Yetenekleri",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve şansa "
                                      "bağlı olarak düşmanın zihnini bulandırır. "
                                      "Ancak bu ritüel zaman aldığı için tur "
                                      "düşmana geçer.\n"
                                      "Zihni bulanan düşman, 'kendi hasarının' "
                                      "tamamını yada hasarının yarısını "
                                      "kendisine isabet ettirir. Eğer hasarın "
                                      "yarısı düşmana isabet ederse, kalan "
                                      "yarısı oyuncuya isabet eder.",
                                  "assets/images/icons/skills/sasirtmaca.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve '3 tur' "
                                      "boyunca düşman için atılan zarın 'Zar "
                                      "Değerini' azaltır. Ancak bu ritüel zaman "
                                      "aldığı için tur düşmana geçer.",
                                  "assets/images/icons/skills/manipulasyon.png",
                                  "Bu yetenek ile oyuncu, düşmanın Can "
                                      "Değerinden '10-50 Puan' kadar Can "
                                      "Değerini kendisi için çalmasını sağlar. "
                                      "Aynı zamanda, bu hamle oyuncuya '1 Aksiyon "
                                      "Barı' yenileme fırsatı verir.",
                                  "assets/images/icons/skills/ruh_hirsizi.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve "
                                      "oyuncuya mevcut tur için '2 farklı' zar "
                                      "atma şansı ve tekrar saldırma hakkı verir.",
                                  "assets/images/icons/skills/hileli_zar.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve oyuncu "
                                      "şansa bağlı olarak düşmana büyük bir "
                                      "hasar uygular. Bu saldırı, oyuncu "
                                      "şansına göre yön değiştirebilir ve hem "
                                      "düşman hemde oyuncu büyük hasarlar "
                                      "alabilir. Kullanırken dikkatli olunması "
                                      "gerekir.",
                                  "assets/images/icons/skills/olumcul_vurus.png",
                                );
                              } else if (selectedClass!.name == 'Korucu') {
                                showSkillInfo(
                                  "Korucu Yetenekleri",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve mevcut "
                                      "turda düşmana, Normal Saldırı Değeri "
                                      "kadar hasar uygular. Ek olarak hasarın "
                                      "yanında '%50 şansla' oyuncuya bir kez "
                                      "daha aksiyon alma fırsatı sunar.",
                                  "assets/images/icons/skills/cevik_adim.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve mevcut "
                                      "turda düşmana, Normal Saldırı Değeri "
                                      "kadar hasar uygular. Ek olarak düşmanı, "
                                      "'3 tur' boyunca zehir etkisine maruz "
                                      "bırakır. Zehir etkisi Normal Saldırı "
                                      "Değerinin 'yarısı' kadar etkilidir.",
                                  "assets/images/icons/skills/zehirli_saldiri.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve mevcut "
                                      "turda düşmana, Normal Saldırı Değerinin "
                                      "'2 katı' kadar bir hasar uygular. Şansa "
                                      "bağlı olarak bu yetenek 'sonraki tur' "
                                      "düşmanın saldırısını kendisine "
                                      "uygulamasını sağlar. Eğer oyuncu çok "
                                      "şanslıysa düşmana kendine kendi "
                                      "Saldırı Değerinin '2 katını' uygulatır.",
                                  "assets/images/icons/skills/dengesiz_ruzgar.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve şansa "
                                      "bağlı olarak oyuncunun Can Değerini "
                                      "'7-30 Puan' aralığında iyileştirir. Ek "
                                      "olarak bu yetenek öyle hızlıdır ki, "
                                      "oyuncu bir tur daha saldırı yapabilir.",
                                  "assets/images/icons/skills/doganin_hediyesi.png",
                                  "Bu yetenek oyuncuya '2 tur' boyunca, tur "
                                      "başına '1 Aksiyon Barı' yenilemesine "
                                      "olanak tanır. Ancak bu ritüel zaman "
                                      "aldığı için tur düşmana geçer.",
                                  "assets/images/icons/skills/ormanin_yankisi.png",
                                );
                              } else if (selectedClass!.name == 'Büyücü') {
                                showSkillInfo(
                                  "Büyücü Yetenekleri",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve mevcut "
                                      "turun aksiyon hakkını sonraki tura "
                                      "devreder ve sonraki tur oyuncunun '2 "
                                      "kere' aksiyon almasını sağlar.",
                                  "assets/images/icons/skills/yarinin_arzusu.png",
                                  "Bu yetenek oyuncunun '1 Aksiyon Barını' "
                                      "yeniler ve ardından oyuncunun toplam "
                                      "Aksiyon Barı miktarına göre oyuncunun "
                                      "Can Değerini 25-50 Puan kadar yeniler. "
                                      "Ancak bu ritüel zaman aldığı için tur "
                                      "düşmana geçer.",
                                  "assets/images/icons/skills/buyu_ustadi.png",
                                  "Bu yetenek '1 Aksiyon Barı' harcar ve savaşa "
                                      "bir yıldırım ruhu çağırır. Çağrılan ruh, "
                                      "çağrıldığı an düşmana oyuncunun Normal "
                                      "Saldırı Değeri kadar hasar verir ve "
                                      "sonraki '2 tur' boyunca ruh kendine "
                                      "özel bir hasarla saldırılarına devam "
                                      "eder. 2 turun sonunda ise ruh kaybolur. "
                                      "Çağırma ritüeli uzun sürdüğü için tur "
                                      "düşmana geçer.",
                                  "assets/images/icons/skills/yildirim_ruhu.png",
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
                                      "uyguladığında yetenek bozulur.",
                                  "assets/images/icons/skills/halusinasyon.png",
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
                                      "yapmazsa yetenek hep aktif kalır.",
                                  "assets/images/icons/skills/kaderin_cagrisi.png",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                    // İSİM GİRİŞİ ve BUTON
                    if (selectedClass != null) ...[
                      SizedBox(height: height * 0.03),
                      Text(
                        'Seni Çağıracakları İsim:',
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.055,
                            color: Colors.teal.shade400),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                      SizedBox(height: height * 0.01),
                      TextField(
                        maxLength: 15,
                        controller: _nameController,
                        style: baseTextStyle.copyWith(
                            fontSize: width * 0.04, color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: 'Seni hangi isimle çağıracaklar?..',
                          errorText: _nameController.text.length < 3 &&
                                  _nameController.text.isNotEmpty
                              ? 'İsim en az 3 karakter olmalı.'
                              : null,
                          hintStyle: baseTextStyle.copyWith(
                              fontSize: width * 0.04,
                              color: Colors.white.withOpacity(0.85)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onChanged: (value) {
                          if ((value.length < 3 || value.length == 3) &&
                              value.isNotEmpty) {
                            setState(() {});
                          }
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      ElevatedButton(
                        onPressed: (selectedRace != null &&
                                selectedClass != null &&
                                _nameController.text.trim().length >= 3)
                            ? () {
                                FocusScope.of(context).unfocus();
                                String playerName = _nameController.text.trim();
                                if (playerName.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                        left: width * 0.025,
                                        right: width * 0.025,
                                        bottom: height * 0.01,
                                      ),
                                      content: Text(
                                        'Lütfen bir isim girin!',
                                        style: baseTextStyle.copyWith(
                                            fontSize: width * 0.04,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                      duration: const Duration(seconds: 5),
                                    ),
                                  );
                                } else if (!isimGecerliMi(playerName)) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.only(
                                        left: width * 0.025,
                                        right: width * 0.025,
                                        bottom: height * 0.01,
                                      ),
                                      content: Text(
                                        'Uygunsuz isim, lütfen başka bir isim '
                                        'deneyin!\n\n'
                                        'İsim Kuralları:\n'
                                        'Sadece ingilizce harfler kullanılabilir!\n'
                                        'İlk harf büyük olmalıdır!\n'
                                        'Özel simge kullanılamaz!\n'
                                        'Argo kullanımı yasaktır!',
                                        style: baseTextStyle.copyWith(
                                            fontSize: width * 0.04,
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                      duration: const Duration(seconds: 5),
                                    ),
                                  );
                                } else {
                                  Character character = Character(
                                    playerName: playerName,
                                    race: selectedRace!.name,
                                    characterClass: selectedClass!.name,
                                    health: selectedRace!.health,
                                    magicBar: selectedRace!.magicBar,
                                    imagePath: selectedRace!.imagePath,
                                    maxHealth: selectedRace!.health,
                                    inventory: Inventory(),
                                    equippedItems: [],
                                    gold: 0,
                                    luckCards: 0,
                                  );
                                  pauseSound();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GamePage(
                                        character: character,
                                        hikayeNoktasi: "qo1",
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.012,
                            horizontal: width * 0.15,
                          ),
                          backgroundColor: Colors.green.withOpacity(0.8),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Maceraya Başla',
                          style: baseTextStyle.copyWith(fontSize: width * 0.05),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ),
                    ],
                  ],
                ),
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
