enum SlotType {
  helmet, // ----------- 1. Slot
  armor, // ------------ 2. Slot
  gloves, // ----------- 3. Slot
  boots, // ------------ 4. Slot
  primaryWeapon, // ---- 5. Slot
  secondaryWeapon, // -- 6. Slot
  amulet, // ----------- 7. Slot
  none, // ------------- Kuşanılamayanlar
}

enum ItemType {
  // Birincil Silahlar
  axe,
  crossbow,
  staff,
  sword,
  bow,
  dagger,
  // İkincil Silahlar
  shield,
  knife,
  runic,
  // Zırhlar
  armor,
  helmet,
  gloves,
  boots,
  // Tılsımlar
  amulet,
  // Kuşanılamayan Eşyalar ve Diğerleri
  chests,
  scrolls,
  others,
}

enum ItemRarity {
  common, // ----- 1. Seviye Yaygın
  rare, // ------- 2. Seviye Nadir
  epic, // ------- 3. Seviye Epik
  legendary, // -- 4. Seviye Efsanevi
  mystic, // ----- 5. Seviye Mistik
}

class Item {
  final bool isUsed; // --------------------------- Kullanılma Durumu
  final int itemId; // ---------------------------- Özel ID'si
  final String name; // --------------------------- İsmi
  final int level; // ----------------------------- Seviyesi
  final ItemRarity rarity; // --------------------- Nadirliği
  final String imagePath; // ---------------------- Görsel Bağlantısı
  final String description; // -------------------- Açıklaması
  final SlotType slotType; // --------------------- Slot Tipi
  final ItemType itemType; // --------------------- Eşya Tipi
  final bool boundToPlayer; // -------------------- Kişiye Özel Olma Durumu
  final int price; // ----------------------------- Fiyatı
  final int sellBackPercentage; // ---------------- İade Fiyatı
  final bool canUpgrade; // ----------------------- Yükseltilebilme Durumu
  final List<int> upgradeRequirements; // --------- Yükseltme Malzemeleri (1-5)
  final int requiredLevel; // --------------------- Seviye Gereksinimi
  final bool isPartOfSet; // ---------------------- Sete Dahillik Durumu
  final String setName; // ------------------------ Set İsmi
  final int attackPoint; // ----------------------- Saldırı Değeri (AP)
  final int defensePoint; // ---------------------- Savunma Değeri (DP)
  final int strengthPoint; // --------------------- Güç Değeri (STR)
  final int intelligencePoint; // ----------------- Zeka Değeri (INT)
  final int dexterityPoint; // -------------------- Beceri Değeri (DEX)
  final int charismaPoint; // --------------------- Karizma Değeri (CHAR)
  final int durability; // ------------------------ Dayanıklılığı
  final int maxDurability; // --------------------- Maksimum Dayanıklılığı

  // Varsayılan değerler korunduğu sürece itemlerin özel kodlarına bu
  // başlıklarla alakalı bir giriş yapılmasına gerek yoktur.
  Item({
    required this.isUsed,
    required this.itemId,
    required this.name,
    required this.level,
    required this.rarity,
    required this.imagePath,
    this.description = "", // Varsayılan Açıklama
    required this.slotType,
    required this.itemType,
    this.boundToPlayer = false, // Varsayılan Karaktere Özel Olma Durumu
    this.price = 0, // Varsayılan Fiyat
    this.sellBackPercentage = 50, // Varsayılan İade Değeri; Fiyatın %50'si
    this.canUpgrade = false, // Varsayılan Yükseltilebilme Durumu
    this.upgradeRequirements = const [0, 0, 0, 0, 0],
    this.requiredLevel = 0, // Varsayılan Seviye Gereksinimi
    this.isPartOfSet = false, // Varsayılan Sete Dahillik Durumu
    this.setName = "", // Varsayılan Set İsmi
    this.attackPoint = 0, // Varsayılan Saldırı Değeri
    this.defensePoint = 0, // Varsayılan Savunma Değeri
    this.strengthPoint = 0, // Varsayılan Güç Değeri
    this.intelligencePoint = 0, // Varsayılan Zeka Değeri
    this.dexterityPoint = 0, // Varsayılan Beceri Değeri
    this.charismaPoint = 0, // Varsayılan Karizma Değeri
    this.durability = 100, // Varsayılan Dayanıklılık
    this.maxDurability = 100, // Varsayılan Maksimum Dayanıklılık
  });

  // İade fiyatını yüzdesel olarak hesaplıyor.
  // Burada girilen yüzde değeri 0 ise iade fiyatı sıfır olur,
  // 100 ise iade fiyatı ile fiyat aynı olur.
  int get sellBackPrice =>
      boundToPlayer ? 0 : (price * sellBackPercentage ~/ 100);

  // Dayanıklılık yüzdesini alma kodu burada hesaplanıyor.
  double get durabilityPercent =>
      maxDurability == 0 ? 0 : (durability / maxDurability) * 100;
}

