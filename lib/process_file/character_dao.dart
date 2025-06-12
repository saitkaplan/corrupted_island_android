import 'package:corrupted_island_android/process_file/object_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Race {
  final String name;
  final String imagePath;
  final String tanimRace;
  final int health;
  final int magicBar;

  Race({
    required this.name,
    required this.imagePath,
    required this.tanimRace,
    required this.health,
    required this.magicBar,
  });
}

final List<Race> races = [
  Race(
    name: 'İnsan',
    imagePath: 'assets/images/icons/races/human.png',
    tanimRace: 'İnsanlar, çok yönlü olmasıyla ünlü bir ırktır. Ortalama ve '
        'dengeli dayanıklık ve aksiyon barlarına sahiplerdir.',
    health: 200,
    magicBar: 3,
  ),
  Race(
    name: 'Elf',
    imagePath: 'assets/images/icons/races/elf.png',
    tanimRace: 'Elfler, zarif bir ırktır ve dayanıklıkları insana göre az '
        'olmasına karşın ruhsal güçleri yüksek olmasıyla beraber aksiyon '
        'barları da yüksek seviyededir.',
    health: 150,
    magicBar: 4,
  ),
  Race(
    name: 'Cüce',
    imagePath: 'assets/images/icons/races/dwarf.png',
    tanimRace: 'Cüceler, dayanıklı bir ırktır ve buna bağlı değerleri oldukça '
        'yüksektir fakat fiziksel yapılarından dolayı aksiyon barları sınırlıdır.',
    health: 250,
    magicBar: 2,
  ),
  Race(
    name: 'Yarı İnsan',
    imagePath: 'assets/images/icons/races/halfhuman.png',
    tanimRace: 'Yarı insanlar, elf ve insan soylarının bir karışımıdır ve '
        'insanlara göre nisbeten düşük dayanıklığa sahip olmalarına karşın '
        'elflerden gelen ruhsal güçleri onlara yüksek aksiyon puanları bahşetmiştir.',
    health: 175,
    magicBar: 4,
  ),
  Race(
    name: 'Yarı Ork',
    imagePath: 'assets/images/icons/races/halforc.png',
    tanimRace: 'Yarı orklar, ork ve insan soylarının karışımıdır ve ork '
        'genleri sayesinde oldukça yüksek bir dayanıklığa sahiplerdir fakat '
        'zekalarının düşük olmasından dolayı oldukça kısıtlı aksiyon barlarına sahiplerdir.',
    health: 300,
    magicBar: 1,
  ),
  Race(
    name: 'Yarı Şeytan',
    imagePath: 'assets/images/icons/races/halfdemon.png',
    tanimRace: 'Yarı şeytanlar, elf ve şeytan soylarının karışımıdır ve çok '
        'yüksek aksiyon barlarına, bununla beraber şeytan ve elf kanının '
        'zıtlığından gelen çok düşük bir dayanıklılığa sahiplerdir.',
    health: 100,
    magicBar: 6,
  ),
];

class CharacterClass {
  final String name;
  final String imagePath;
  final String tanimClass;
  final List<String> weaponTypes;
  final List<String> magicTypes;

  CharacterClass({
    required this.name,
    required this.imagePath,
    required this.tanimClass,
    required this.weaponTypes,
    required this.magicTypes,
  });
}

