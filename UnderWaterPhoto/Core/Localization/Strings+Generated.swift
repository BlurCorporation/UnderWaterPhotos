// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AuthVC {
    /// Имя
    internal static let nameTextField = L10n.tr("Localizable", "AuthVC.nameTextField", fallback: "Имя")
    /// Пароль
    internal static let passwordTextField = L10n.tr("Localizable", "AuthVC.passwordTextField", fallback: "Пароль")
    /// Повторите пароль
    internal static let repeatPasswordTextField = L10n.tr("Localizable", "AuthVC.repeatPasswordTextField", fallback: "Повторите пароль")
    internal enum Else {
      internal enum ExpandLoginButton {
        internal enum HeadTitle {
          /// Добро пожаловать
          internal static let text = L10n.tr("Localizable", "AuthVC.else.expandLoginButton.headTitle.text", fallback: "Добро пожаловать")
        }
        internal enum LoginButton {
          /// Регистрация
          internal static let title = L10n.tr("Localizable", "AuthVC.else.expandLoginButton.loginButton.title", fallback: "Регистрация")
        }
        internal enum RegistrationButton {
          /// Войти
          internal static let title = L10n.tr("Localizable", "AuthVC.else.expandLoginButton.registrationButton.title", fallback: "Войти")
        }
        internal enum RestorePasswordButton {
          /// Восстановить пароль
          internal static let title = L10n.tr("Localizable", "AuthVC.else.expandLoginButton.restorePasswordButton.title", fallback: "Восстановить пароль")
        }
      }
    }
    internal enum Error {
      internal enum EmailAlreadyInUse {
        /// Аккаунт с такой почтой уже существует
        internal static let message = L10n.tr("Localizable", "AuthVC.error.emailAlreadyInUse.message", fallback: "Аккаунт с такой почтой уже существует")
      }
      internal enum InvalidCredential {
        /// Неправильный Логин или Пароль
        internal static let message = L10n.tr("Localizable", "AuthVC.error.invalidCredential.message", fallback: "Неправильный Логин или Пароль")
      }
      internal enum InvalidEmail {
        /// Неправильный E-mail
        internal static let message = L10n.tr("Localizable", "AuthVC.error.invalidEmail.message", fallback: "Неправильный E-mail")
      }
      internal enum RepeatPasswordInvalid {
        /// Пароли не совпадают
        internal static let message = L10n.tr("Localizable", "AuthVC.error.repeatPasswordInvalid.message", fallback: "Пароли не совпадают")
      }
      internal enum SomethingWrong {
        /// Аккаунт с такой почтой уже существует
        internal static let message = L10n.tr("Localizable", "AuthVC.error.somethingWrong.message", fallback: "Аккаунт с такой почтой уже существует")
      }
      internal enum TextFieldIsEmpty {
        /// Заполните все поля ввода
        internal static let message = L10n.tr("Localizable", "AuthVC.error.textFieldIsEmpty.message", fallback: "Заполните все поля ввода")
      }
      internal enum UserDisabled {
        /// Аккаунт отключен, свяжитесь с поддержкой
        internal static let message = L10n.tr("Localizable", "AuthVC.error.userDisabled.message", fallback: "Аккаунт отключен, свяжитесь с поддержкой")
      }
      internal enum WeakPassword {
        /// Пароль слишком простой
        internal static let message = L10n.tr("Localizable", "AuthVC.error.weakPassword.message", fallback: "Пароль слишком простой")
      }
    }
    internal enum HeadTitle {
      /// Создать аккаунт
      internal static let text = L10n.tr("Localizable", "AuthVC.headTitle.text", fallback: "Создать аккаунт")
    }
    internal enum If {
      internal enum ExpandLoginButton {
        internal enum HeadTitle {
          /// Создать аккаунт
          internal static let text = L10n.tr("Localizable", "AuthVC.if.expandLoginButton.headTitle.text", fallback: "Создать аккаунт")
        }
        internal enum LoginButton {
          /// Войти
          internal static let title = L10n.tr("Localizable", "AuthVC.if.expandLoginButton.loginButton.title", fallback: "Войти")
        }
        internal enum RegistrationButton {
          /// Зарегестрироваться
          internal static let title = L10n.tr("Localizable", "AuthVC.if.expandLoginButton.registrationButton.title", fallback: "Зарегестрироваться")
        }
      }
    }
    internal enum LoginButton {
      /// Войти
      internal static let setTitle = L10n.tr("Localizable", "AuthVC.loginButton.setTitle", fallback: "Войти")
    }
    internal enum LoginUsinLabel {
      /// Войти с помощью
      internal static let text = L10n.tr("Localizable", "AuthVC.loginUsinLabel.text", fallback: "Войти с помощью")
    }
    internal enum RegistrationButton {
      /// Зарегистрироваться
      internal static let setTitle = L10n.tr("Localizable", "AuthVC.registrationButton.setTitle", fallback: "Зарегистрироваться")
    }
    internal enum RestorePasswordButton {
      /// Восстановить пароль
      internal static let setTitle = L10n.tr("Localizable", "AuthVC.restorePasswordButton.setTitle", fallback: "Восстановить пароль")
    }
    internal enum RestorePasswordExpand {
      internal enum HeadTitle {
        /// Восстановить пароль
        internal static let text = L10n.tr("Localizable", "AuthVC.restorePasswordExpand.headTitle.text", fallback: "Восстановить пароль")
      }
      internal enum RegistrationButton {
        /// Восстановить пароль
        internal static let title = L10n.tr("Localizable", "AuthVC.restorePasswordExpand.registrationButton.title", fallback: "Восстановить пароль")
      }
    }
  }
  internal enum ProcessVC {
    internal enum BottomSheetBackButton {
      internal enum Button {
        /// Назад
        internal static let title = L10n.tr("Localizable", "ProcessVC.bottomSheetBackButton.button.title", fallback: "Назад")
      }
    }
    internal enum BottomSheetSaveButton {
      internal enum Button {
        /// Сохранить
        internal static let title = L10n.tr("Localizable", "ProcessVC.bottomSheetSaveButton.button.title", fallback: "Сохранить")
      }
    }
    internal enum ChangeToProcess {
      internal enum TitleLabel {
        /// Редактирование
        internal static let text = L10n.tr("Localizable", "ProcessVC.changeToProcess.titleLabel.text", fallback: "Редактирование")
      }
    }
    internal enum HideLogoButton {
      internal enum Button {
        /// Убрать логотип
        internal static let title = L10n.tr("Localizable", "ProcessVC.hideLogoButton.button.title", fallback: "Убрать логотип")
      }
    }
    internal enum ProcessPhotoButton {
      internal enum Button {
        /// Обработать
        internal static let title = L10n.tr("Localizable", "ProcessVC.processPhotoButton.button.title", fallback: "Обработать")
      }
      internal enum Edit {
        /// Редактировать
        internal static let title = L10n.tr("Localizable", "ProcessVC.processPhotoButton.edit.title", fallback: "Редактировать")
      }
    }
    internal enum ProcessVideoButton {
      internal enum GoMainScene {
        /// Вернуться в галерею
        internal static let title = L10n.tr("Localizable", "ProcessVC.processVideoButton.goMainScene.title", fallback: "Вернуться в галерею")
      }
    }
    internal enum TitleLabel {
      internal enum Label {
        /// Изменение
        internal static let text = L10n.tr("Localizable", "ProcessVC.titleLabel.label.text", fallback: "Изменение")
      }
    }
  }
  internal enum BottomSheetSaveVC {
    internal enum BottomSheetBackButton {
      internal enum Button {
        /// Назад
        internal static let setTitle = L10n.tr("Localizable", "bottomSheetSaveVC.bottomSheetBackButton.button.setTitle", fallback: "Назад")
      }
    }
    internal enum BottomSheetSaveButton {
      internal enum Button {
        /// Сохранить
        internal static let setTitle = L10n.tr("Localizable", "bottomSheetSaveVC.bottomSheetSaveButton.button.setTitle", fallback: "Сохранить")
      }
    }
    internal enum SaveInAppLabel {
      internal enum Label {
        /// Сохранить в приложении
        internal static let text = L10n.tr("Localizable", "bottomSheetSaveVC.saveInAppLabel.label.text", fallback: "Сохранить в приложении")
      }
    }
    internal enum SaveOnPhoneLabel {
      internal enum Label {
        /// Сохранить на устрйоство
        internal static let text = L10n.tr("Localizable", "bottomSheetSaveVC.saveOnPhoneLabel.label.text", fallback: "Сохранить на устрйоство")
      }
    }
  }
  internal enum ButtonView {
    /// Оформить
    internal static let title = L10n.tr("Localizable", "buttonView.title", fallback: "Оформить")
  }
  internal enum Extension {
    internal enum HeaderView {
      internal enum AddPhotoButtonView {
        /// Редактировать Фото и Видео
        internal static let text = L10n.tr("Localizable", "extension.headerView.addPhotoButtonView.text", fallback: "Редактировать Фото и Видео")
      }
      internal enum NavBar {
        /// Привет, %@!
        internal static func text(_ p1: Any) -> String {
          return L10n.tr("Localizable", "extension.headerView.navBar.text", String(describing: p1), fallback: "Привет, %@!")
        }
      }
    }
    internal enum MainView {
      internal enum EmptyView {
        /// Здесь будут загруженные тобой фото и видео
        internal static let text = L10n.tr("Localizable", "extension.mainView.emptyView.text", fallback: "Здесь будут загруженные тобой фото и видео")
      }
      internal enum MainHeaderTextView {
        /// Cделай свои подводные фотографии лучше вместе с нами!
        internal static let text = L10n.tr("Localizable", "extension.mainView.mainHeaderTextView.text", fallback: "Cделай свои подводные фотографии лучше вместе с нами!")
      }
    }
  }
  internal enum LanguageSettingVC {
    /// Localizable.strings
    ///   UnderWaterPhoto
    /// 
    ///   Created by Андрей Барсуков on 25.01.2024.
    internal static let titleLabel = L10n.tr("Localizable", "languageSettingVC.titleLabel", fallback: "Язык приложения")
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
  internal enum MainViewModel {
    /// Александр
    internal static let userName = L10n.tr("Localizable", "mainViewModel.userName", fallback: "Александр")
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
  internal enum SubscriptionVC {
    /// Подписка
    internal static let titleLabel = L10n.tr("Localizable", "subscriptionVC.titleLabel", fallback: "Подписка")
  }
  internal enum TextView {
    /// Oформляя подписку вы соглашаетесь на Условия использования и Политику конфиденциальности
    internal static let rulesText = L10n.tr("Localizable", "textView.rulesText", fallback: "Oформляя подписку вы соглашаетесь на Условия использования и Политику конфиденциальности")
    internal enum AttributedString {
      /// Условия использования и Политику конфиденциальности
      internal static let range = L10n.tr("Localizable", "textView.attributedString.range", fallback: "Условия использования и Политику конфиденциальности")
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
