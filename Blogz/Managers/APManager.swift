import Foundation
import Purchases
import StoreKit

final class APManager {
    static let shared = APManager()

    static let formatter = ISO8601DateFormatter()

    private var postEligibleViewDate: Date? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "postEligibleViewDate") else {
                return nil
            }
            return APManager.formatter.date(from: string)
        }
        set {
            guard let date = newValue else {
                return
            }
            let string = APManager.formatter.string(from: date)
            UserDefaults.standard.set(string, forKey: "postEligibleViewDate")
        }
    }

    private init() {}

    public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) {
        Purchases.shared.offerings { offerings, error in
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first,
                  error == nil else {
                completion(nil)
                return
            }

            completion(package)
        }
    }
}