final List<CharacterClass> classes = [
  CharacterClass(
    name: 'Barbar',
    imagePath: 'assets/images/icons/classes/barbarian.png',
    tanimClass: 'Barbar sınıfı daha çok saldırı odaklı bir sınıftır. '
        'Genellikle kılıç ve balta gibi silahları ustalıkla kullanırlar. Bunun '
        'yanında ikincil silah olarak kalkan kullanırlar. Bunlara '
        'karşın fiziksel etki aksiyonları kullanarak kendi vücutlarını '
        'güçlendirirler.',
    weaponTypes: ['Kılıç', 'Balta', 'Kalkan'],
    magicTypes: [
      'Kemik Kıran',
      'Kükreme',
      'Öfke Hasatı',
      'Güç Patlaması',
      'Sarsılmaz Vücut',
    ],
  ),
  CharacterClass(
    name: 'Paladin',
    imagePath: 'assets/images/icons/classes/paladin.png',
    tanimClass: 'Paladinler kutsal savaşçılardır ve hem büyü hemde dövüş '
        'yeteneklerine sahiplerdir. Bu yeteneklerini kılıç, balta ve yay '
        'silahlarıyla beraber ustalıkla kullanabilirler. Bunun yanında ikincil'
        'silah olarak kalkan kullanırlar. Kendilerini yenilemede ve art arda '
        'saldırılarda farklılıklarını ortaya koyarlar.',
    weaponTypes: ['Kılıç', 'Balta', 'Yay', 'Kalkan'],
    magicTypes: [
      'Kutsanmış',
      'Kutsal Odak',
      'Seçilmiş İrade',
      "Paladin'in Duası",
      'Ruhani Vücut',
    ],
  ),
  CharacterClass(
    name: 'Hırsız',
    imagePath: 'assets/images/icons/classes/rogue.png',
    tanimClass: 'Hırsızlar, sinsi hareketleri ve buna bağlı aksiyonlara sahip '
        'özel bir sınıftır. Bu tür aksiyonlara uygun kılıç ve hançer gibi '
        'silahları ustalıkla kullanabilirler. Bunun yanında ikincil silah '
        'olarak bıçak kullanırlar. Kendilerini riske atmayı seven hırsızlar '
        'düşmana çok büyük hasarlar uygulayabilirler.',
    weaponTypes: ['Kılıç', 'Hançer', 'Bıçak'],
    magicTypes: [
      'Şaşırtmaca',
      'Manipülasyon',
      'Ruh Hırsızı',
      'Hileli Zar',
      'Ölümcül Vuruş',
    ],
  ),
  CharacterClass(
    name: 'Korucu',
    imagePath: 'assets/images/icons/classes/ranger.png',
    tanimClass:
        'Korucular uzak ve orta mesafeli dövüşlerde usta sınıflardandır.'
        ' Yay, arbalet ve hançerleri ustalıkla kullanabilirler. Bunun yanında '
        'ikincil silah olarak bıçak kullanırlar. Düşmana zehir uygulamak veya'
        'düşmanın dengesini bozup kendine saldırtma gibi özel saldırılar yapabilirler',
    weaponTypes: ['Yay', 'Arbalet', 'Hançer', 'Bıçak'],
    magicTypes: [
      'Çevik Adım',
      'Zehirli Saldırı',
      'Dengesiz Rüzgar',
      'Doğanın Hediyesi',
      'Ormanın Yankısı',
    ],
  ),
  CharacterClass(
    name: 'Büyücü',
    imagePath: 'assets/images/icons/classes/wizard.png',
    tanimClass: 'Büyücüler element büyüleri ve kontrol büyülerinde ustalardır '
        've asıl askiyonları zamana bağlı büyüler yapmaktır. Nadiren hançer '
        'kullansalarda genelde asa kullanırlar. Bunun yanında ikincil silah '
        'olarak büyülü rünik taşlar kullanırlar. Büyücüler savaşlarda düşmanı '
        'veya savaş alanını etkileyen büyüler, zamanı yönetme gibi büyüler yapabilirler.',
    weaponTypes: ['Hançer', 'Asa', 'Rünik Taş'],
    magicTypes: [
      'Yarının Arzusu',
      'Büyü Üstadı',
      'Yıldırım Ruhu',
      'Halüsinasyon',
      'Kaderin Çağrısı',
    ],
  ),
];