// Temel Item Kodu ve Boş Item
final Item emptyItem = Item(
  isUsed: false,
  itemId: 100000000,
  name: "Empty (Boş) Eşya",
  level: 0,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/others/carpi_isareti.png",
  description: "",
  slotType: SlotType.none,
  itemType: ItemType.others,
  boundToPlayer: true,
  price: 0,
  sellBackPercentage: 0,
  canUpgrade: false,
  upgradeRequirements: [0, 0, 0, 0, 0],
  requiredLevel: 0,
  isPartOfSet: false,
  setName: "",
  attackPoint: 0,
  defensePoint: 0,
  strengthPoint: 0,
  intelligencePoint: 0,
  dexterityPoint: 0,
  charismaPoint: 0,
  durability: 0,
  maxDurability: 0,
);

// Başlangıç Ekipmanları
final Item firstKilic = Item(
  isUsed: true,
  itemId: 105040001,
  name: "Maceracının Kılıcı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/swords/sword_lv11.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.sword,
  boundToPlayer: true,
  attackPoint: 5,
);
final Item firstYay = Item(
  isUsed: true,
  itemId: 105050001,
  name: "Maceracının Yayı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/bows/bow_lv11.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.bow,
  boundToPlayer: true,
  attackPoint: 5,
);
final Item firstHancer = Item(
  isUsed: true,
  itemId: 105060001,
  name: "Maceracının Hançeri",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/daggers/dagger_lv11.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.dagger,
  boundToPlayer: true,
  attackPoint: 5,
);
final Item firstHelmet = Item(
  isUsed: true,
  itemId: 101010001,
  name: "Maceracının Miğferi",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/helmets/helmet_lv11.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  defensePoint: 2,
  strengthPoint: 2,
  intelligencePoint: 2,
  dexterityPoint: 2,
  charismaPoint: 2,
);
final Item firstArmor = Item(
  isUsed: true,
  itemId: 102010001,
  name: "Maceracının Zırhı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/armors/armor_lv11.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  defensePoint: 5,
);
final Item gizemliEldiven = Item(
  isUsed: true,
  itemId: 103010001,
  name: "Gizemli Eldiven",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/gloves/glove_lv12.png",
  slotType: SlotType.gloves,
  itemType: ItemType.gloves,
  defensePoint: 5,
  strengthPoint: 7,
  intelligencePoint: 7,
  dexterityPoint: 7,
  charismaPoint: 7,
);
final Item kayaliklardakiSandik = Item(
  isUsed: true,
  itemId: 108000001,
  name: "Kayalıklardaki Sandık",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/chests/chest_1.png",
  slotType: SlotType.none,
  itemType: ItemType.chests,
  boundToPlayer: true,
);
final Item maceraCagrisi = Item(
  isUsed: true,
  itemId: 108000002,
  name: "Macera Çağrısı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/scrolls/scroll_1.png",
  description: "Yüce Irkların Yüce Maceracıları,\n\n"
      "Mocartim Adası’ndan yayılan bir kötülük dalgası, tüm diyarları tehdit "
      "etmekte. Geçmişten bu yana adanın dört bir yanını saran ve genişlemesi "
      "önemli ölçüde azaltılmış olan lanetli büyü, son zamanlarda güçlenmeye "
      "ve yayılma hızında bir artış görülmeye başlandı. Bu lanet sadece "
      "Mocartim Adası’nı değil, tüm diyarlar için çok büyük bir tehdit "
      "oluşturmakta. Lanetin kaynağı tam bilinmemekle beraber, yayılan laneti "
      "kilitli tutan şeyin adanın derinliklerinde kayıp olduğunu düşündüğümüz "
      "bir mühür yada benzeri bir şey. Bu mühür yada her neyse biri yada bir "
      "şeyler tarafından kaldırılmak istenildiğini düşünmekteyiz.\n\n"
      "Bu mektup, cesareti ve adaletiyle ün kazanmış siz maceracılara bir "
      "çağrıdır. Mocartim Adası’nın tehlikelerine karşı göğüs gerecek, mührün "
      "sırrını çözmek yada mührü kaldırmaya çalışanları emellerinden edecek "
      "her adımı atacak bir güce ihtiyaç vardır. Eğer bu kutsal görevi "
      "üstlenirseniz, bilmelisiniz ki karşınıza çıkacak zorluklar benzersiz "
      "olacaktır. Fakat başarırsanız, tüm diyarları bu illet kötülükten "
      "kurtaracak ve çok büyük ödüller kazanacaksınız. Kılıcınız keskin, "
      "büyünüz güçlü, yolunuz aydınlık olsun. Bu zorlu görevi kabul eden "
      "herkes, ırkların onuruna nail olacak ve tüm diyarları koruma adına "
      "başlanan bu büyük yolculukta yerini alacaktır.\n\n"
      "Maceracılar Loncası",
  slotType: SlotType.none,
  itemType: ItemType.scrolls,
  boundToPlayer: true,
);

