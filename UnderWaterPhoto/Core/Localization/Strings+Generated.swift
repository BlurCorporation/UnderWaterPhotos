// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum BenefitsView {
    internal enum ArrayOfBenefits {
      /// benefits1
      internal static let firstElement = L10n.tr("Localizable", "BenefitsView.arrayOfBenefits.firstElement", fallback: "benefits1")
      /// benefits2
      internal static let secondElement = L10n.tr("Localizable", "BenefitsView.arrayOfBenefits.secondElement", fallback: "benefits2")
      /// benefits3
      internal static let thirdElement = L10n.tr("Localizable", "BenefitsView.arrayOfBenefits.thirdElement", fallback: "benefits3")
    }
  }
  internal enum ButtonView {
    /// Оформить
    internal static let title = L10n.tr("Localizable", "ButtonView.title", fallback: "Оформить")
  }
  internal enum SubscriptionViewController {
    /// Подписка
    internal static let titleLabel = L10n.tr("Localizable", "SubscriptionViewController.titleLabel", fallback: "Подписка")
  }
  internal enum TextView {
    /// Oформляя подписку вы соглашаетесь на Условия использования и Политику конфиденциальности
    internal static let rulesText = L10n.tr("Localizable", "TextView.rulesText", fallback: "Oформляя подписку вы соглашаетесь на Условия использования и Политику конфиденциальности")
    internal enum AttributedString {
      /// Условия использования и Политику конфиденциальности
      internal static let range = L10n.tr("Localizable", "TextView.attributedString.range", fallback: "Условия использования и Политику конфиденциальности")
    }
  }
  internal enum LanguageSettingView {
    /// Localizable.strings
    ///   UnderWaterPhoto
    /// 
    ///   Created by Андрей Барсуков on 25.01.2024.
    internal static let titleLabel = L10n.tr("Localizable", "languageSettingView.titleLabel", fallback: "Язык приложения")
  }
  internal enum LanguageSettingViewModel {
    internal enum Languages {
      internal enum Title {
        /// Английсикий
        internal static let en = L10n.tr("Localizable", "languageSettingViewModel.Languages.title.en", fallback: "Английсикий")
        /// Русский
        internal static let rus = L10n.tr("Localizable", "languageSettingViewModel.Languages.title.rus", fallback: "Русский")
      }
    }
  }
  internal enum SettingsViewModel {
    internal enum Settings {
      internal enum Id {
        internal enum _0 {
          /// Русский
          internal static let additionalName = L10n.tr("Localizable", "settingsViewModel.settings.id.0.additionalName", fallback: "Русский")
          /// Язык приложения
          internal static let settingName = L10n.tr("Localizable", "settingsViewModel.settings.id.0.settingName", fallback: "Язык приложения")
        }
        internal enum _1 {
          /// Очистить кэш
          internal static let settingName = L10n.tr("Localizable", "settingsViewModel.settings.id.1.settingName", fallback: "Очистить кэш")
        }
        internal enum _2 {
          /// Подписка
          internal static let settingName = L10n.tr("Localizable", "settingsViewModel.settings.id.2.settingName", fallback: "Подписка")
        }
        internal enum _3 {
          /// Удалить аккаунт
          internal static let settingName = L10n.tr("Localizable", "settingsViewModel.settings.id.3.settingName", fallback: "Удалить аккаунт")
        }
        internal enum _4 {
          /// Выйти из аккаунта
          internal static let settingName = L10n.tr("Localizable", "settingsViewModel.settings.id.4.settingName", fallback: "Выйти из аккаунта")
        }
      }
    }
  }
  internal enum SubscriptionModel {
    internal enum PriceData {
      internal enum FirstElement {
        /// 9 миллинов
        internal static let price = L10n.tr("Localizable", "subscriptionModel.priceData.firstElement.price", fallback: "9 миллинов")
        /// 9 миллинов
        internal static let priceForDay = L10n.tr("Localizable", "subscriptionModel.priceData.firstElement.priceForDay", fallback: "9 миллинов")
        /// Первая подписка
        internal static let title = L10n.tr("Localizable", "subscriptionModel.priceData.firstElement.title", fallback: "Первая подписка")
      }
      internal enum FourthElement {
        /// какая-нибудь цена
        internal static let price = L10n.tr("Localizable", "subscriptionModel.priceData.fourthElement.price", fallback: "какая-нибудь цена")
        /// не смотреть рилсы
        internal static let priceForDay = L10n.tr("Localizable", "subscriptionModel.priceData.fourthElement.priceForDay", fallback: "не смотреть рилсы")
        /// Четвертая подписка
        internal static let title = L10n.tr("Localizable", "subscriptionModel.priceData.fourthElement.title", fallback: "Четвертая подписка")
      }
      internal enum SecondElement {
        /// 16 рублей
        internal static let price = L10n.tr("Localizable", "subscriptionModel.priceData.secondElement.price", fallback: "16 рублей")
        /// 3 копейки
        internal static let priceForDay = L10n.tr("Localizable", "subscriptionModel.priceData.secondElement.priceForDay", fallback: "3 копейки")
        /// Вторая подписка
        internal static let title = L10n.tr("Localizable", "subscriptionModel.priceData.secondElement.title", fallback: "Вторая подписка")
      }
      internal enum ThirdElement {
        /// 3 конфетки
        internal static let price = L10n.tr("Localizable", "subscriptionModel.priceData.thirdElement.price", fallback: "3 конфетки")
        /// 4 нюдса
        internal static let priceForDay = L10n.tr("Localizable", "subscriptionModel.priceData.thirdElement.priceForDay", fallback: "4 нюдса")
        /// Третья крутая подписка
        internal static let title = L10n.tr("Localizable", "subscriptionModel.priceData.thirdElement.title", fallback: "Третья крутая подписка")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
