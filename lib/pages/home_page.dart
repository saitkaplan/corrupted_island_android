import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/pages/credits_page.dart';
import 'package:corrupted_island_android/pages/game_page.dart';
import 'package:corrupted_island_android/pages/settings_page.dart';
import 'package:corrupted_island_android/pages/start_page.dart';
import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Character? character;
  bool _isStartButtonPressed = false;
  bool _isSettingsButtonPressed = false;
  bool _isCreditsButtonPressed = false;
  String anaSayfaHikayeBelirteci = "";
  String buttonBelirteci = "assets/images/icons/buttons/continue_tr.png";

  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  Duration? position;
  double musicSesSeviyesi = 0.5;
  double effectSesSeviyesi = 1.0;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  final List<String> _announcements = [
    "Corrupted Island: Sırlar ve tehlikelerle dolu bir macera seni bekliyor!",
    "İlk defa mı buradasın? Yaptığın her seçim kaderini doğrudan değiştirir... Dikkatli ol!!!",
    "Ayarlar menüsünde müzik ve efekt seslerini kendine göre ayarlayabilirsin. Hikayeni kendi ritminde yaşa!",
    "Her başlangıç bir seçimdir. Her seçim bir sona götürür.",
    "Güven, iki başlı yılan gibidir; bir başı dostça bakar, diğeri sinsice sokar.",
    "Başa gelecek taş havadadır; kaçsan da, gelir bulur.",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadData();
    loadVolumeSettings();
    playSound();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (_currentPage < _announcements.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _effectPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    _pageController.dispose();
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
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    anaSayfaHikayeBelirteci =
        prefs.getString("mevcutHikayeNoktası") ?? "qo1";
    if (anaSayfaHikayeBelirteci == "qo1") {
      buttonBelirteci = "assets/images/icons/buttons/gamestart_tr.png";
    } else {
      buttonBelirteci = "assets/images/icons/buttons/continue_tr.png";
    }

    // Kayıtlı oyun varmı? Varsa yükle!
    bool isCharacterSaved = await Character.isCharacterSaved();
    if (isCharacterSaved) {
      character = await Character.loadSavedCharacter();
    }
    setState(() {});
  }

  void playSound() async {
    await audioPlayer.setVolume(musicSesSeviyesi);
    await audioPlayer.play(
      AssetSource('sounds/game_sounds/home_page_base_music.mp3'),
    );
    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer
          .play(AssetSource('sounds/game_sounds/home_page_base_music.mp3'));
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

  final List<Map<String, String>> surumNotlari = [
    {
      'surum': '1.1.3',
      'icerik':
          'Bu sürüm ile birlikte oyuna oyun modu olarak hızlı oyun hikayesi eklendi. Ayrıca oyun içi konfor güncellemeleri yapıldı.'
    },
    {
      'surum': '1.1.2',
      'icerik':
          'Bu sürüm ile birlikte küçük hata düzeltmeleri ve görsel geliştirmeler yapıldı.'
    },
    {
      'surum': '1.1.1',
      'icerik': 'Bu sürüm ile birlikte küçük hata düzeltmeleri yapıldı.'
    },
    {
      'surum': '1.1.0',
      'icerik': 'Bu sürüm ile birlikte en büyük güncellememizi yapmış '
          'bulunmaktayız. Yeni görseller, hikayeler, seslendirmeler, '
          'ekipmanlar, tasarım ve fazlası. Sizler için çalışmaya ve oyunu '
          'tutkuyla geliştirmeye devam ediyoruz.'
    },
    {
      'surum': '1.0.7 ve Öncesi',
      'icerik': 'Önceki sürümler test sürüm güncellemeleri olmalarıyla beraber '
          'oyunun şimdiki hale ulaşmasına en büyük desteği onlar verdi. '
          'Onlarla beraber aldığımız tüm hata ve sorunlar şuanki oyunu '
          'sizler ile buluşturdu.'
    },
  ];

  void updateNote() {
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
                      "Sürüm Notları",
                      style: baseTextStyle.copyWith(fontSize: width * 0.075),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                    SizedBox(height: height * 0.005),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: surumNotlari.map((not) {
                            return Column(
                              children: [
                                Text(
                                  'Sürüm: ${not['surum']}',
                                  style: baseNumberStyle.copyWith(
                                      fontSize: width * 0.05),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                                Text(
                                  not['icerik'] ?? '',
                                  style: baseTextStyle.copyWith(
                                      fontSize: width * 0.045),
                                  textAlign: TextAlign.center,
                                  textScaler: const TextScaler.linear(1),
                                ),
                                SizedBox(height: height * 0.025),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Text(
                      "Oyunumuzu oynadığınız için teşekkür ederiz!",
                      style: baseTextStyle.copyWith(fontSize: width * 0.05),
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
                        'Notları Kapat',
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
    return FutureBuilder<void>(
      future: loadData(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/backgrounds/primary/home_page_bg.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.125),
                        child: Image.asset(
                          'assets/images/icons/logos/app_name.png',
                          width: width * 0.5,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isStartButtonPressed = true;
                        });
                      },
                      onTapUp: (_) async {
                        setState(() {
                          _isStartButtonPressed = false;
                        });
                        loadData();
                        await Future.delayed(const Duration(milliseconds: 50));
                        pauseSound();
                        if (anaSayfaHikayeBelirteci == "qo1") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StartPage(),
                            ),
                          );
                        } else {
                          // Eğer karakter kaydedildiyse, GamePage'e devam et
                          if (character != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GamePage(
                                  character: character!,
                                  hikayeNoktasi: anaSayfaHikayeBelirteci,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      onTapCancel: () {
                        setState(() {
                          _isStartButtonPressed = false;
                        });
                      },
                      child: SizedBox(
                        height: height * 0.075,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: _isStartButtonPressed
                                ? width * 0.4
                                : width * 0.5,
                            height: _isStartButtonPressed
                                ? height * 0.06
                                : height * 0.07,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  buttonBelirteci,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isSettingsButtonPressed = true;
                        });
                      },
                      onTapUp: (_) async {
                        setState(() {
                          _isSettingsButtonPressed = false;
                        });
                        loadData();
                        await Future.delayed(const Duration(milliseconds: 50));
                        // Settings sayfasına gider
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(
                              audioPlayer: audioPlayer,
                              effectPlayer: _effectPlayer,
                            ),
                          ),
                        ).then((_) async {
                          await loadVolumeSettings(); // Reload settings after returning
                          setState(() {
                            audioPlayer.setVolume(musicSesSeviyesi);
                            _effectPlayer.setVolume(effectSesSeviyesi);
                          });
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _isSettingsButtonPressed = false;
                        });
                      },
                      child: SizedBox(
                        height: height * 0.075,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: _isSettingsButtonPressed
                                ? width * 0.4
                                : width * 0.5,
                            height: _isSettingsButtonPressed
                                ? height * 0.06
                                : height * 0.07,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/icons/buttons/settings_tr.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isCreditsButtonPressed = true;
                        });
                      },
                      onTapUp: (_) async {
                        setState(() {
                          _isCreditsButtonPressed = false;
                        });
                        loadData();
                        await Future.delayed(const Duration(milliseconds: 50));
                        // Credits sayfasına gider
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreditsPage(),
                          ),
                        );
                      },
                      onTapCancel: () {
                        setState(() {
                          _isCreditsButtonPressed = false;
                        });
                      },
                      child: SizedBox(
                        height: height * 0.075,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: _isCreditsButtonPressed
                                ? width * 0.4
                                : width * 0.5,
                            height: _isCreditsButtonPressed
                                ? height * 0.06
                                : height * 0.07,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/icons/buttons/credits_tr.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          width: width * 0.9,
                          padding: EdgeInsets.all(width * 0.035),
                          color: Colors.white.withOpacity(0.55),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Duyurular",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: "CormorantGaramond-Regular",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                textScaler: const TextScaler.linear(1),
                              ),
                              SizedBox(
                                height: height * 0.1,
                                child: PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemCount: _announcements.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Text(
                                        _announcements[index],
                                        style: TextStyle(
                                          fontSize: width * 0.0275,
                                          fontFamily: "LibreBaskerville-Bold",
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: height * 0.01,
                                  bottom: height * 0.01,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _announcements.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01,
                                      ),
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: _currentPage == index
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.065),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      updateNote();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.01),
                      child: Text(
                        "Sürüm ${surumNotlari.first['surum']}",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontFamily: "LibreBaskerville-Bold",
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/* void playButtonSound() async {
    await _effectPlayer.setVolume(effectSesSeviyesi);
    await _effectPlayer.play(
      AssetSource('sounds/effect_sounds/button_sound.mp3'),
    );
   } */
