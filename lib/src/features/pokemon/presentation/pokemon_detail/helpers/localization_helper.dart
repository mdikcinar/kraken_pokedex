import 'package:easy_localization/easy_localization.dart';
import 'package:kraken_pokedex/src/utils/language/locale_keys.g.dart';

extension StatNameLocalization on String {
  String? get localizeStatName {
    switch (this) {
      case 'hp':
        return LocaleKeys.hp.tr();
      case 'attack':
        return LocaleKeys.attack.tr();
      case 'defense':
        return LocaleKeys.defense.tr();
      case 'special-attack':
        return LocaleKeys.special_attack.tr();
      case 'special-defense':
        return LocaleKeys.special_defense.tr();
      case 'speed':
        return LocaleKeys.speed.tr();
      case 'accuracy':
        return LocaleKeys.accuracy.tr();
      case 'evasion':
        return LocaleKeys.evasion.tr();
      default:
        return this;
    }
  }
}
