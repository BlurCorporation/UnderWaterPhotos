// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AppDelegate {
    internal enum Application {
      internal enum Return {
        internal enum UISceneConfiguration {
          /// Default Configuration
          internal static let name = L10n.tr("Localizable", "appDelegate.application.return.uISceneConfiguration.name", fallback: "Default Configuration")
        }
      }
    }
  }
  internal enum AuthViewController {
    /// E-mail
    internal static let emailTextField = L10n.tr("Localizable", "authViewController.emailTextField", fallback: "E-mail")
    /// Имя
    internal static let nameTextField = L10n.tr("Localizable", "authViewController.nameTextField", fallback: "Имя")
    /// Пароль
    internal static let passwordTextField = L10n.tr("Localizable", "authViewController.passwordTextField", fallback: "Пароль")
    /// Повторите пароль
    internal static let repeatPasswordTextField = L10n.tr("Localizable", "authViewController.repeatPasswordTextField", fallback: "Повторите пароль")
    internal enum AppleIdButton {
      internal enum SetBackgroundImage {
        /// appleLogo
        internal static let name = L10n.tr("Localizable", "authViewController.appleIdButton.setBackgroundImage.name", fallback: "appleLogo")
      }
    }
    internal enum Else {
      internal enum ExpandLoginButton {
        internal enum HeadTitle {
          /// Добро пожаловать
          internal static let text = L10n.tr("Localizable", "authViewController.else.expandLoginButton.headTitle.text", fallback: "Добро пожаловать")
        }
        internal enum LoginButton {
          /// Регистрация
          internal static let title = L10n.tr("Localizable", "authViewController.else.expandLoginButton.loginButton.title", fallback: "Регистрация")
        }
        internal enum RegistrationButton {
          /// Войти
          internal static let title = L10n.tr("Localizable", "authViewController.else.expandLoginButton.registrationButton.title", fallback: "Войти")
        }
        internal enum RestorePasswordButton {
          /// Восстановить пароль
          internal static let title = L10n.tr("Localizable", "authViewController.else.expandLoginButton.restorePasswordButton.title", fallback: "Восстановить пароль")
        }
      }
    }
    internal enum GoogleIdButton {
      internal enum SetBackgroundImage {
        /// googleLogo
        internal static let name = L10n.tr("Localizable", "authViewController.googleIdButton.setBackgroundImage.name", fallback: "googleLogo")
      }
    }
    internal enum HeadTitle {
      /// Создать аккаунт
      internal static let text = L10n.tr("Localizable", "authViewController.headTitle.text", fallback: "Создать аккаунт")
      /// backgroundColorRegistrationButton
      internal static let textColor = L10n.tr("Localizable", "authViewController.headTitle.textColor", fallback: "backgroundColorRegistrationButton")
    }
    internal enum If {
      internal enum ExpandLoginButton {
        internal enum HeadTitle {
          /// Создать аккаунт
          internal static let text = L10n.tr("Localizable", "authViewController.if.expandLoginButton.headTitle.text", fallback: "Создать аккаунт")
        }
        internal enum LoginButton {
          /// Войти
          internal static let title = L10n.tr("Localizable", "authViewController.if.expandLoginButton.loginButton.title", fallback: "Войти")
        }
        internal enum RegistrationButton {
          /// Зарегестрироваться
          internal static let title = L10n.tr("Localizable", "authViewController.if.expandLoginButton.registrationButton.title", fallback: "Зарегестрироваться")
        }
      }
    }
    internal enum LoginButton {
      /// Войти
      internal static let setTitle = L10n.tr("Localizable", "authViewController.loginButton.setTitle", fallback: "Войти")
    }
    internal enum LoginUsinLabel {
      /// Войти с помощью
      internal static let text = L10n.tr("Localizable", "authViewController.loginUsinLabel.text", fallback: "Войти с помощью")
    }
    internal enum RegistrationButton {
      /// Зарегистрироваться
      internal static let setTitle = L10n.tr("Localizable", "authViewController.registrationButton.setTitle", fallback: "Зарегистрироваться")
    }
    internal enum RestorePasswordButton {
      /// Восстановить пароль
      internal static let setTitle = L10n.tr("Localizable", "authViewController.restorePasswordButton.setTitle", fallback: "Восстановить пароль")
    }
    internal enum RestorePasswordExpand {
      internal enum HeadTitle {
        /// Восстановить пароль
        internal static let text = L10n.tr("Localizable", "authViewController.restorePasswordExpand.headTitle.text", fallback: "Восстановить пароль")
      }
      internal enum RegistrationButton {
        /// Восстановить пароль
        internal static let title = L10n.tr("Localizable", "authViewController.restorePasswordExpand.registrationButton.title", fallback: "Восстановить пароль")
      }
    }
  }
  internal enum BenefitsView {
    internal enum ArrayOfBenefits {
      /// benefits1
      internal static let firstElement = L10n.tr("Localizable", "benefitsView.arrayOfBenefits.firstElement", fallback: "benefits1")
      /// benefits2
      internal static let secondElement = L10n.tr("Localizable", "benefitsView.arrayOfBenefits.secondElement", fallback: "benefits2")
      /// benefits3
      internal static let thirdElement = L10n.tr("Localizable", "benefitsView.arrayOfBenefits.thirdElement", fallback: "benefits3")
    }
  }
  internal enum BottomSheetSaveViewController {
    internal enum BottomSheetBackButton {
      internal enum Button {
        /// Назад
        internal static let setTitle = L10n.tr("Localizable", "bottomSheetSaveViewController.bottomSheetBackButton.button.setTitle", fallback: "Назад")
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "bottomSheetSaveViewController.bottomSheetBackButton.button.tintColor.name", fallback: "white")
        }
      }
    }
    internal enum BottomSheetSaveButton {
      internal enum Button {
        /// Сохранить
        internal static let setTitle = L10n.tr("Localizable", "bottomSheetSaveViewController.bottomSheetSaveButton.button.setTitle", fallback: "Сохранить")
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "bottomSheetSaveViewController.bottomSheetSaveButton.button.tintColor.name", fallback: "white")
        }
      }
    }
    internal enum SaveInAppLabel {
      internal enum Label {
        /// Сохранить в приложении
        internal static let text = L10n.tr("Localizable", "bottomSheetSaveViewController.saveInAppLabel.label.text", fallback: "Сохранить в приложении")
        internal enum TextColor {
          /// white
          internal static let name = L10n.tr("Localizable", "bottomSheetSaveViewController.saveInAppLabel.label.textColor.name", fallback: "white")
        }
      }
    }
    internal enum SaveOnPhoneLabel {
      internal enum Label {
        /// Сохранить на устрйоство
        internal static let text = L10n.tr("Localizable", "bottomSheetSaveViewController.saveOnPhoneLabel.label.text", fallback: "Сохранить на устрйоство")
        internal enum TextColor {
          /// white
          internal static let name = L10n.tr("Localizable", "bottomSheetSaveViewController.saveOnPhoneLabel.label.textColor.name", fallback: "white")
        }
      }
    }
    internal enum ViewDidLoad {
      internal enum View {
        internal enum BackgroundColor {
          /// blueDark
          internal static let name = L10n.tr("Localizable", "bottomSheetSaveViewController.viewDidLoad.view.backgroundColor.name", fallback: "blueDark")
        }
      }
    }
  }
  internal enum ButtonView {
    /// Оформить
    internal static let title = L10n.tr("Localizable", "buttonView.title", fallback: "Оформить")
  }
  internal enum CrossButtonView {
    internal enum Body {
      internal enum VStack {
        internal enum FirstRectangle {
          /// white
          internal static let foregroundColor = L10n.tr("Localizable", "crossButtonView.body.vStack.firstRectangle.foregroundColor", fallback: "white")
        }
        internal enum SecondRectangle {
          /// white
          internal static let foregroundColor = L10n.tr("Localizable", "crossButtonView.body.vStack.secondRectangle.foregroundColor", fallback: "white")
        }
      }
      internal enum ZStack {
        internal enum Rectangle {
          /// blueDark
          internal static let foregroundColor = L10n.tr("Localizable", "crossButtonView.body.zStack.rectangle.foregroundColor", fallback: "blueDark")
        }
      }
    }
  }
  internal enum CustomButton {
    internal enum SetupButton {
      internal enum IdButton {
        internal enum BackgroundColor {
          /// backgroundColorIdButton
          internal static let name = L10n.tr("Localizable", "customButton.setupButton.idButton.backgroundColor.name", fallback: "backgroundColorIdButton")
        }
      }
      internal enum LoginButton {
        internal enum SetTitleColor {
          /// backgroundColorRegistrationButton
          internal static let name = L10n.tr("Localizable", "customButton.setupButton.loginButton.setTitleColor.name", fallback: "backgroundColorRegistrationButton")
        }
      }
      internal enum RegistrationButton {
        internal enum BackgroundColor {
          /// backgroundColorRegistrationButton
          internal static let name = L10n.tr("Localizable", "customButton.setupButton.registrationButton.backgroundColor.name", fallback: "backgroundColorRegistrationButton")
        }
        internal enum SetTitleColor {
          /// backgroundColorRegistrationButton
          internal static let name = L10n.tr("Localizable", "customButton.setupButton.registrationButton.setTitleColor.name", fallback: "backgroundColorRegistrationButton")
        }
      }
    }
  }
  internal enum CustomTextField {
    internal enum OverrideInit {
      internal enum BackgroundColor {
        /// backgroundColorIdButton
        internal static let name = L10n.tr("Localizable", "customTextField.overrideInit.backgroundColor.name", fallback: "backgroundColorIdButton")
      }
    }
    internal enum PlaceholderText {
      internal enum AttrString {
        /// text
        internal static let string = L10n.tr("Localizable", "customTextField.placeholderText.attrString.string", fallback: "text")
        internal enum Attributes {
          /// backgroundColorTextField
          internal static let colorName = L10n.tr("Localizable", "customTextField.placeholderText.attrString.attributes.colorName", fallback: "backgroundColorTextField")
        }
      }
    }
  }
  internal enum Extension {
    internal enum HeaderView {
      internal enum AddPhotoButtonView {
        /// Редактировать Фото и Видео
        internal static let text = L10n.tr("Localizable", "extension.headerView.addPhotoButtonView.text", fallback: "Редактировать Фото и Видео")
        internal enum Button {
          /// blue
          internal static let backgroundColor = L10n.tr("Localizable", "extension.headerView.addPhotoButtonView.button.backgroundColor", fallback: "blue")
          /// white
          internal static let foregroundColor = L10n.tr("Localizable", "extension.headerView.addPhotoButtonView.button.foregroundColor", fallback: "white")
        }
        internal enum Image {
          /// plus.circle.fill
          internal static let name = L10n.tr("Localizable", "extension.headerView.addPhotoButtonView.image.name", fallback: "plus.circle.fill")
        }
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
        internal enum Image {
          /// white
          internal static let color = L10n.tr("Localizable", "extension.mainView.emptyView.image.color", fallback: "white")
          /// photo
          internal static let name = L10n.tr("Localizable", "extension.mainView.emptyView.image.name", fallback: "photo")
        }
        internal enum Text {
          /// white
          internal static let foregroundColor = L10n.tr("Localizable", "extension.mainView.emptyView.text.foregroundColor", fallback: "white")
        }
      }
      internal enum MainHeaderTextView {
        /// Cделай свои подводные фотографии лучше вместе с нами!
        internal static let text = L10n.tr("Localizable", "extension.mainView.mainHeaderTextView.text", fallback: "Cделай свои подводные фотографии лучше вместе с нами!")
      }
    }
  }
  internal enum HeaderView {
    internal enum Body {
      /// blueDark
      internal static let color = L10n.tr("Localizable", "headerView.body.color", fallback: "blueDark")
    }
  }
  internal enum LanguageSettingView {
    internal enum Body {
      /// Localizable.strings
      ///   UnderWaterPhoto
      /// 
      ///   Created by Андрей Барсуков on 25.01.2024.
      internal static let color = L10n.tr("Localizable", "languageSettingView.body.color", fallback: "blueDark")
      internal enum Content {
        /// 
        internal static let additionalText = L10n.tr("Localizable", "languageSettingView.body.content.additionalText", fallback: "")
        internal enum Background {
          /// blue
          internal static let color = L10n.tr("Localizable", "languageSettingView.body.content.background.color", fallback: "blue")
        }
      }
      internal enum OnTapGesture {
        internal enum ListRowBackground {
          /// blue
          internal static let color = L10n.tr("Localizable", "languageSettingView.body.onTapGesture.listRowBackground.color", fallback: "blue")
        }
      }
    }
    internal enum ChangeSymbol {
      /// 
      internal static let `else` = L10n.tr("Localizable", "languageSettingView.changeSymbol.else", fallback: "")
      /// checkmark
      internal static let `if` = L10n.tr("Localizable", "languageSettingView.changeSymbol.if", fallback: "checkmark")
    }
  }
  internal enum LanguageSettingViewController {
    /// Язык приложения
    internal static let titleLabel = L10n.tr("Localizable", "languageSettingViewController.titleLabel", fallback: "Язык приложения")
    internal enum BackButton {
      internal enum Button {
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "languageSettingViewController.backButton.button.tintColor.name", fallback: "white")
        }
      }
      internal enum Image {
        /// back
        internal static let name = L10n.tr("Localizable", "languageSettingViewController.backButton.image.name", fallback: "back")
      }
    }
    internal enum TitleLabel {
      /// white
      internal static let colorName = L10n.tr("Localizable", "languageSettingViewController.titleLabel.colorName", fallback: "white")
    }
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
  internal enum MainView {
    internal enum Background {
      /// blue
      internal static let color = L10n.tr("Localizable", "mainView.background.color", fallback: "blue")
    }
  }
  internal enum MainViewModel {
    /// photo
    internal static let avatarImage = L10n.tr("Localizable", "mainViewModel.avatarImage", fallback: "photo")
    /// under@water.ru
    internal static let mail = L10n.tr("Localizable", "mainViewModel.mail", fallback: "under@water.ru")
    /// Александр
    internal static let userName = L10n.tr("Localizable", "mainViewModel.userName", fallback: "Александр")
  }
  internal enum ProcessViewController {
    internal enum BackButton {
      internal enum Image {
        /// chevron.left
        internal static let name = L10n.tr("Localizable", "processViewController.backButton.image.name", fallback: "chevron.left")
      }
      internal enum TintColor {
        /// white
        internal static let name = L10n.tr("Localizable", "processViewController.backButton.tintColor.name", fallback: "white")
      }
    }
    internal enum BottomSheetBackButton {
      internal enum Button {
        /// Назад
        internal static let title = L10n.tr("Localizable", "processViewController.bottomSheetBackButton.button.title", fallback: "Назад")
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "processViewController.bottomSheetBackButton.button.tintColor.name", fallback: "white")
        }
      }
    }
    internal enum BottomSheetSaveButton {
      internal enum Button {
        /// Сохранить
        internal static let title = L10n.tr("Localizable", "processViewController.bottomSheetSaveButton.button.title", fallback: "Сохранить")
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "processViewController.bottomSheetSaveButton.button.tintColor.name", fallback: "white")
        }
      }
    }
    internal enum ChangeToProcess {
      internal enum ProcessPhotoButton {
        /// Редактировать
        internal static let title = L10n.tr("Localizable", "processViewController.changeToProcess.processPhotoButton.title", fallback: "Редактировать")
      }
      internal enum ShareBarButtonItem {
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "processViewController.changeToProcess.shareBarButtonItem.tintColor.name", fallback: "white")
        }
      }
      internal enum TitleLabel {
        /// Редактирование
        internal static let text = L10n.tr("Localizable", "processViewController.changeToProcess.titleLabel.text", fallback: "Редактирование")
      }
    }
    internal enum FilterButton {
      internal enum Button {
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "processViewController.filterButton.button.tintColor.name", fallback: "white")
        }
        internal enum Title {
          /// trapezoid.and.line.vertical
          internal static let name = L10n.tr("Localizable", "processViewController.filterButton.button.title.name", fallback: "trapezoid.and.line.vertical")
        }
      }
    }
    internal enum HeaderView {
      internal enum View {
        internal enum BackgroundColor {
          /// blueDark
          internal static let name = L10n.tr("Localizable", "processViewController.headerView.view.backgroundColor.name", fallback: "blueDark")
        }
      }
    }
    internal enum HideLogoButton {
      internal enum Button {
        /// Убрать логотип
        internal static let title = L10n.tr("Localizable", "processViewController.hideLogoButton.button.title", fallback: "Убрать логотип")
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "processViewController.hideLogoButton.button.tintColor.name", fallback: "white")
        }
      }
      internal enum ButtonConfig {
        internal enum Image {
          /// xmark
          internal static let name = L10n.tr("Localizable", "processViewController.hideLogoButton.buttonConfig.image.name", fallback: "xmark")
        }
      }
    }
    internal enum ProcessBottomSheetView {
      internal enum View {
        internal enum BackgroundColor {
          /// blueDark
          internal static let name = L10n.tr("Localizable", "processViewController.processBottomSheetView.view.backgroundColor.name", fallback: "blueDark")
        }
      }
    }
    internal enum ProcessPhotoButton {
      internal enum Button {
        /// Изменить
        internal static let title = L10n.tr("Localizable", "processViewController.processPhotoButton.button.title", fallback: "Изменить")
        internal enum BackgroundColor {
          /// white
          internal static let name = L10n.tr("Localizable", "processViewController.processPhotoButton.button.backgroundColor.name", fallback: "white")
        }
        internal enum TintColor {
          /// blue
          internal static let name = L10n.tr("Localizable", "processViewController.processPhotoButton.button.tintColor.name", fallback: "blue")
        }
      }
    }
    internal enum SaveButton {
      internal enum Button {
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "processViewController.saveButton.button.tintColor.name", fallback: "white")
        }
      }
      internal enum Image {
        /// arrow.down.to.line
        internal static let name = L10n.tr("Localizable", "processViewController.saveButton.image.name", fallback: "arrow.down.to.line")
      }
    }
    internal enum SetupViewController {
      internal enum View {
        internal enum BackgroundColor {
          /// blue
          internal static let name = L10n.tr("Localizable", "processViewController.setupViewController.view.backgroundColor.name", fallback: "blue")
        }
      }
    }
    internal enum Slider {
      internal enum MaximumTrackTintColor {
        /// white
        internal static let name = L10n.tr("Localizable", "processViewController.slider.maximumTrackTintColor.name", fallback: "white")
      }
      internal enum MinimumTrackTintColor {
        /// blue
        internal static let name = L10n.tr("Localizable", "processViewController.slider.minimumTrackTintColor.name", fallback: "blue")
      }
      internal enum ThumbTintColor {
        /// white
        internal static let name = L10n.tr("Localizable", "processViewController.slider.thumbTintColor.name", fallback: "white")
      }
    }
    internal enum TitleLabel {
      internal enum Label {
        /// Изменение
        internal static let text = L10n.tr("Localizable", "processViewController.titleLabel.label.text", fallback: "Изменение")
        internal enum Textcolor {
          /// white
          internal static let name = L10n.tr("Localizable", "processViewController.titleLabel.label.textcolor.name", fallback: "white")
        }
      }
    }
  }
  internal enum SettingNavBarView {
    internal enum Body {
      internal enum HStack {
        internal enum VStack {
          internal enum Text {
            internal enum Mail {
              /// grey
              internal static let foregroundColor = L10n.tr("Localizable", "settingNavBarView.body.hStack.vStack.text.mail.foregroundColor", fallback: "grey")
            }
            internal enum Name {
              /// white
              internal static let foregroundColor = L10n.tr("Localizable", "settingNavBarView.body.hStack.vStack.text.name.foregroundColor", fallback: "white")
            }
          }
        }
      }
    }
  }
  internal enum SettingRowView {
    /// 
    internal static let quotes = L10n.tr("Localizable", "settingRowView.quotes", fallback: "")
    internal enum Body {
      internal enum VStack {
        internal enum Zstack {
          /// blue
          internal static let color = L10n.tr("Localizable", "settingRowView.body.vStack.Zstack.color", fallback: "blue")
          internal enum HStack {
            internal enum Image {
              internal enum Symbol {
                /// grey
                internal static let foregroundColor = L10n.tr("Localizable", "settingRowView.body.vStack.Zstack.hStack.image.symbol.foregroundColor", fallback: "grey")
              }
            }
            internal enum Text {
              internal enum AdditionalText {
                /// grey
                internal static let foregroundColor = L10n.tr("Localizable", "settingRowView.body.vStack.Zstack.hStack.text.additionalText.foregroundColor", fallback: "grey")
              }
              internal enum Setting {
                /// white
                internal static let foregroundColor = L10n.tr("Localizable", "settingRowView.body.vStack.Zstack.hStack.text.setting.foregroundColor", fallback: "white")
              }
            }
          }
        }
      }
    }
  }
  internal enum SettingsView {
    internal enum Body {
      internal enum OnTapGesture {
        internal enum ListRowBackground {
          /// blue
          internal static let color = L10n.tr("Localizable", "settingsView.body.onTapGesture.listRowBackground.color", fallback: "blue")
        }
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
          /// chevron.right
          internal static let symbol = L10n.tr("Localizable", "settingsViewModel.settings.id.0.symbol", fallback: "chevron.right")
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
  internal enum SubscriptionView {
    internal enum Body {
      internal enum Background {
        /// back
        internal static let color = L10n.tr("Localizable", "subscriptionView.body.background.color", fallback: "back")
      }
      internal enum ScalingHeaderScrollView {
        /// blueDark
        internal static let color = L10n.tr("Localizable", "subscriptionView.body.scalingHeaderScrollView.color", fallback: "blueDark")
      }
    }
  }
  internal enum SubscriptionViewController {
    /// Подписка
    internal static let titleLabel = L10n.tr("Localizable", "subscriptionViewController.titleLabel", fallback: "Подписка")
    internal enum BackButton {
      internal enum Button {
        internal enum TintColor {
          /// white
          internal static let name = L10n.tr("Localizable", "subscriptionViewController.backButton.button.tintColor.name", fallback: "white")
        }
      }
      internal enum Image {
        /// back
        internal static let name = L10n.tr("Localizable", "subscriptionViewController.backButton.image.name", fallback: "back")
      }
    }
    internal enum TitleLabel {
      internal enum Label {
        internal enum TextColor {
          /// white
          internal static let name = L10n.tr("Localizable", "subscriptionViewController.titleLabel.label.textColor.name", fallback: "white")
        }
      }
    }
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
