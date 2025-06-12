class Enemy {
  final String name;
  final String imagePath;
  final int level;
  int health;
  final int maxHealth;
  final int attackDamage;
  final String info;

  Enemy({
    required this.name,
    required this.imagePath,
    required this.level,
    required this.health,
    required this.maxHealth,
    required this.attackDamage,
    required this.info,
  });
}

final Enemy exampleEnemies = Enemy(
  name: 'Test Düşmanı',
  imagePath: 'assets/images/icons/others/carpi_isareti.png',
  level: 1,
  health: 1000,
  maxHealth: 1000,
  attackDamage: 50,
  info: 'Zayıf bir test düşmanı.',
);
final Enemy ciftBasliYilan = Enemy(
  name: 'Çift Başlı Yılan',
  imagePath: 'assets/images/icons/enemies/cift_basli_yilan.png',
  level: 1,
  health: 50,
  maxHealth: 50,
  attackDamage: 5,
  info: 'Liman içine sızmayı başarmış sinsi bir yozlaşmış yaratık.',
);

final Enemy example = Enemy(
  name: '',
  imagePath: '',
  level: 0,
  health: 0,
  maxHealth: 0,
  attackDamage: 0,
  info: '',
);

final List<Enemy> allEnemies = [
  exampleEnemies,
  ciftBasliYilan,
];