// Gizemli Market Reklam Ödülleri
final Item odulBalta = Item(
  isUsed: true,
  itemId: 105010001,
  name: "Kaderin Baltası",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/axes/axe_lv14.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.axe,
  attackPoint: 75,
);
final Item odulArbalet = Item(
  isUsed: true,
  itemId: 105020001,
  name: "Kaderin Arbaleti",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/crossbows/crossbow_lv14.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.crossbow,
  attackPoint: 75,
);
final Item odulAsa = Item(
  isUsed: true,
  itemId: 105030001,
  name: "Kaderin Asası",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/staffs/staff_lv14.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.staff,
  attackPoint: 75,
);
final Item odulKalkan = Item(
  isUsed: true,
  itemId: 106010001,
  name: "Kaderin Kalkanı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/shields/shield_lv14.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.shield,
  defensePoint: 15,
  strengthPoint: 20,
  intelligencePoint: 20,
  dexterityPoint: 20,
  charismaPoint: 20,
);
final Item odulBicak = Item(
  isUsed: true,
  itemId: 106020001,
  name: "Kaderin Bıçağı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/knifes/knife_lv14.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.knife,
  attackPoint: 30,
  strengthPoint: 10,
  intelligencePoint: 10,
  dexterityPoint: 10,
  charismaPoint: 10,
);
final Item odulRunik = Item(
  isUsed: true,
  itemId: 106030001,
  name: "Kaderin Rüniği",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/runics/runic_lv14.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.runic,
  attackPoint: 20,
  strengthPoint: 10,
  intelligencePoint: 20,
  dexterityPoint: 10,
  charismaPoint: 10,
);
final Item randomOdulMigferTier1 = Item(
  isUsed: true,
  itemId: 101010002,
  name: "Şansın Miğferi",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/helmets/helmet_lv13.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  defensePoint: 10,
  strengthPoint: 20,
  intelligencePoint: 20,
  dexterityPoint: 20,
  charismaPoint: 20,
);
final Item randomOdulZirhTier1 = Item(
  isUsed: true,
  itemId: 102010002,
  name: "Şansın Zırhı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/armors/armor_lv13.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  defensePoint: 25,
);
final Item randomOdulEldivenTier1 = Item(
  isUsed: true,
  itemId: 103010002,
  name: "Şansın Eldiveni",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/gloves/glove_lv13.png",
  slotType: SlotType.gloves,
  itemType: ItemType.gloves,
  defensePoint: 6,
  strengthPoint: 15,
  intelligencePoint: 15,
  dexterityPoint: 15,
  charismaPoint: 15,
);
final Item randomOdulAyakkabiTier1 = Item(
  isUsed: true,
  itemId: 104010001,
  name: "Şansın Ayakkabısı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/boots/boot_lv13.png",
  slotType: SlotType.boots,
  itemType: ItemType.boots,
  defensePoint: 6,
  strengthPoint: 15,
  intelligencePoint: 15,
  dexterityPoint: 15,
  charismaPoint: 15,
);
final Item odulZirh = Item(
  isUsed: true,
  itemId: 102010003,
  name: "Kaderin Saf Zırhı",
  level: 5,
  rarity: ItemRarity.mystic,
  imagePath: "assets/images/icons/items/armors/armor_lv25.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  defensePoint: 35,
);
final Item odulTilsimTier1 = Item(
  isUsed: true,
  itemId: 107050001,
  name: "Şansın Tılsımı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/amulets/amulet_13.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  strengthPoint: 40,
  intelligencePoint: 40,
  dexterityPoint: 40,
  charismaPoint: 40,
);
final Item odulTilsimTier2 = Item(
  isUsed: true,
  itemId: 107050002,
  name: "Kaderin Tılsımı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/amulets/amulet_24.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  strengthPoint: 50,
  intelligencePoint: 50,
  dexterityPoint: 50,
  charismaPoint: 50,
);

