import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:corrupted_island_android/pages/create_page.dart';
import 'package:corrupted_island_android/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with WidgetsBindingObserver {
  final List<String> storySentences = [
    "    Mistik bir dünya hayal edin... Büyülerin ve olağanüstü yaratıkların hüküm sürdüğü, yüzlerce zeki canlı türünün bir arada yaşadığı bir dünya. Bazen barışın zar zor sağlandığı, bazense kargaşanın tüm diyarları sardığı fantastik bir dünya…",
    "    İşte, bu gizemli dünyanın bir köşesinde, sadece maceracıların dilinde anılan bir ada vardı. İyi ya da kötü, herkesin ilgisini çeken devasa bir ada. Kadim zamanlarda ona başka bir ad verilmişti. Ancak bu isim, zamanın tozlu raflarında kaybolmuştu. Bugün, bu topraklar yalnızca bir adla biliniyor: Mocartim. Eski kayıtlara göre Mocartim, yemyeşil ormanları, kristal berraklığındaki nehirleri ve görkemli dağlarıyla adeta büyülü bir cennetti. Fakat anlatılanlar hep gizemlerle doluydu. Adanın kökeni, hala karanlıkta kalan bir sırdı. Eldeki sınırlı bilgilere göre, Mocartim’in adı ilk kez 'Hissin Felaketi' olarak bilinen korkunç bir olayla anılmıştı.",
    "    Rivayete göre 'Hissin Felaketi', kadim zamanlarda adada yaşayan büyücülerden bazıları, bilinmeyen bir büyü gerçekleştirmiş; ve bu büyü kontrolden çıkarak tüm adayı lanetlemişti. O an, her şey değişmişti. Mocartim'in huzurlu doğası bozulmuş, ada öfke ve kederle kıvranan bir cehenneme dönüşmüştü. Büyücüler, hatalarını telafi etmek için laneti ada ile birlikte mühürlediler. O günden sonra Mocartim, uzun yıllar belki de yüzyıllar boyunca kimsenin gitmeye dahi cesaret edemediği unutulmuş bir diyar haline geldi.",
    "    Zamanla, maceracılar bu adaya yeniden adım attı. Onlar için ada, yozlaşmış varlıklardan elde ettikleri büyülü bir sıvının kaynağıydı. Bu sıvıya pek çok isim verilmişti, fakat en çok kabul göreni Katalen olmuştu. Maceracılar, Katalen'i canavarların ölü bedenlerinden hasat ediyor; silahlarını, büyülerini ve hatta kendi bedenlerini bile güçlendirmek için kullanıyorlardı. Ve elbette... Bu sıvıyı yüksek fiyatlara satıyorlardı.",
    "    Fakat Mocartim’in laneti, hala adanın damarlarında akıyordu. Son zamanlarda yozlaşma hızla artmaya başladı. Özellikle adanın kuzey ve doğu bölgelerinde, canavarlar eskisinden çok daha güçlü ve vahşi hale geldi. Lonca'ya gelen raporlar, adadaki büyünün kontrolden çıkmak üzere olduğunu gösteriyordu. Maceracı Loncası, tüm krallıklara ve diyarların en cesur yüreklerine çağrıda bulundu. Lanetin tekrar serbest kalması ihtimali, artık göz ardı edilemeyecek bir tehlikeydi.",
    "    Ve şimdi... Sen, bu çağrıya kulak veren cesur maceracılardan birisin. Ama burada, bir soru hâlâ cevapsız: Sen kimsin? Macerana başlamadan önce... Hangi ırka aitsin? Hangi sınıfta savaşacaksın? Kim olacaksın? Bütün bunlarla beraber bu dünyada kendine bir yer edin. Ve en önemlisi kaderini... kendi seçimlerinle şekillendirmeye hazır mısın?",
  ];
  final List<String> voicePaths = [
    'sounds/voice_sounds/giris_hikayesi_vol1.mp3',
    'sounds/voice_sounds/giris_hikayesi_vol2.mp3',
    'sounds/voice_sounds/giris_hikayesi_vol3.mp3',
    'sounds/voice_sounds/giris_hikayesi_vol4.mp3',
    'sounds/voice_sounds/giris_hikayesi_vol5.mp3',
    'sounds/voice_sounds/giris_hikayesi_vol6.mp3',
  ];

  int currentSentenceIndex = 0;
  bool isTyping = true;
  List<String> displayedSentences = [];
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer2 = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  Duration? position;
  double musicSesSeviyesi = 0.5;
  double effectSesSeviyesi = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadVolumeSettings();
    playSound();
    playVoice();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    audioPlayer.dispose();
    _effectPlayer.dispose();
    _effectPlayer2.dispose();
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
  }

  void playSound() async {
    await audioPlayer.setVolume(musicSesSeviyesi);
    await audioPlayer.play(
      AssetSource('sounds/game_sounds/start_page_base_music.mp3'),
    );
    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer
          .play(AssetSource('sounds/game_sounds/start_page_base_music.mp3'));
    });
    setState(() {
      isPlaying = true;
      isPaused = false;
    });
  }

  void playVoice() async {
    await _effectPlayer2.stop();
    await _effectPlayer2.setVolume(effectSesSeviyesi);
    await _effectPlayer2.play(
      AssetSource(voicePaths[currentSentenceIndex]),
    );
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

  double _calculateTextHeight(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return textPainter.size.height;
  }

  void goToNextSentence() {
    if (!isTyping && currentSentenceIndex < storySentences.length - 1) {
      setState(() {
        currentSentenceIndex++;
        isTyping = true;
      });
      playVoice();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
      );
    } else if (currentSentenceIndex == storySentences.length - 1) {
      pauseSound();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CreatePage(),
        ),
      );
    }
  }

  void completeTyping() {
    setState(() {
      if (!displayedSentences.contains(storySentences[currentSentenceIndex])) {
        displayedSentences.add(storySentences[currentSentenceIndex]);
      }
      isTyping = false;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle baseTextStyle = TextStyle(
      fontSize: width * 0.055,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
    );

    double currentTextHeight = _calculateTextHeight(
      storySentences[currentSentenceIndex],
      baseTextStyle.copyWith(color: Colors.black),
      width * 0.9,
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backgrounds/primary/start_page_bg.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.05,
                    bottom: height * 0.065,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      completeTyping();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.1,
                        right: width * 0.1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gösterilen cümlelerin listesi
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: displayedSentences.length +
                                  (isTyping ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < displayedSentences.length) {
                                  // Gösterilen cümleler
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.03),
                                    child: Text(
                                      displayedSentences[index],
                                      style: baseTextStyle.copyWith(
                                          color: Colors.black, height: 1.2),
                                      textAlign: TextAlign.left,
                                      textScaler: const TextScaler.linear(1),
                                    ),
                                  );
                                } else {
                                  // Eklenen cümleler
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.03),
                                    child: Stack(
                                      children: [
                                        DefaultTextStyle(
                                          style: baseTextStyle.copyWith(
                                              color: Colors.black, height: 1.2),
                                          child: AnimatedTextKit(
                                            animatedTexts: [
                                              TyperAnimatedText(
                                                storySentences[
                                                    currentSentenceIndex],
                                                textStyle:
                                                    baseTextStyle.copyWith(
                                                        color: Colors.black,
                                                        height: 1.2),
                                                textAlign: TextAlign.start,
                                                speed: const Duration(
                                                  milliseconds: 75,
                                                ),
                                              ),
                                            ],
                                            onFinished: completeTyping,
                                            totalRepeatCount: 1,
                                            pause: const Duration(
                                                milliseconds: 500),
                                            displayFullTextOnTap: true,
                                            isRepeatingAnimation: false,
                                          ),
                                        ),
                                        Container(
                                          height: (currentTextHeight +
                                              (height * 0.11)),
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: height * 0.015),
                          if (!isTyping)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(35.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(35.0),
                                  onTap: () {
                                    goToNextSentence();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                      horizontal: width * 0.025,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreenAccent.shade700
                                          .withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: width * 0.1,
                                        left: width * 0.1,
                                      ),
                                      child: Text(
                                        currentSentenceIndex <
                                                storySentences.length - 1
                                            ? 'Devam Et'
                                            : 'Oyuna Başla',
                                        style: baseTextStyle,
                                        textAlign: TextAlign.center,
                                        textScaler: const TextScaler.linear(1),
                                      ),
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
