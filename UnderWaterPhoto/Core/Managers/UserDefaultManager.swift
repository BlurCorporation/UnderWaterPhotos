
import Foundation

protocol DefaultsManagerable {
	func saveObject(
		_ value: Any,
		for key: DefaultsKey
	)
	func fetchObject<T>(
		type: T.Type,
		for key: DefaultsKey
	) ->T?
	func deleteObject(for key: DefaultsKey)
}

final class DefaultsManager {
	private let defaults = UserDefaults.standard
}

extension DefaultsManager: DefaultsManagerable {
	
	func saveObject(
		_ value: Any,
		for key: DefaultsKey
	) {
		defaults.set(
			value,
			forKey: key.rawValue
		)
	}
	
	func fetchObject<T>(
		type: T.Type,
		for key: DefaultsKey
	) ->T? {
		return defaults.object(forKey: key.rawValue) as? T
	}
	
	func deleteObject(for key: DefaultsKey) {
		defaults.removeObject(forKey: key.rawValue)
	}
}

enum DefaultsKey: String {
	case isUserPremium
	case isUserAuth
	case userName
	case email
}