// Dikkat Çekmeyen Dükkan Eşyaları
final Item t1ShopSword1 = Item(
  isUsed: true,
  itemId: 105040002,
  name: "Paslı Kılıç",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/swords/sword_lv21.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.sword,
  price: 29,
  attackPoint: 7,
);
final Item t1ShopSword2 = Item(
  isUsed: true,
  itemId: 105040003,
  name: "Çentikli Kılıç",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/swords/sword_lv31.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.sword,
  price: 46,
  attackPoint: 13,
);
final Item t1ShopSword3 = Item(
  isUsed: true,
  itemId: 105040004,
  name: "Geniş Kılıç",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/swords/sword_lv12.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.sword,
  price: 72,
  attackPoint: 21,
);
final Item t1ShopBow1 = Item(
  isUsed: true,
  itemId: 105050002,
  name: "Eskimiş Yay",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/bows/bow_lv21.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.bow,
  price: 35,
  attackPoint: 9,
);
final Item t1ShopBow2 = Item(
  isUsed: true,
  itemId: 105050003,
  name: "Gergin Yay",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/bows/bow_lv31.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.bow,
  price: 48,
  attackPoint: 13,
);
final Item t1ShopBow3 = Item(
  isUsed: true,
  itemId: 105050004,
  name: "Akçaağaç Yay",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/bows/bow_lv12.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.bow,
  price: 79,
  attackPoint: 25,
);
final Item t1ShopDagger1 = Item(
  isUsed: true,
  itemId: 105060002,
  name: "Paslı Hançer",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/daggers/dagger_lv21.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.dagger,
  price: 33,
  attackPoint: 8,
);
final Item t1ShopDagger2 = Item(
  isUsed: true,
  itemId: 105060003,
  name: "Geleneksel Hançer",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/daggers/dagger_lv31.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.dagger,
  price: 52,
  attackPoint: 14,
);
final Item t1ShopDagger3 = Item(
  isUsed: true,
  itemId: 105060004,
  name: "Hafif Hançer",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/daggers/dagger_lv12.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.dagger,
  price: 83,
  attackPoint: 24,
);
final Item t1ShopAxe = Item(
  isUsed: true,
  itemId: 105010002,
  name: "Eğri Balta",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/axes/axe_lv11.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.axe,
  price: 89,
  attackPoint: 25,
);
final Item t1ShopCrossbow = Item(
  isUsed: true,
  itemId: 105020002,
  name: "Kanatsız Arbalet",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/crossbows/crossbow_lv11.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.crossbow,
  price: 72,
  attackPoint: 21,
);
final Item t1ShopStaff = Item(
  isUsed: true,
  itemId: 105030002,
  name: "Solgun Asa",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/staffs/staff_lv11.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.staff,
  price: 78,
  attackPoint: 22,
);
final Item t1ShopHelmet1 = Item(
  isUsed: true,
  itemId: 101010003,
  name: "Kırılmış Miğfer",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/helmets/helmet_lv21.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  price: 35,
  defensePoint: 4,
  strengthPoint: 3,
  intelligencePoint: 3,
  dexterityPoint: 3,
  charismaPoint: 3,
);
final Item t1ShopHelmet2 = Item(
  isUsed: true,
  itemId: 101010004,
  name: "Deri Miğfer",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/helmets/helmet_lv31.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  price: 52,
  defensePoint: 7,
  strengthPoint: 10,
  intelligencePoint: 10,
  dexterityPoint: 10,
  charismaPoint: 10,
);
final Item t1ShopHelmet3 = Item(
  isUsed: true,
  itemId: 101010005,
  name: "Kedi Miğfer",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/helmets/helmet_lv12.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  price: 64,
  defensePoint: 6,
  strengthPoint: 15,
  intelligencePoint: 15,
  dexterityPoint: 15,
  charismaPoint: 15,
);
final Item t1ShopArmor1 = Item(
  isUsed: true,
  itemId: 102010004,
  name: "Yıpranmış Zırh",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/armors/armor_lv21.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 56,
  defensePoint: 8,
);
final Item t1ShopArmor2 = Item(
  isUsed: true,
  itemId: 102010005,
  name: "Deri Zırh",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/armors/armor_lv31.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 74,
  defensePoint: 11,
);
final Item t1ShopArmor3 = Item(
  isUsed: true,
  itemId: 102010006,
  name: "Sert Zırh",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/armors/armor_lv12.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 82,
  defensePoint: 15,
);
final Item t1ShopBoot1 = Item(
  isUsed: true,
  itemId: 104010002,
  name: "Keçesiz Ayakkabı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/boots/boot_lv11.png",
  slotType: SlotType.boots,
  itemType: ItemType.boots,
  price: 16,
  defensePoint: 2,
  strengthPoint: 3,
  intelligencePoint: 3,
  dexterityPoint: 3,
  charismaPoint: 3,
);
final Item t1ShopBoot2 = Item(
  isUsed: true,
  itemId: 104010003,
  name: "Kullanılmış Ayakkabı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/boots/boot_lv21.png",
  slotType: SlotType.boots,
  itemType: ItemType.boots,
  price: 19,
  defensePoint: 3,
  strengthPoint: 4,
  intelligencePoint: 4,
  dexterityPoint: 4,
  charismaPoint: 4,
);
final Item t1ShopBoot3 = Item(
  isUsed: true,
  itemId: 104010004,
  name: "Deri Ayakkabı",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/boots/boot_lv32.png",
  slotType: SlotType.boots,
  itemType: ItemType.boots,
  price: 32,
  defensePoint: 5,
  strengthPoint: 6,
  intelligencePoint: 6,
  dexterityPoint: 6,
  charismaPoint: 6,
);
final Item t1ShopAmulet = Item(
  isUsed: true,
  itemId: 107050003,
  name: "Saflığın Tılsımı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/amulets/amulet_23.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 102,
  strengthPoint: 40,
  intelligencePoint: 40,
  dexterityPoint: 40,
  charismaPoint: 40,
);

