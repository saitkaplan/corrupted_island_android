import 'package:corrupted_island_android/process_file/character_dao.dart';
import 'package:corrupted_island_android/process_file/object_items.dart';

class StoryChoice {
  final String displayText;
  final String nextNode;
  final bool Function(Character)? condition;

  StoryChoice({
    required this.displayText,
    required this.nextNode,
    this.condition,
  });
}

class StoryNode {
  final String description;
  final String? image;
  final List<StoryChoice> choices;

  StoryNode({
    required this.description,
    this.image,
    required this.choices,
  });
}

class StoryProgress {
  Map<String, StoryNode> storyNodes = {
    // Hızlı Olay 1
    "qo1": StoryNode(
      description:
          "Maceracı {karakter_adı} önemli bir çağrının peşinde Gisen Limanı'nda...",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Başla!",
          nextNode: "qo1-giriş1",
        ),
      ],
    ),
    "qo1-giriş1": StoryNode(
      description:
          "Bir sarsıntı seni uyandırıyor. Neler olduğunu öğrenmek için ceketini alıp güverteye çıkıyorsun ve görüyorsun ki limana gelmişsin. Güvertenin kenarına geçip limanı ve hafif bulutlu havayı seyrediyorsun. İleriye adanın derinliklerine doğru baktığında havada farklı bir bulut yapısı görüyorsun. Ada gerçekten de lanetli. Dikkati elden bırakmaman gerektiğini daha şimdiden anlıyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "!Test Alanı!",
          nextNode: "test-alanı",
          condition: (character) => character.playerName == "Saitskuruls",
        ),
        StoryChoice(
          displayText: "Kamarana dön...",
          nextNode: "qo1-giriş2",
        ),
      ],
    ),
    "qo1-giriş2": StoryNode(
      description:
          "Güvertedeki bir kaç çalışanın arasından geçip kamarana dönüyorsun. Ayrılmadan önce eşyalarını kontrol etmek istiyorsun ve yerde yatağının kenarında duran çantanı eline alıyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Çantanı kontrol et!",
          nextNode: "qo1-giriş3",
        ),
      ],
    ),
    "qo1-giriş3": StoryNode(
      description:
          "Eşyalarını kontrol ettikten sonra pılını pırtını toplayıp gemiden ayrılıyorsun. İskeleye indiğinde iskelenin az ilerisinde, iskelenin liman topraklarıyla buluştuğu noktada bir grup maceracının toplanmış olduğunu görüyorsun. Önemli bir şey olabilir diye düşünüyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Ne yaptıklarına bak...",
          nextNode: "qo1-iskele1",
        ),
      ],
    ),
    "qo1-iskele1": StoryNode(
      description:
          "Yaklaşıyorsun ve kalabalığın ortasında farklı giyinmiş birkaç insan görüyorsun. Bunlar Maceracı Loncasının görevlileri ve maceracılara adadaki durumlardan bahsediyorlar. Biraz kulak kesiliyorsun ve duyduğuna göre, adayı etkileyen lanet her geçen saat güçleniyor. Lonca maceracılarla beraber adanın bir kısmını fethetmiş, adadaki lanetin yayılmasını engelleyen ve zayıflamakta olduğu düşünülen mühür ise şuan kayıp. Görevli bu mührün acilen bulunması gerektiğini ve adaya gelen maceracıların ana görevinin bu olduğunu söylüyor. Bunları zaten biliyorsun, loncanın gönderdiği çağrı mektubu bile yanında ve adaya bunun için geldin ama yinede görevlinin sözlerini unutmamak için günlüğünü çıkartıyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Günlüğüne not al...",
          nextNode: "qo1-iskele2",
        ),
      ],
    ),
    "qo1-iskele2": StoryNode(
      description:
        "Notunu aldıktan sonra günlüğünü çantanın bir köşesine koyuyorsun. Bu günlük senin için oldukça önemli, hem yaptıklarını not alıyorsun hemde yapacaklarını. Küçük bir notun bir çok şeyi değiştirebileceğine inanıyorsun. Kalabalıktan ayrılmadan önce Lonca görevlisinin son sözlerini duyuyorsun. Duyduğuna göre limanın kuzey doğusundaki Kensum Harabeleri'ne gitmen gerekiyor ve orada maceracılara özel bir görev bahşedilecekmiş. Kendi kendine bunu unutmasam iyi olur diyerek kalabalıktan ayrılıyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Limana yönel!",
          nextNode: "qo1-iskele3",
        ),
      ],
    ),
    "qo1-iskele3": StoryNode(
      description:
          "Limanın içlerine doğru ilerliyorsun. Yolda gözün diğer maceracılara ve ekipmanlarına kayıyor. Karşılaştırdığında yanında getirdiğin ekipmanlar bu ada için oldukça yetersiz görünüyor. Daha güçlü ekipmanlar satın almak istiyorsun ve buraya gelmeden önce yaptığın araştırmalarda bu limandaki dükkanlarda ada içerisinde etkili bir çok ekipmanın satıldığını öğrendiğinden dolayı hızlı adımlarla liman içerisine doğru ilerliyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "            ...            ",
          nextNode: "qo1-market1",
        ),
      ],
    ),
    "qo1-market1": StoryNode(
      description:
          "Bir yandan da içine: 'Yanımda getirdiğim altın satılan ekipmanlar için yeterli mi? Değil mi?' diye bir şüphe düşüyor. Dükkanlardaki eşyalar oldukça pahalı olabilir ama olmayada bilir, bilemiyorsun. Bu noktada aklına 'Gizemli Market' geliyor. Sana katkı sağlayacak bu gücü kullanmak işine yarayabilir.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Odaklan...",
          nextNode: "qo1-market2",
        ),
      ],
    ),
    "qo1-market2": StoryNode(
      description:
          "İşte barındırdığın bu güce Gizemli Market diyorsun ve burası bir yer değil, içinde taşıdığın özel bir güç. İstediğin zaman kullanabilir, özel avantajlarla şansını deneyebilirsin. Kaliteli ekipmanlar ve adada sana destek olacak eşyaları buradan elde edebilir ve daha fazlası olabilirsin.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Yürümeye devam et...",
          nextNode: "qo1-dükkan1",
        ),
      ],
    ),
    "qo1-dükkan1": StoryNode(
      description:
          "Çok geçmeden limanda meydan denilen yere ulaşıyorsun. Burada bir çok maceracı var hepsi bir şeylerle uğraşıyor. Gözün dükkanları arıyor ve birkaç tanesi dikkatini çekiyor. Biri oldukça lüks görünüyor; vitrinindeki eşyalar gün ışığında parlıyor. Diğeri sade ama önünde birkaç maceracı durmuş, vitrini göremiyorsun. Üçüncüsü ise ikisinin arasında, geri planda kalmış. Gösterişli değil ama çeşitli eşyalar sergilenmiş.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Dükkanların kaşısına geç...",
          nextNode: "qo1-dükkan2",
        ),
      ],
    ),
    "qo1-dükkan2": StoryNode(
      description:
          "Üç dükkânın karşısında durup düşünüyorsun. Lüks olanda eşyalar güçlü ama pahalı olabilir; sade olan sıradan görünüyor ama içinde fırsatlar saklı olabilir. Dikkat çekmeyen ise belki de en beklenmedik hazineleri taşır. Hangisine gireceksin?",
      image: null,
      choices: [
        StoryChoice(
          displayText: "!Test Alanı!",
          nextNode: "test-alanı",
          condition: (character) => character.playerName == "Saitskuruls",
        ),
        StoryChoice(
          displayText: "Sönük dükkana...",
          nextNode: "qo1-sönükdükkan1",
        ),
        StoryChoice(
          displayText: "Normal dükkana...",
          nextNode: "qo1-normaldükkan1",
        ),
        StoryChoice(
          displayText: "Lüks dükkana...",
          nextNode: "qo1-lüksdükkan1",
        ),
      ],
    ),
    "qo1-lüksdükkan1": StoryNode(
      description:
          "Dükkâna giriyorsun ve içeride birkaç tane maceracı var, ürünlere göz atıyorlar. Dükkan sahibi seni bir süre bekletiyor, ardından memnun bir ifadeyle yaklaşarak ürünlerini nazikçe göstermek istiyor.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Ürünlere bak...",
          nextNode: "qo1-lüksdükkan2",
        ),
      ],
    ),
    "qo1-lüksdükkan2": StoryNode(
      description:
          "Alışverişin ardından dükkandan ayrılmak için kapıya yöneliyorsun ve o an aklına bir şey takılıyor: Adaya gelmeden önce yaptığın araştırmalardan birinde, bu adadan elde edilen malzemelerle özel üretimler yapılabildiğini öğrenmiştin. Bu üretimler hakkında soru sormak için tekrar dükkan sahibinin yanına gidiyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar ürünlere bak...",
          nextNode: "qo1-lüksdükkan2",
        ),
        StoryChoice(
          displayText: "Sorunu sor!",
          nextNode: "qo1-üretim1",
        ),
      ],
    ),
    "qo1-normaldükkan1": StoryNode(
      description:
          "Dükkâna giriyorsun ve içeride birçok maceracı var, ürünleri inceliyorlar. Dükkân sahibi uzaktan memnunlukla izliyor. Sen de diğerleri gibi ürünlere göz atmak istiyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Ürünlere bak...",
          nextNode: "qo1-normaldükkan2",
        ),
      ],
    ),
    "qo1-normaldükkan2": StoryNode(
      description:
          "Alışverişin ardından dükkandan ayrılmak için kapıya yöneliyorsun ve o an aklına bir şey takılıyor: Adaya gelmeden önce yaptığın araştırmalardan birinde, bu adadan elde edilen malzemelerle özel üretimler yapılabildiğini öğrenmiştin. Bu üretimler hakkında soru sormak için tekrar dükkan sahibinin yanına gidiyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar ürünlere bak...",
          nextNode: "qo1-normaldükkan2",
        ),
        StoryChoice(
          displayText: "Sorunu sor!",
          nextNode: "qo1-üretim1",
        ),
      ],
    ),
    "qo1-sönükdükkan1": StoryNode(
      description:
          "Dükkâna giriyorsun ve içerisi oldukça kalabalık; maceracılar ürünlerle ilgileniyor. Dükkân sahibi meşgul. Sen de diğerleri gibi ürünlere göz atmak istiyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Ürünlere bak...",
          nextNode: "qo1-sönükdükkan2",
        ),
      ],
    ),
    "qo1-sönükdükkan2": StoryNode(
      description:
          "Alışverişin ardından dükkandan ayrılmak için kapıya yöneliyorsun ve o an aklına bir şey takılıyor: Adaya gelmeden önce yaptığın araştırmalardan birinde, bu adadan elde edilen malzemelerle özel üretimler yapılabildiğini öğrenmiştin. Bu üretimler hakkında soru sormak için tekrar dükkan sahibinin yanına gidiyorsun.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar ürünlere bak...",
          nextNode: "qo1-sönükdükkan2",
        ),
        StoryChoice(
          displayText: "Sorunu sor!",
          nextNode: "qo1-üretim1",
        ),
      ],
    ),
    "qo1-üretim1": StoryNode(
      description:
          "Sorduğunda dükkân sahibi sana olumlu bir karşılık veriyor ve vitrinin arkasından birkaç parşömen çıkartıyor. Çıkarttığı parşömenlerin pot üretimleri hakkında olduğunu söyleyip buradan bir şeyler öğrenebileceğini söylüyor. Ancak baktıktan sonra geri vermeni özellikle istiyor.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Parşömeni incele!",
          nextNode: "qo1-üretim2",
        ),
      ],
    ),
    "qo1-üretim2": StoryNode(
      description:
          "Artık potların nasıl üretilebiliceğini biliyorsun ve gerekli malzemelere sahip olduğunda istediğin kadar üretebilirsin. Parşömenleri dükkan sahibine saygılarını sunarak verip dükkandan ayrılıyorsun. Dükkandan ayrılırken bir ses duyuyorsun. Meydana yakın bi bölgede çatışma sesleri yükseliyor, başta anlamıyorsun fakat sonradan bir çan sesi yankılanıyor kulağında. Neler olup bittiğini anlamadan liman gardiyanlarından bir çağrı duyuyorsun: 'Baskın! Yozlaşmış baskını!' diye bağırıyor.",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Etrafa bakın!",
          nextNode: "qo1-baskın",
        ),
      ],
    ),
    "qo1-baskın": StoryNode(
      description:
          "Dışarıda herkes bir yerlere koşturuyor. Neler olup bittiğini şimdi daha net anlıyorsun. Limana büyük bir yozlaşmış canavar grubu saldırıyor. Meydandan etrafa bir çok sokak çıkıyor ve hepsinde kılıç ve büyü sesleri duyuluyor. Ne yapacaksın?",
      image: null,
      choices: [
        StoryChoice(
          displayText: "!Test Alanı!",
          nextNode: "test-alanı",
          condition: (character) => character.playerName == "Saitskuruls",
        ),
        StoryChoice(
          displayText: "Ara sokaklara doğru...",
          nextNode: "qo1-arasokakbaskın1",
        ),
        StoryChoice(
          displayText: "Yoğun seslere doğru...",
          nextNode: "qo1-anabaskın1",
        ),
        StoryChoice(
          displayText: "İskeleye doğru...",
          nextNode: "qo1-iskelebaskın1",
        ),
      ],
    ),

    // StoryNode yapısı;
    "": StoryNode(
      description: "",
      image: null,
      choices: [
        StoryChoice(
          displayText: "",
          nextNode: "",
        ),
      ],
    ),

    // Test alanı
    "test-alanı": StoryNode(
      description: "Test Alanı Ana Menüsü",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Sayfa Komutları",
          nextNode: "test-alanı-sayfa",
        ),
        StoryChoice(
          displayText: "Malzeme Komutları",
          nextNode: "test-alanı-malzeme",
        ),
        StoryChoice(
          displayText: "Karakter Komutları",
          nextNode: "test-alanı-karakter",
        ),
        StoryChoice(
          displayText: "Hikaye Komutları",
          nextNode: "test-alanı-hikaye",
        ),
      ],
    ),
    "test-alanı-sayfa": StoryNode(
      description: "Test Alanı Sayfa Komutları Menüsü",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Savaş Testi",
          nextNode: "test-alanı-savaş",
        ),
        StoryChoice(
          displayText: "Dükkan Testi",
          nextNode: "test-alanı-dükkan",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-dükkan": StoryNode(
      description: "Test Edildi",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar Test Et",
          nextNode: "test-alanı-dükkan",
        ),
        StoryChoice(
          displayText: "Sayfa Komutlarına Dön",
          nextNode: "test-alanı-sayfa",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-savaş": StoryNode(
      description: "Test Edildi",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar Test Et",
          nextNode: "test-alanı-savaş",
        ),
        StoryChoice(
          displayText: "Sayfa Komutlarına Dön",
          nextNode: "test-alanı-sayfa",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-malzeme": StoryNode(
      description: "Test Alanı Malzeme Komutları Menüsü",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Temel Malzemeler Al",
          nextNode: "test-alanı-malzeme-temel",
        ),
        StoryChoice(
          displayText: "Şans Kartı Al",
          nextNode: "test-alanı-malzeme-şanskartı",
        ),
        StoryChoice(
          displayText: "Sıfırlama Kartı Al",
          nextNode: "test-alanı-malzeme-sıfırlama",
        ),
        StoryChoice(
          displayText: "Üretim Malzemesi Al",
          nextNode: "test-alanı-malzeme-üretim",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-malzeme-temel": StoryNode(
      description: "Altın ve potlar aldınız...",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar Al",
          nextNode: "test-alanı-malzeme-temel",
        ),
        StoryChoice(
          displayText: "Malzeme Komutlarına Dön",
          nextNode: "test-alanı-malzeme",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-malzeme-şanskartı": StoryNode(
      description: "Şans kartı aldınız...",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar Al",
          nextNode: "test-alanı-malzeme-şanskartı",
        ),
        StoryChoice(
          displayText: "Malzeme Komutlarına Dön",
          nextNode: "test-alanı-malzeme",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-malzeme-sıfırlama": StoryNode(
      description: "Sıfırlama kartı aldınız...",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar Al",
          nextNode: "test-alanı-malzeme-sıfırlama",
        ),
        StoryChoice(
          displayText: "Malzeme Komutlarına Dön",
          nextNode: "test-alanı-malzeme",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-malzeme-üretim": StoryNode(
      description: "Üretim malzemeleri aldınız...",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar Al",
          nextNode: "test-alanı-malzeme-üretim",
        ),
        StoryChoice(
          displayText: "Malzeme Komutlarına Dön",
          nextNode: "test-alanı-malzeme",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-karakter": StoryNode(
      description: "Test Alanı Karakter Komutları Menüsü",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Seviye Atla",
          nextNode: "test-alanı-seviye",
        ),
        StoryChoice(
          displayText: "Can ve Aksiyon Fulle",
          nextNode: "test-alanı-değerfulle",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-seviye": StoryNode(
      description: "Seviye atladınız...",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Tekrar Atla",
          nextNode: "test-alanı-seviye",
        ),
        StoryChoice(
          displayText: "Karakter Komutlarına Dön",
          nextNode: "test-alanı-karakter",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-değerfulle": StoryNode(
      description: "Can ve aksiyon puanları fullendi...",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Karakter Komutlarına Dön",
          nextNode: "test-alanı-karakter",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-hikaye": StoryNode(
      description: "Test Alanı Hikaye Komutları Menüsü",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Başa dön!",
          nextNode: "qo1-giriş1",
        ),
        StoryChoice(
          displayText: "Dükkan seçimine dön!",
          nextNode: "qo1-dükkan2",
        ),
        StoryChoice(
          displayText: "Baskının başına dön!",
          nextNode: "qo1-baskın",
        ),
        StoryChoice(
          displayText: "Oyunu Sona Erdir",
          nextNode: "test-alanı-oyunsonu",
        ),
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
    "test-alanı-oyunsonu": StoryNode(
      description: "Oyunu sona erdirdin!",
      image: null,
      choices: [
        StoryChoice(
          displayText: "Ana Menüye Dön",
          nextNode: "test-alanı",
        ),
      ],
    ),
  };

  String currentNode = "qo1";
  final Character character;
  final Inventory inventory;

  StoryProgress({
    required this.character,
    required this.inventory,
  });

  String processText(String text) {
    return text
        .replaceAll("{karakter_adı}", character.playerName)
        .replaceAll("{ırk}", character.race)
        .replaceAll("{sınıf}", character.characterClass);
  }
}