class Character {
  //Karakter Metrikleri
  String playerName;
  String race;
  String characterClass;
  String imagePath;
  int level;
  int xp;
  int maxXp;
  int health;
  int maxHealth;
  int magicBar;
  int gold;
  int luckCards;
  int resetCards;
  int healthPot;
  int manaPot;
  // Günlük Listesi
  List<String> daily;
  bool dailyController;
  // Gelişim Puanları
  int skillPoints;
  int hizPoints;
  // Üretim Kaynakları
  int katalen;
  int kristalKalp;
  int organikParcalar;
  int bosSise;
  bool productController;
  // Oyun Sonu İçin Sayaçlar
  int defeatedEnemies;
  int criticalChoice;
  int totalChoice;
  int purchasedItem;
  int totalDamageToEnemies;
  int entryShop;
  int totalEarnedXP;
  int usesLuckCards;
  int spentMoney;
  int totalSkillPoints;
  int totalHizPoints;
  // Sayfa Tanıtımları İçin Sayaçlar
  int firstEntryGamePage;
  int firstEntryStatusPage;
  int firstEntryMarketPage;
  int firstEntryShopPage;
  int firstEntryWarPage;
  int firstEntryDailyPage;
  int firstEntryProductionPage;
  int firstEntryUpgradePage;
  // Sayfa kontrolleri ve giriş denetimleri
  bool isReadyOpenInventory;
  // Yetenek Kilit ve Bekleme Süreleri
  bool firstSkillLock;
  bool secondSkillLock;
  bool thirdSkillLock;
  bool fourthSkillLock;
  bool fifthSkillLock;
  int firstSkillCooldown;
  int secondSkillCooldown;
  int thirdSkillCooldown;
  int fourthSkillCooldown;
  int fifthSkillCooldown;
  // Diğer Gelişim Değişkenleri
  int strengthPlus;
  int intelligencePlus;
  int dexterityPlus;
  int charismaPlus;
  int productEfficiency;
  // Envanter ve Giyili Eşyalar İçin Özel Metrikler
  List<Item?> equippedItems;
  Inventory inventory;

  Character({
    required this.playerName,
    required this.race,
    required this.characterClass,
    required this.imagePath,
    this.level = 1,
    this.xp = 0,
    this.maxXp = 1000,
    required this.health,
    required this.maxHealth,
    required this.magicBar,
    this.gold = 0,
    this.luckCards = 0,
    this.resetCards = 0,
    this.healthPot = 0,
    this.manaPot = 0,
    this.daily = const [],
    this.dailyController = false,
    this.skillPoints = 0,
    this.hizPoints = 0,
    this.katalen = 0,
    this.kristalKalp = 0,
    this.organikParcalar = 0,
    this.bosSise = 0,
    this.productController = false,
    this.defeatedEnemies = 0,
    this.criticalChoice = 0,
    this.totalChoice = 0,
    this.purchasedItem = 0,
    this.totalDamageToEnemies = 0,
    this.entryShop = 0,
    this.totalEarnedXP = 0,
    this.usesLuckCards = 0,
    this.spentMoney = 0,
    this.totalSkillPoints = 0,
    this.totalHizPoints = 0,
    this.firstEntryGamePage = 0,
    this.firstEntryStatusPage = 0,
    this.firstEntryMarketPage = 0,
    this.firstEntryShopPage = 0,
    this.firstEntryWarPage = 0,
    this.firstEntryDailyPage = 0,
    this.firstEntryProductionPage = 0,
    this.firstEntryUpgradePage = 0,
    this.isReadyOpenInventory = false,
    this.firstSkillLock = false,
    this.secondSkillLock = false,
    this.thirdSkillLock = false,
    this.fourthSkillLock = false,
    this.fifthSkillLock = false,
    this.firstSkillCooldown = 8,
    this.secondSkillCooldown = 8,
    this.thirdSkillCooldown = 8,
    this.fourthSkillCooldown = 8,
    this.fifthSkillCooldown = 8,
    this.strengthPlus = 0,
    this.intelligencePlus = 0,
    this.dexterityPlus = 0,
    this.charismaPlus = 0,
    this.productEfficiency = 0,
    required this.equippedItems,
    required this.inventory,
  });