// Normal Görünen Dükkan Eşyaları
final Item t2ShopSword1 = Item(
  isUsed: true,
  itemId: 105040005,
  name: "Tersyüz Kılıcı",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/swords/sword_lv22.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.sword,
  price: 74,
  attackPoint: 23,
);
final Item t2ShopBow1 = Item(
  isUsed: true,
  itemId: 105050005,
  name: "Dikenli Yay",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/bows/bow_lv22.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.bow,
  price: 71,
  attackPoint: 20,
);
final Item t2ShopDagger1 = Item(
  isUsed: true,
  itemId: 105060005,
  name: "Parlak Hançer",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/daggers/dagger_lv22.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.dagger,
  price: 86,
  attackPoint: 26,
);
final Item t2ShopSword2 = Item(
  isUsed: true,
  itemId: 105040006,
  name: "İşlemeli Kılıç",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/swords/sword_lv13.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.sword,
  price: 122,
  attackPoint: 34,
);
final Item t2ShopBow2 = Item(
  isUsed: true,
  itemId: 105050006,
  name: "İşlemeli Yay",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/bows/bow_lv13.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.bow,
  price: 130,
  attackPoint: 37,
);
final Item t2ShopDagger2 = Item(
  isUsed: true,
  itemId: 105060006,
  name: "İşlemeli Hançer",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/daggers/dagger_lv13.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.dagger,
  price: 110,
  attackPoint: 32,
);
final Item t2ShopShield1 = Item(
  isUsed: true,
  itemId: 106010002,
  name: "Paslı Kalkan",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/shields/shield_lv11.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.shield,
  price: 17,
  defensePoint: 2,
  strengthPoint: 2,
  intelligencePoint: 2,
  dexterityPoint: 2,
  charismaPoint: 2,
);
final Item t2ShopKnife1 = Item(
  isUsed: true,
  itemId: 106020002,
  name: "Kör Bıçak",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/knifes/knife_lv11.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.knife,
  price: 22,
  attackPoint: 6,
  strengthPoint: 3,
  intelligencePoint: 3,
  dexterityPoint: 3,
  charismaPoint: 3,
);
final Item t2ShopRunic1 = Item(
  isUsed: true,
  itemId: 106030002,
  name: "Çatlamış Rünik",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/runics/runic_lv11.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.runic,
  price: 26,
  attackPoint: 5,
  strengthPoint: 2,
  intelligencePoint: 6,
  dexterityPoint: 2,
  charismaPoint: 2,
);
final Item t2ShopShield2 = Item(
  isUsed: true,
  itemId: 106010003,
  name: "Sert Kalkan",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/shields/shield_lv22.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.shield,
  price: 32,
  defensePoint: 7,
  strengthPoint: 4,
  intelligencePoint: 4,
  dexterityPoint: 4,
  charismaPoint: 4,
);
final Item t2ShopKnife2 = Item(
  isUsed: true,
  itemId: 106020003,
  name: "Kısa Bıçak",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/knifes/knife_lv22.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.knife,
  price: 45,
  attackPoint: 14,
  strengthPoint: 4,
  intelligencePoint: 4,
  dexterityPoint: 4,
  charismaPoint: 4,
);
final Item t2ShopRunic2 = Item(
  isUsed: true,
  itemId: 106030003,
  name: "Solgun Rünik",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/runics/runic_lv22.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.runic,
  price: 47,
  attackPoint: 9,
  strengthPoint: 4,
  intelligencePoint: 11,
  dexterityPoint: 4,
  charismaPoint: 4,
);
final Item t2ShopArmor1 = Item(
  isUsed: true,
  itemId: 102010007,
  name: "Tabaklanmış Zırh",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/armors/armor_lv22.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 88,
  defensePoint: 16,
);
final Item t2ShopArmor2 = Item(
  isUsed: true,
  itemId: 102010008,
  name: "Zincirli Zırh",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/armors/armor_lv32.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 93,
  defensePoint: 18,
);
final Item t2ShopArmor3 = Item(
  isUsed: true,
  itemId: 102010009,
  name: "Kara Zırh",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/armors/armor_lv42.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 101,
  defensePoint: 19,
);
final Item t2ShopHelmet1 = Item(
  isUsed: true,
  itemId: 101010006,
  name: "Kare Miğfer",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/helmets/helmet_lv22.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  price: 36,
  defensePoint: 6,
  strengthPoint: 14,
  intelligencePoint: 14,
  dexterityPoint: 14,
  charismaPoint: 14,
);
final Item t2ShopArmor4 = Item(
  isUsed: true,
  itemId: 102010010,
  name: "Kapkara Zırh",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/armors/armor_lv53.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 107,
  defensePoint: 20,
);
final Item t2ShopHelmet2 = Item(
  isUsed: true,
  itemId: 101010007,
  name: "Hafif Miğfer",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/helmets/helmet_lv32.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  price: 42,
  defensePoint: 8,
  strengthPoint: 11,
  intelligencePoint: 11,
  dexterityPoint: 11,
  charismaPoint: 11,
);
final Item t2ShopGlove1 = Item(
  isUsed: true,
  itemId: 103010003,
  name: "Çaput Eldiven",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/gloves/glove_lv11.png",
  slotType: SlotType.gloves,
  itemType: ItemType.gloves,
  price: 21,
  defensePoint: 2,
  strengthPoint: 5,
  intelligencePoint: 5,
  dexterityPoint: 5,
  charismaPoint: 5,
);
final Item t2ShopBoot1 = Item(
  isUsed: true,
  itemId: 104010005,
  name: "Çaput Ayakkabı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/boots/boot_lv31.png",
  slotType: SlotType.boots,
  itemType: ItemType.boots,
  price: 20,
  defensePoint: 2,
  strengthPoint: 4,
  intelligencePoint: 4,
  dexterityPoint: 4,
  charismaPoint: 4,
);
final Item t2ShopAmulet1 = Item(
  isUsed: true,
  itemId: 107050004,
  name: "Efsunun Tılsımı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/amulets/amulet_93.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 193,
  strengthPoint: 40,
  intelligencePoint: 40,
  dexterityPoint: 40,
  charismaPoint: 40,
);
final Item t2ShopAmulet2 = Item(
  isUsed: true,
  itemId: 107010001,
  name: "Aşınmış Güç Tılsımı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/amulets/amulet_11.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 52,
  strengthPoint: 11,
  intelligencePoint: 3,
  dexterityPoint: 3,
  charismaPoint: 3,
);
final Item t2ShopAmulet3 = Item(
  isUsed: true,
  itemId: 107020001,
  name: "Aşınmış Zeka Tılsımı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/amulets/amulet_21.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 53,
  strengthPoint: 3,
  intelligencePoint: 12,
  dexterityPoint: 3,
  charismaPoint: 3,
);
final Item t2ShopAmulet4 = Item(
  isUsed: true,
  itemId: 107030001,
  name: "Aşınmış Beceri Tılsımı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/amulets/amulet_31.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 50,
  strengthPoint: 3,
  intelligencePoint: 3,
  dexterityPoint: 9,
  charismaPoint: 3,
);
final Item t2ShopAmulet5 = Item(
  isUsed: true,
  itemId: 107040001,
  name: "Aşınmış Karizma Tılsımı",
  level: 1,
  rarity: ItemRarity.common,
  imagePath: "assets/images/icons/items/amulets/amulet_41.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 51,
  strengthPoint: 3,
  intelligencePoint: 3,
  dexterityPoint: 3,
  charismaPoint: 10,
);
final Item t2ShopAmulet6 = Item(
  isUsed: true,
  itemId: 107010002,
  name: "Loş Güç Tılsımı",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/amulets/amulet_52.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 95,
  strengthPoint: 18,
  intelligencePoint: 5,
  dexterityPoint: 5,
  charismaPoint: 5,
);
final Item t2ShopAmulet7 = Item(
  isUsed: true,
  itemId: 107020002,
  name: "Loş Zeka Tılsımı",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/amulets/amulet_62.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 97,
  strengthPoint: 5,
  intelligencePoint: 20,
  dexterityPoint: 5,
  charismaPoint: 5,
);
final Item t2ShopAmulet8 = Item(
  isUsed: true,
  itemId: 107030002,
  name: "Loş Beceri Tılsımı",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/amulets/amulet_72.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 98,
  strengthPoint: 5,
  intelligencePoint: 5,
  dexterityPoint: 21,
  charismaPoint: 5,
);
final Item t2ShopAmulet9 = Item(
  isUsed: true,
  itemId: 107040002,
  name: "Loş Karizma Tılsımı",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/amulets/amulet_82.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 96,
  strengthPoint: 5,
  intelligencePoint: 5,
  dexterityPoint: 5,
  charismaPoint: 19,
);

