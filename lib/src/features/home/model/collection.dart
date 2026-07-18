import '../../../../routes/routes.dart';

/// Identifica qual texto traduzido (AppLocalizations) deve ser exibido
/// como título de cada item da grade "Collection" na Home.
/// A resolução da chave -> texto localizado acontece em CollectionButton,
/// que tem acesso ao BuildContext.
enum CollectionTitleKey {
  quran,
  hadees,
  dua,
  tasbih,
  azkars,
  allahNames,
  prayerTimes,
  qiblaDirection,
  liveTv,
  others,
}

class Collection {
  final String assetName;
  final CollectionTitleKey titleKey;
  final String routeName;

  Collection(this.assetName, this.titleKey, this.routeName);
}

List<Collection> collections = [
  Collection(
    'assets/images/collection_icon/svg/quran.svg',
    CollectionTitleKey.quran,
    RouteGenerator.quran,
  ),
  Collection(
    'assets/images/collection_icon/svg/hadees.svg',
    CollectionTitleKey.hadees,
    'Coming Soon',
  ),
  Collection(
    'assets/images/collection_icon/svg/duas.svg',
    CollectionTitleKey.dua,
    RouteGenerator.dua,
  ),
  Collection(
    'assets/images/collection_icon/svg/tasbih.svg',
    CollectionTitleKey.tasbih,
    RouteGenerator.tasbih,
  ),
  Collection(
    'assets/images/collection_icon/svg/other.svg',
    CollectionTitleKey.azkars,
    RouteGenerator.azkar,
  ),
  Collection(
    'assets/images/collection_icon/svg/allah.svg',
    CollectionTitleKey.allahNames,
    RouteGenerator.allahName,
  ),
  Collection(
    'assets/images/collection_icon/svg/prayer_time.svg',
    CollectionTitleKey.prayerTimes,
    RouteGenerator.prayerTimingPage,
  ),
  Collection(
    'assets/images/collection_icon/svg/kiblat.svg',
    CollectionTitleKey.qiblaDirection,
    RouteGenerator.qibla,
  ),
  Collection(
    'assets/images/collection_icon/svg/qaabah.svg',
    CollectionTitleKey.liveTv,
    RouteGenerator.liveTv,
  ),
  Collection(
    'assets/images/collection_icon/svg/other.svg',
    CollectionTitleKey.others,
    'Coming Soon',
  ),
];