  // Character verilerini kaydetme
  Future<void> saveCharacterData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('playerName', playerName);
    await prefs.setString('race', race);
    await prefs.setString('class', characterClass);
    await prefs.setString('imagePath', imagePath);
    await prefs.setInt('level', level);
    await prefs.setInt('xp', xp);
    await prefs.setInt('maxXp', maxXp);
    await prefs.setInt('health', health);
    await prefs.setInt('maxHealth', maxHealth);
    await prefs.setInt('magicBar', magicBar);
    await prefs.setInt('gold', gold);
    await prefs.setInt('luckCards', luckCards);
    await prefs.setInt('resetCards', resetCards);
    await prefs.setInt('healthPot', healthPot);
    await prefs.setInt('manaPot', manaPot);
    await prefs.setStringList('daily', daily);
    await prefs.setBool("dailyController", dailyController);
    await prefs.setInt('skillPoints', skillPoints);
    await prefs.setInt('hizPoints', hizPoints);
    await prefs.setInt('katalen', katalen);
    await prefs.setInt('kristalKalp', kristalKalp);
    await prefs.setInt('organikParcalar', organikParcalar);
    await prefs.setInt('bosSise', bosSise);
    await prefs.setBool("productController", productController);
    await prefs.setInt('defeatedEnemies', defeatedEnemies);
    await prefs.setInt('criticalChoice', criticalChoice);
    await prefs.setInt('totalChoice', totalChoice);
    await prefs.setInt('purchasedItem', purchasedItem);
    await prefs.setInt('totalDamageToEnemies', totalDamageToEnemies);
    await prefs.setInt('entryShop', entryShop);
    await prefs.setInt('totalEarnedXP', totalEarnedXP);
    await prefs.setInt('usesLuckCards', usesLuckCards);
    await prefs.setInt('spentMoney', spentMoney);
    await prefs.setInt('totalSkillPoints', totalSkillPoints);
    await prefs.setInt('totalHizPoints', totalHizPoints);
    await prefs.setInt('firstEntryGamePage', firstEntryGamePage);
    await prefs.setInt('firstEntryStatusPage', firstEntryStatusPage);
    await prefs.setInt('firstEntryMarketPage', firstEntryMarketPage);
    await prefs.setInt('firstEntryShopPage', firstEntryShopPage);
    await prefs.setInt('firstEntryWarPage', firstEntryWarPage);
    await prefs.setInt('firstEntryDailyPage', firstEntryDailyPage);
    await prefs.setInt('firstEntryProductionPage', firstEntryProductionPage);
    await prefs.setInt('firstEntryUpgradePage', firstEntryUpgradePage);
    await prefs.setBool("isReadyOpenInventory", isReadyOpenInventory);
    await prefs.setBool("firstSkillLock", firstSkillLock);
    await prefs.setBool("secondSkillLock", secondSkillLock);
    await prefs.setBool("thirdSkillLock", thirdSkillLock);
    await prefs.setBool("fourthSkillLock", fourthSkillLock);
    await prefs.setBool("fifthSkillLock", fifthSkillLock);
    await prefs.setInt('firstSkillCooldown', firstSkillCooldown);
    await prefs.setInt('secondSkillCooldown', secondSkillCooldown);
    await prefs.setInt('thirdSkillCooldown', thirdSkillCooldown);
    await prefs.setInt('fourthSkillCooldown', fourthSkillCooldown);
    await prefs.setInt('fifthSkillCooldown', fifthSkillCooldown);
    await prefs.setInt('strengthPlus', strengthPlus);
    await prefs.setInt('intelligencePlus', intelligencePlus);
    await prefs.setInt('dexterityPlus', dexterityPlus);
    await prefs.setInt('charismaPlus', charismaPlus);
    await prefs.setInt('productEfficiency', productEfficiency);

    List<String> equippedItemNames =
        equippedItems.map((item) => item?.name ?? '').toList();
    await prefs.setStringList('equippedItems', equippedItemNames);

