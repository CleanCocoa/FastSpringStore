//  Copyright © 2024 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import TrialLicense

public final class FastSpringStore: NSObject {
    public let storeURL: URL
    public let purchaseCallback: (License) -> Void

    lazy var windowController = FastSpringStoreWindowController(storeURL: storeURL)

    public init(
        storeURL: URL,
        licensePurchase: @escaping (License) -> Void
    ) {
        self.storeURL = storeURL
        self.purchaseCallback = licensePurchase
    }

    public func showStore(title: String) {
        windowController.title = title
        windowController.showWindow(self)
    }
}
