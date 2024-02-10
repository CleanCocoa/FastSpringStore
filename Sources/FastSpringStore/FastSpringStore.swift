//  Copyright © 2024 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import TrialLicense

public final class FastSpringStore: NSObject {
    public let storeURL: URL
    public let purchaseCallback: (FastSpringStore, [FastSpringPurchase]) -> Void

    lazy var windowController = FastSpringStoreWindowController(
        storeURL: storeURL,
        purchaseCallback: { [unowned self] purchase in
            self.purchaseCallback(self, purchase)
        })

    public init(
        storeURL: URL,
        purchaseCallback: @escaping (FastSpringStore, [FastSpringPurchase]) -> Void
    ) {
        self.storeURL = storeURL
        self.purchaseCallback = purchaseCallback
    }

    public func showStore(title: String) {
        windowController.title = title
        windowController.showWindow(self)
    }

    public func closeWindow() {
        windowController.close()
    }
}
