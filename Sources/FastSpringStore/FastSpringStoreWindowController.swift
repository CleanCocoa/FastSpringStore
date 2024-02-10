//  Copyright © 2024 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

let minimumWindowSize = NSSize(width: 400, height: 300)

class FastSpringStoreWindowController: NSWindowController {
    let storeViewController: FastSpringStoreViewController

    var title: String = "" {
        didSet {
            self.window?.title = title
        }
    }

    required init(
        storeURL: URL,
        purchaseCallback: @escaping ([FastSpringPurchase]) -> Void
    ) {
        let storeViewController = FastSpringStoreViewController(storeURL: storeURL, purchaseCallback: purchaseCallback)
        self.storeViewController = storeViewController

        let window = NSWindow(contentViewController: storeViewController)
        window.titleVisibility = .visible
        window.titlebarAppearsTransparent = false
        window.styleMask.insert(.fullSizeContentView)
        window.title = title

        super.init(window: window)

        window.contentMinSize = minimumWindowSize
        window.setContentSize(.init(width: 500, height: 600))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("not implemented") }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        window?.center()
        window?.title = title
    }
}

