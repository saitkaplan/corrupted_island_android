import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({super.key});

  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> with WidgetsBindingObserver {
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
      effectSesSeviyesi = prefs.getDouble('effectSesSeviyesi') ?? 1.0;
    });
    _effectPlayer.setVolume(effectSesSeviyesi);
  }

  Future<void> openLinkedInProfile(String profileId) async {
    final Uri linkedInAppUrl = Uri.parse('linkedin://profile/$profileId');
    final Uri linkedInWebUrl =
        Uri.parse('https://www.linkedin.com/in/$profileId');
    // İlk olarak LinkedIn uygulamasıyla açmayı dener.
    if (await canLaunchUrl(linkedInAppUrl)) {
      await launchUrl(linkedInAppUrl);
    } else {
      // Eğer uygulama yüklü değilse, tarayıcıda açar.
      await launchUrl(linkedInWebUrl, mode: LaunchMode.externalApplication);
    }
  }

  Widget buildRichTextWithLink({
    required String firstPart,
    required String linkText,
    required String linkUrl,
    required String secondPart,
    required TextStyle textStyle,
    required TextStyle linkStyle,
    void Function()? onTap,
  }) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(
            text: firstPart,
          ),
          TextSpan(
            text: linkText,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = onTap ?? () => launchUrl(Uri.parse(linkUrl)),
          ),
          TextSpan(
            text: secondPart,
          ),
        ],
      ),
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
    TextStyle baseNumberStyle = TextStyle(
      fontSize: width * 0.0625,
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
    TextStyle specialLinkTextStyle = TextStyle(
      fontSize: width * 0.055,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );
    TextStyle linkTextStyle = TextStyle(
      fontSize: width * 0.04,
      fontFamily: "CormorantGaramond-Regular",
      fontWeight: FontWeight.bold,
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/backgrounds/primary/credits_page_bg.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: statusBarHeight,
                horizontal: width * 0.1,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Büyütülmüş Siyah Çerçeve (Aktif Değil)
                      Transform.scale(
                        scale: 1.0275,
                        child: Image.asset(
                          "assets/images/icons/logos/ers_logo.png",
                          width: width * 0.85,
                          height: width * 0.85,
                          color: Colors.transparent,
                        ),
                      ),
                      // Asıl Resim
                      Image.asset(
                        "assets/images/icons/logos/ers_logo.png",
                        width: width * 0.85,
                        height: width * 0.85,
                      ),
                      // Resm İçi Yazı
                      Positioned(
                        bottom: height * 0.015,
                        child: Text(
                          "Sunar",
                          style:
                              baseTextStyle.copyWith(fontSize: width * 0.075),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1),
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Emeği Geçenler',
                    style: baseTextStyle.copyWith(fontSize: width * 0.1),
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    'Proje Yönetim',
                    style: baseNumberStyle,
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  Text(
                    'Sait Kaplan',
                    style: baseTextStyle.copyWith(fontSize: width * 0.055),
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    'Sanat Yönetmeni',
                    style: baseNumberStyle,
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  Text(
                    'Sait Kaplan',
                    style: baseTextStyle.copyWith(fontSize: width * 0.055),
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    '3D Tasarım',
                    style: baseNumberStyle,
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  Text(
                    'Kemal Sait Eser',
                    style: baseTextStyle.copyWith(fontSize: width * 0.055),
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    'Kodlama ve Hikaye',
                    style: baseNumberStyle,
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  GestureDetector(
                    onTap: () => openLinkedInProfile('saitkaplan'),
                    child: Text(
                      'Sait Kaplan',
                      style: specialLinkTextStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => openLinkedInProfile('kemal-said-eser'),
                    child: Text(
                      'Kemal Sait Eser',
                      style: specialLinkTextStyle,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    'Atıflar',
                    style: baseNumberStyle,
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  SizedBox(height: height * 0.005),
                  buildRichTextWithLink(
                    firstPart: 'Uygulama içerisinde kullanılan '
                        'tüm efekt ve müzikler ',
                    linkText: 'Pixabay.com',
                    linkUrl: 'https://www.pixabay.com',
                    secondPart: ' sitesi üzerinden temin edilmiştir. '
                        'Kendilerine özel teşekkürlerimizi sunarız.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  SizedBox(height: height * 0.02),
                  buildRichTextWithLink(
                    firstPart: 'Ana sayfada kullanılan buton tasarımları ',
                    linkText: 'Vecteezy.com',
                    linkUrl: 'https://www.vecteezy.com/',
                    secondPart: ' sitesi üzerinden temin edilmiş olup.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  buildRichTextWithLink(
                    firstPart: 'Yine bu site üyesi olan ',
                    linkText: 'Yuliya Pauliukevich',
                    linkUrl: 'https://www.vecteezy.com/members/klyaksun',
                    secondPart: ' tarafından oluşturulmuştur. Kendilerine '
                        'özel teşekkürlerimizi sunarız.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  SizedBox(height: height * 0.02),
                  buildRichTextWithLink(
                    firstPart: 'Ana sayfada kullanılan müzik ',
                    linkText: 'Guilherme Bernardes William',
                    linkUrl: 'https://pixabay.com/tr/users/'
                        'guilhermebernardes-24203804/',
                    secondPart: ' tarafından oluşturulmuştur.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  SizedBox(height: height * 0.02),
                  buildRichTextWithLink(
                    firstPart: 'Başlangıç hikaye akış sayfasında '
                        'kullanılan müzik ',
                    linkText: 'Anastasia Kir',
                    linkUrl: 'https://pixabay.com/tr/users/'
                        'music_for_videos-26992513/',
                    secondPart: ' tarafından oluşturulmuştur.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  SizedBox(height: height * 0.02),
                  buildRichTextWithLink(
                    firstPart: 'Karakter oluşturma sayfasında '
                        'kullanılan müzik ',
                    linkText: 'elias_weber',
                    linkUrl: 'https://pixabay.com/tr/users/'
                        'elias_weber-6810638/',
                    secondPart: ' tarafından oluşturulmuştur.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  SizedBox(height: height * 0.02),
                  buildRichTextWithLink(
                    firstPart: 'Oyun akışı sayfasında kullanılan müzik ',
                    linkText: 'sonoko n',
                    linkUrl: 'https://pixabay.com/tr/users/'
                        '_sonoko_-33309096/',
                    secondPart: ' tarafından oluşturulmuştur.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  SizedBox(height: height * 0.02),
                  buildRichTextWithLink(
                    firstPart: 'Savaş sayfasında yer alan müzik ',
                    linkText: 'anonim',
                    linkUrl: 'https://pixabay.com/tr/music/'
                        'ana-baslk-battle-of-the-dragons-8037/',
                    secondPart: ' bir çalışmadır; bestecisinin kimliği '
                        'bilinmemektedir.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  SizedBox(height: height * 0.02),
                  buildRichTextWithLink(
                    firstPart: 'Savaş sayfasında kullanılan efekt sesleri;\n',
                    linkText: 'freesound_community',
                    linkUrl: 'https://pixabay.com/users/'
                        'freesound_community-46691455/',
                    secondPart: '',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  buildRichTextWithLink(
                    firstPart: '',
                    linkText: 'Alice_soundz',
                    linkUrl: 'https://pixabay.com/users/'
                        'alice_soundz-44907632/',
                    secondPart: '',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  buildRichTextWithLink(
                    firstPart: '',
                    linkText: 'DavidDumaisAudio',
                    linkUrl: 'https://pixabay.com/users/'
                        'daviddumaisaudio-41768500/',
                    secondPart: '',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  buildRichTextWithLink(
                    firstPart: '',
                    linkText: 'RescopicSound',
                    linkUrl: 'https://pixabay.com/users/'
                        'rescopicsound-45188866/',
                    secondPart: '\nkullanıcıları tarafından oluşturulmuştur. '
                        'Bütün müzik ve efekt sesi üreticilerine özel '
                        'teşekkürlerimizi sunarız.',
                    textStyle: baseTextStyle.copyWith(fontSize: width * 0.04),
                    linkStyle: linkTextStyle,
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    "Oyunumuzu oynadığınız için çok ama çok teşekkür ederiz.",
                    style: baseTextStyle.copyWith(fontSize: width * 0.055),
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(1),
                  ),
                  SizedBox(height: height * 0.2),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: height * 0.075),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(35),
                color: Colors.greenAccent.shade700,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Text(
                      "Teşekkürlerimizi Sunarız",
                      style: baseTextStyle.copyWith(fontSize: width * 0.05),
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(1),
                    ),
                  ),
                ),
              ),
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
                      'assets/images/backgrounds/primary/credits_page_bg.png',
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