    List<String> inventoryItemNames =
        inventory.items.map((item) => item?.name ?? '').toList();
    await prefs.setStringList('inventoryItems', inventoryItemNames);
  }

  // Character verilerini yükleme
  Future<void> loadCharacterData() async {
    final prefs = await SharedPreferences.getInstance();

    playerName = prefs.getString('playerName') ?? "";
    race = prefs.getString('race') ?? "";
    characterClass = prefs.getString('class') ?? "";
    imagePath = prefs.getString('imagePath') ?? "";
    level = prefs.getInt('level') ?? 1;
    xp = prefs.getInt('xp') ?? 0;
    maxXp = prefs.getInt('maxXp') ?? 1000;
    health = prefs.getInt('health') ?? maxHealth;
    maxHealth = prefs.getInt('maxHealth') ?? maxHealth;
    magicBar = prefs.getInt('magicBar') ?? 0;
    gold = prefs.getInt('gold') ?? 0;
    luckCards = prefs.getInt('luckCards') ?? 0;
    resetCards = prefs.getInt('resetCards') ?? 0;
    healthPot = prefs.getInt('healthPot') ?? 0;
    manaPot = prefs.getInt('manaPot') ?? 0;
    daily = prefs.getStringList('daily') ?? [];
    dailyController = prefs.getBool("dailyController") ?? false;
    skillPoints = prefs.getInt('skillPoints') ?? 0;
    hizPoints = prefs.getInt('hizPoints') ?? 0;
    katalen = prefs.getInt('katalen') ?? 0;
    kristalKalp = prefs.getInt('kristalKalp') ?? 0;
    organikParcalar = prefs.getInt('organikParcalar') ?? 0;
    bosSise = prefs.getInt('bosSise') ?? 0;
    productController = prefs.getBool("productController") ?? false;
    defeatedEnemies = prefs.getInt('defeatedEnemies') ?? 0;
    criticalChoice = prefs.getInt('criticalChoice') ?? 0;
    totalChoice = prefs.getInt('totalChoice') ?? 0;
    purchasedItem = prefs.getInt('purchasedItem') ?? 0;
    totalDamageToEnemies = prefs.getInt('totalDamageToEnemies') ?? 0;
    entryShop = prefs.getInt('entryShop') ?? 0;
    totalEarnedXP = prefs.getInt('totalEarnedXP') ?? 0;
    usesLuckCards = prefs.getInt('usesLuckCards') ?? 0;
    spentMoney = prefs.getInt('spentMoney') ?? 0;
    totalSkillPoints = prefs.getInt('totalSkillPoints') ?? 0;
    totalHizPoints = prefs.getInt('totalHizPoints') ?? 0;
    firstEntryGamePage = prefs.getInt('firstEntryGamePage') ?? 0;
    firstEntryStatusPage = prefs.getInt('firstEntryStatusPage') ?? 0;
    firstEntryMarketPage = prefs.getInt('firstEntryMarketPage') ?? 0;
    firstEntryShopPage = prefs.getInt('firstEntryShopPage') ?? 0;
    firstEntryWarPage = prefs.getInt('firstEntryWarPage') ?? 0;
    firstEntryDailyPage = prefs.getInt('firstEntryDailyPage') ?? 0;
    firstEntryProductionPage = prefs.getInt('firstEntryProductionPage') ?? 0;
    firstEntryUpgradePage = prefs.getInt('firstEntryUpgradePage') ?? 0;
    isReadyOpenInventory = prefs.getBool("isReadyOpenInventory") ?? false;
    firstSkillLock = prefs.getBool("firstSkillLock") ?? false;
    secondSkillLock = prefs.getBool("secondSkillLock") ?? false;
    thirdSkillLock = prefs.getBool("thirdSkillLock") ?? false;
    fourthSkillLock = prefs.getBool("fourthSkillLock") ?? false;
    fifthSkillLock = prefs.getBool("fifthSkillLock") ?? false;
    firstSkillCooldown = prefs.getInt('firstSkillCooldown') ?? 8;
    secondSkillCooldown = prefs.getInt('secondSkillCooldown') ?? 8;
    thirdSkillCooldown = prefs.getInt('thirdSkillCooldown') ?? 8;
    fourthSkillCooldown = prefs.getInt('fourthSkillCooldown') ?? 8;
    fifthSkillCooldown = prefs.getInt('fifthSkillCooldown') ?? 8;
    strengthPlus = prefs.getInt('strengthPlus') ?? 0;
    intelligencePlus = prefs.getInt('intelligencePlus') ?? 0;
    dexterityPlus = prefs.getInt('dexterityPlus') ?? 0;
    charismaPlus = prefs.getInt('charismaPlus') ?? 0;
    productEfficiency = prefs.getInt('productEfficiency') ?? 0;

    List<String>? equippedItemNames = prefs.getStringList('equippedItems');
    if (equippedItemNames != null) {
      equippedItems = equippedItemNames.map((name) {
        if (name.isEmpty) {
          return null;
        } else {
          return allItems.firstWhere((item) => item.name == name,
              orElse: () => emptyItem);
        }
      }).toList();
    }

    List<String>? inventoryItemNames = prefs.getStringList('inventoryItems');
    if (inventoryItemNames != null) {
      inventory.items = inventoryItemNames.map((name) {
        if (name.isEmpty) {
          return null;
        } else {
          return allItems.firstWhere((item) => item.name == name,
              orElse: () => emptyItem);
        }
      }).toList();
    }
  }

  // Kaydedilmiş karakter verisini kontrol etme
  static Future<bool> isCharacterSaved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('playerName') &&
        prefs.containsKey('race') &&
        prefs.containsKey('class') &&
        prefs.containsKey('health');
  }

  // Kaydedilmiş bir karakteri yükleme
  static Future<Character> loadSavedCharacter() async {
    final prefs = await SharedPreferences.getInstance();

    String playerName = prefs.getString('playerName') ?? "";
    String race = prefs.getString('race') ?? "";
    String characterClass = prefs.getString('class') ?? "";
    String imagePath = prefs.getString('imagePath') ?? "";
    int level = prefs.getInt('level') ?? 1;
    int xp = prefs.getInt('xp') ?? 0;
    int maxXp = prefs.getInt('maxXp') ?? 1000;
    int health = prefs.getInt('health') ?? 100;
    int maxHealth = prefs.getInt('maxHealth') ?? 100;
    int magicBar = prefs.getInt('magicBar') ?? 0;
    int gold = prefs.getInt('gold') ?? 0;
    int luckCards = prefs.getInt('luckCards') ?? 0;
    int resetCards = prefs.getInt('resetCards') ?? 0;
    int healthPot = prefs.getInt('healthPot') ?? 0;
    int manaPot = prefs.getInt('manaPot') ?? 0;
    List<String> daily = prefs.getStringList('daily') ?? [];
    bool dailyController = prefs.getBool("dailyController") ?? false;
    int skillPoints = prefs.getInt('skillPoints') ?? 0;
    int hizPoints = prefs.getInt('hizPoints') ?? 0;
    int katalen = prefs.getInt('katalen') ?? 0;
    int kristalKalp = prefs.getInt('kristalKalp') ?? 0;
    int organikParcalar = prefs.getInt('organikParcalar') ?? 0;
    int bosSise = prefs.getInt('bosSise') ?? 0;
    bool productController = prefs.getBool("productController") ?? false;
    int defeatedEnemies = prefs.getInt('defeatedEnemies') ?? 0;
    int criticalChoice = prefs.getInt('criticalChoice') ?? 0;
    int totalChoice = prefs.getInt('totalChoice') ?? 0;
    int purchasedItem = prefs.getInt('purchasedItem') ?? 0;
    int totalDamageToEnemies = prefs.getInt('totalDamageToEnemies') ?? 0;
    int entryShop = prefs.getInt('entryShop') ?? 0;
    int totalEarnedXP = prefs.getInt('totalEarnedXP') ?? 0;
    int usesLuckCards = prefs.getInt('usesLuckCards') ?? 0;
    int spentMoney = prefs.getInt('spentMoney') ?? 0;
    int totalSkillPoints = prefs.getInt('totalSkillPoints') ?? 0;
    int totalHizPoints = prefs.getInt('totalHizPoints') ?? 0;
    int firstEntryGamePage = prefs.getInt('firstEntryGamePage') ?? 0;
    int firstEntryStatusPage = prefs.getInt('firstEntryStatusPage') ?? 0;
    int firstEntryMarketPage = prefs.getInt('firstEntryMarketPage') ?? 0;
    int firstEntryShopPage = prefs.getInt('firstEntryShopPage') ?? 0;
    int firstEntryWarPage = prefs.getInt('firstEntryWarPage') ?? 0;
    int firstEntryDailyPage = prefs.getInt('firstEntryDailyPage') ?? 0;
    int firstEntryProductionPage =
        prefs.getInt('firstEntryProductionPage') ?? 0;
    int firstEntryUpgradePage = prefs.getInt('firstEntryUpgradePage') ?? 0;
    bool isReadyOpenInventory = prefs.getBool("isReadyOpenInventory") ?? false;
    bool firstSkillLock = prefs.getBool("firstSkillLock") ?? false;
    bool secondSkillLock = prefs.getBool("secondSkillLock") ?? false;
    bool thirdSkillLock = prefs.getBool("thirdSkillLock") ?? false;
    bool fourthSkillLock = prefs.getBool("fourthSkillLock") ?? false;
    bool fifthSkillLock = prefs.getBool("fifthSkillLock") ?? false;
    int firstSkillCooldown = prefs.getInt('firstSkillCooldown') ?? 8;
    int secondSkillCooldown = prefs.getInt('secondSkillCooldown') ?? 8;
    int thirdSkillCooldown = prefs.getInt('thirdSkillCooldown') ?? 8;
    int fourthSkillCooldown = prefs.getInt('fourthSkillCooldown') ?? 8;
    int fifthSkillCooldown = prefs.getInt('fifthSkillCooldown') ?? 8;
    int strengthPlus = prefs.getInt('strengthPlus') ?? 0;
    int intelligencePlus = prefs.getInt('intelligencePlus') ?? 0;
    int dexterityPlus = prefs.getInt('dexterityPlus') ?? 0;
    int charismaPlus = prefs.getInt('charismaPlus') ?? 0;
    int productEfficiency = prefs.getInt('productEfficiency') ?? 0;

    List<String>? equippedItemNames = prefs.getStringList('equippedItems');
    List<Item?> equippedItems = equippedItemNames != null
        ? equippedItemNames.map((name) {
            if (name.isEmpty) {
              return null;
            } else {
              return allItems.firstWhere((item) => item.name == name,
                  orElse: () => emptyItem);
            }
          }).toList()
        : List.generate(7, (index) => null);

    List<String>? inventoryItemNames = prefs.getStringList('inventoryItems');
    Inventory inventory = Inventory();
    if (inventoryItemNames != null) {
      inventory.items = inventoryItemNames.map((name) {
        if (name.isEmpty) {
          return null;
        } else {
          return allItems.firstWhere((item) => item.name == name,
              orElse: () => emptyItem);
        }
      }).toList();
    }

    return Character(
      playerName: playerName,
      race: race,
      characterClass: characterClass,
      imagePath: imagePath,
      level: level,
      xp: xp,
      maxXp: maxXp,
      health: health,
      maxHealth: maxHealth,
      magicBar: magicBar,
      gold: gold,
      luckCards: luckCards,
      resetCards: resetCards,
      healthPot: healthPot,
      manaPot: manaPot,
      daily: daily,
      dailyController: dailyController,
      skillPoints: skillPoints,
      hizPoints: hizPoints,
      katalen: katalen,
      kristalKalp: kristalKalp,
      organikParcalar: organikParcalar,
      bosSise: bosSise,
      productController: productController,
      defeatedEnemies: defeatedEnemies,
      criticalChoice: criticalChoice,
      totalChoice: totalChoice,
      purchasedItem: purchasedItem,
      totalDamageToEnemies: totalDamageToEnemies,
      entryShop: entryShop,
      totalEarnedXP: totalEarnedXP,
      usesLuckCards: usesLuckCards,
      spentMoney: spentMoney,
      totalSkillPoints: totalSkillPoints,
      totalHizPoints: totalHizPoints,
      firstEntryGamePage: firstEntryGamePage,
      firstEntryStatusPage: firstEntryStatusPage,
      firstEntryMarketPage: firstEntryMarketPage,
      firstEntryShopPage: firstEntryShopPage,
      firstEntryWarPage: firstEntryWarPage,
      firstEntryDailyPage: firstEntryDailyPage,
      firstEntryProductionPage: firstEntryProductionPage,
      firstEntryUpgradePage: firstEntryUpgradePage,
      isReadyOpenInventory: isReadyOpenInventory,
      firstSkillLock: firstSkillLock,
      secondSkillLock: secondSkillLock,
      thirdSkillLock: thirdSkillLock,
      fourthSkillLock: fourthSkillLock,
      fifthSkillLock: fifthSkillLock,
      firstSkillCooldown: firstSkillCooldown,
      secondSkillCooldown: secondSkillCooldown,
      thirdSkillCooldown: thirdSkillCooldown,
      fourthSkillCooldown: fourthSkillCooldown,
      fifthSkillCooldown: fifthSkillCooldown,
      strengthPlus: strengthPlus,
      intelligencePlus: intelligencePlus,
      dexterityPlus: dexterityPlus,
      charismaPlus: charismaPlus,
      productEfficiency: productEfficiency,
      equippedItems: equippedItems,
      inventory: inventory,
    );
  }
}