// Lüks Görünen Dükkan Eşyaları
final Item t3ShopSword = Item(
  isUsed: true,
  itemId: 105040007,
  name: "Oymalı Kılıç",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/swords/sword_lv32.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.sword,
  price: 76,
  attackPoint: 24,
);
final Item t3ShopBow = Item(
  isUsed: true,
  itemId: 105050007,
  name: "Çentik Yay",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/bows/bow_lv32.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.bow,
  price: 72,
  attackPoint: 22,
);
final Item t3ShopDagger = Item(
  isUsed: true,
  itemId: 105060007,
  name: "Çınlayan Hançer",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/daggers/dagger_lv32.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.dagger,
  price: 74,
  attackPoint: 23,
);
final Item t3ShopAxe1 = Item(
  isUsed: true,
  itemId: 105010003,
  name: "Kandöken Baltası",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/axes/axe_lv13.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.axe,
  price: 142,
  attackPoint: 40,
);
final Item t3ShopCrossbow1 = Item(
  isUsed: true,
  itemId: 105020003,
  name: "Kanatlı Arbalet",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/crossbows/crossbow_lv13.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.crossbow,
  price: 148,
  attackPoint: 41,
);
final Item t3ShopStaff1 = Item(
  isUsed: true,
  itemId: 105030003,
  name: "Parlayan Asa",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/staffs/staff_lv13.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.staff,
  price: 150,
  attackPoint: 44,
);
final Item t3ShopAxe2 = Item(
  isUsed: true,
  itemId: 105010004,
  name: "Kutsal Balta",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/axes/axe_lv24.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.axe,
  price: 186,
  attackPoint: 67,
);
final Item t3ShopCrossbow2 = Item(
  isUsed: true,
  itemId: 105020004,
  name: "Kutsal Arbalet",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/crossbows/crossbow_lv24.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.crossbow,
  price: 182,
  attackPoint: 64,
);
final Item t3ShopStaff2 = Item(
  isUsed: true,
  itemId: 105030004,
  name: "Kutsal Asa",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/staffs/staff_lv24.png",
  slotType: SlotType.primaryWeapon,
  itemType: ItemType.staff,
  price: 180,
  attackPoint: 63,
);
final Item t3ShopShield1 = Item(
  isUsed: true,
  itemId: 106010004,
  name: "Çelik Kalkan",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/shields/shield_lv12.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.shield,
  price: 40,
  defensePoint: 6,
  strengthPoint: 10,
  intelligencePoint: 10,
  dexterityPoint: 10,
  charismaPoint: 10,
);
final Item t3ShopKnife1 = Item(
  isUsed: true,
  itemId: 106020004,
  name: "Hayalet Bıçak",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/knifes/knife_lv12.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.knife,
  price: 41,
  attackPoint: 17,
  strengthPoint: 1,
  intelligencePoint: 1,
  dexterityPoint: 1,
  charismaPoint: 1,
);
final Item t3ShopRunic1 = Item(
  isUsed: true,
  itemId: 106030004,
  name: "Elemental Rünik",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/runics/runic_lv12.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.runic,
  price: 44,
  attackPoint: 9,
  strengthPoint: 5,
  intelligencePoint: 13,
  dexterityPoint: 5,
  charismaPoint: 5,
);
final Item t3ShopShield2 = Item(
  isUsed: true,
  itemId: 106010005,
  name: "Kutsal Kalkan",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/shields/shield_lv23.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.shield,
  price: 69,
  defensePoint: 10,
  strengthPoint: 15,
  intelligencePoint: 15,
  dexterityPoint: 15,
  charismaPoint: 15,
);
final Item t3ShopKnife2 = Item(
  isUsed: true,
  itemId: 106020005,
  name: "Kutsal Bıçak",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/knifes/knife_lv23.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.knife,
  price: 72,
  attackPoint: 19,
  strengthPoint: 6,
  intelligencePoint: 6,
  dexterityPoint: 6,
  charismaPoint: 6,
);
final Item t3ShopRunic2 = Item(
  isUsed: true,
  itemId: 106030005,
  name: "Kutsal Rünik",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/runics/runic_lv23.png",
  slotType: SlotType.secondaryWeapon,
  itemType: ItemType.runic,
  price: 73,
  attackPoint: 12,
  strengthPoint: 6,
  intelligencePoint: 16,
  dexterityPoint: 6,
  charismaPoint: 6,
);
final Item t3ShopArmor1 = Item(
  isUsed: true,
  itemId: 102010011,
  name: "Onur Zırhı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/armors/armor_lv23.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 141,
  defensePoint: 22,
);
final Item t3ShopHelmet1 = Item(
  isUsed: true,
  itemId: 101010008,
  name: "Bronz Miğfer",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/helmets/helmet_lv23.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  price: 55,
  defensePoint: 8,
  strengthPoint: 17,
  intelligencePoint: 17,
  dexterityPoint: 17,
  charismaPoint: 17,
);
final Item t3ShopHelmet2 = Item(
  isUsed: true,
  itemId: 101010009,
  name: "Pirinç Miğfer",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/helmets/helmet_lv14.png",
  slotType: SlotType.helmet,
  itemType: ItemType.helmet,
  price: 83,
  defensePoint: 10,
  strengthPoint: 21,
  intelligencePoint: 21,
  dexterityPoint: 21,
  charismaPoint: 21,
);
final Item t3ShopArmor2 = Item(
  isUsed: true,
  itemId: 102010012,
  name: "Cesaret Zırhı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/armors/armor_lv14.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 162,
  defensePoint: 26,
);
final Item t3ShopGlove1 = Item(
  isUsed: true,
  itemId: 103010004,
  name: "Sertkopça Eldiveni",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/gloves/glove_lv23.png",
  slotType: SlotType.gloves,
  itemType: ItemType.gloves,
  price: 44,
  defensePoint: 5,
  strengthPoint: 13,
  intelligencePoint: 13,
  dexterityPoint: 13,
  charismaPoint: 13,
);
final Item t3ShopGlove2 = Item(
  isUsed: true,
  itemId: 103010005,
  name: "Zincir Eldiven",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/gloves/glove_lv14.png",
  slotType: SlotType.gloves,
  itemType: ItemType.gloves,
  price: 63,
  defensePoint: 7,
  strengthPoint: 15,
  intelligencePoint: 15,
  dexterityPoint: 15,
  charismaPoint: 15,
);
final Item t3ShopArmor3 = Item(
  isUsed: true,
  itemId: 102010013,
  name: "Soylu Zırhı",
  level: 5,
  rarity: ItemRarity.mystic,
  imagePath: "assets/images/icons/items/armors/armor_lv35.png",
  slotType: SlotType.armor,
  itemType: ItemType.armor,
  price: 224,
  defensePoint: 32,
);
final Item t3ShopBoot1 = Item(
  isUsed: true,
  itemId: 104010006,
  name: "Sivriuç Ayakkabı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/boots/boot_lv23.png",
  slotType: SlotType.boots,
  itemType: ItemType.boots,
  price: 39,
  defensePoint: 4,
  strengthPoint: 14,
  intelligencePoint: 14,
  dexterityPoint: 14,
  charismaPoint: 14,
);
final Item t3ShopBoot2 = Item(
  isUsed: true,
  itemId: 104010007,
  name: "Pullu Ayakkabı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/boots/boot_lv14.png",
  slotType: SlotType.boots,
  itemType: ItemType.boots,
  price: 61,
  defensePoint: 6,
  strengthPoint: 17,
  intelligencePoint: 17,
  dexterityPoint: 17,
  charismaPoint: 17,
);
final Item t3ShopAmulet1 = Item(
  isUsed: true,
  itemId: 107010003,
  name: "Kara Güç Tılsımı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/amulets/amulet_33.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 147,
  strengthPoint: 30,
  intelligencePoint: 8,
  dexterityPoint: 8,
  charismaPoint: 8,
);
final Item t3ShopAmulet2 = Item(
  isUsed: true,
  itemId: 107020003,
  name: "Kara Zeka Tılsımı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/amulets/amulet_43.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 146,
  strengthPoint: 8,
  intelligencePoint: 29,
  dexterityPoint: 8,
  charismaPoint: 8,
);
final Item t3ShopAmulet3 = Item(
  isUsed: true,
  itemId: 107030003,
  name: "Kara Beceri Tılsımı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/amulets/amulet_53.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 145,
  strengthPoint: 8,
  intelligencePoint: 8,
  dexterityPoint: 28,
  charismaPoint: 8,
);
final Item t3ShopAmulet4 = Item(
  isUsed: true,
  itemId: 107040003,
  name: "Kara Karizma Tılsımı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/amulets/amulet_63.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 149,
  strengthPoint: 8,
  intelligencePoint: 8,
  dexterityPoint: 8,
  charismaPoint: 32,
);
final Item t3ShopAmulet5 = Item(
  isUsed: true,
  itemId: 107010004,
  name: "Antik Güç Tılsımı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/amulets/amulet_74.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 199,
  strengthPoint: 42,
  intelligencePoint: 13,
  dexterityPoint: 13,
  charismaPoint: 13,
);
final Item t3ShopAmulet6 = Item(
  isUsed: true,
  itemId: 107020004,
  name: "Antik Zeka Tılsımı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/amulets/amulet_84.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 195,
  strengthPoint: 13,
  intelligencePoint: 38,
  dexterityPoint: 13,
  charismaPoint: 13,
);
final Item t3ShopAmulet7 = Item(
  isUsed: true,
  itemId: 107030004,
  name: "Antik Beceri Tılsımı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/amulets/amulet_94.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 197,
  strengthPoint: 13,
  intelligencePoint: 13,
  dexterityPoint: 40,
  charismaPoint: 13,
);
final Item t3ShopAmulet8 = Item(
  isUsed: true,
  itemId: 107040004,
  name: "Antik Karizma Tılsımı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/amulets/amulet_104.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 196,
  strengthPoint: 13,
  intelligencePoint: 13,
  dexterityPoint: 13,
  charismaPoint: 39,
);
final Item t3ShopAmulet9 = Item(
  isUsed: true,
  itemId: 107050005,
  name: "Sevginin Tılsımı",
  level: 2,
  rarity: ItemRarity.rare,
  imagePath: "assets/images/icons/items/amulets/amulet_12.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 96,
  strengthPoint: 27,
  intelligencePoint: 27,
  dexterityPoint: 27,
  charismaPoint: 27,
);
final Item t3ShopAmulet10 = Item(
  isUsed: true,
  itemId: 107060001,
  name: "Tükenmiş Aura Tılsımı",
  level: 3,
  rarity: ItemRarity.epic,
  imagePath: "assets/images/icons/items/amulets/amulet_113.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 162,
  strengthPoint: 36,
  intelligencePoint: 36,
  dexterityPoint: 36,
  charismaPoint: 36,
);
final Item t3ShopAmulet11 = Item(
  isUsed: true,
  itemId: 107060002,
  name: "Som Aura Tılsımı",
  level: 4,
  rarity: ItemRarity.legendary,
  imagePath: "assets/images/icons/items/amulets/amulet_124.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 199,
  strengthPoint: 44,
  intelligencePoint: 44,
  dexterityPoint: 44,
  charismaPoint: 44,
);
final Item t3ShopAmulet12 = Item(
  isUsed: true,
  itemId: 107060003,
  name: "Eule Aura Tılsımı",
  level: 5,
  rarity: ItemRarity.mystic,
  imagePath: "assets/images/icons/items/amulets/amulet_25.png",
  slotType: SlotType.amulet,
  itemType: ItemType.amulet,
  price: 233,
  strengthPoint: 60,
  intelligencePoint: 60,
  dexterityPoint: 60,
  charismaPoint: 60,
);

// Son *KULLANILAN* Item ID'leri;
// Savunma Teçhizatları;
// (1) Miğfer -----------> 101010009
// (2) Zırh -------------> 102010013
// (3) Eldiven ----------> 103010005
// (4) Ayakkabı ---------> 104010007

// Birincil Silahlar;
// (5) Balta ------------> 105010004
// (5) Arbalet ----------> 105020004
// (5) Asa --------------> 105030004
// (5) Kılıç ------------> 105040007
// (5) Yay --------------> 105050007
// (5) Hançer -----------> 105060007

// İkincil Silahlar;
// (6) Kalkan -----------> 106010005
// (6) Bıçak ------------> 106020005
// (6) Runik ------------> 106030005

// Tılsımlar;
// (7) Güç Tılsımı ------> 107010004
// (7) Zeka Tılsımı -----> 107020004
// (7) Beceri Tılsımı ---> 107030004
// (7) Karizma Tılsımı --> 107040004
// (7) Genel Tılsımlar --> 107050005
// (7) Eule Tılsımları --> 107060003

// Tüm Item Listesi
final List<Item> allItems = [
  firstKilic,
  firstHancer,
  firstYay,
  firstArmor,
  firstHelmet,
  gizemliEldiven,
  kayaliklardakiSandik,
  maceraCagrisi,
  // --------------------------------------------------------------------------
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
  // --------------------------------------------------------------------------
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
  // --------------------------------------------------------------------------
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
  // --------------------------------------------------------------------------
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

class Inventory {
  List<Item?> items = List.generate(100, (index) => null);

  void addItem(Item item) {
    for (int i = 0; i < items.length; i++) {
      if (items[i] == null) {
        items[i] = item;
        break;
      }
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items[index] = null;
    }
  }
}
