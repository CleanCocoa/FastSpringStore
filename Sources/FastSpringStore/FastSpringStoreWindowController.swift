// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Cocoa
import FsprgEmbeddedStore
import WebKit

public class OrderConfirmationView: NSView {
    @IBOutlet public var licenseCodeTextField: NSTextField!

    public func displayLicenseCode(licenseCode: String) {

        licenseCodeTextField.stringValue = licenseCode
    }
}

fileprivate extension NSNib.Name {
    static var fastSpringStoreWindow: NSNib.Name { return "FastSpringStoreWindowController" }
}

public class FastSpringStoreWindowController: NSWindowController {
    public required init() {
        super.init(window: nil)
        Bundle.module.loadNibNamed(.fastSpringStoreWindow, owner: self, topLevelObjects: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet public var webView: WebView!
    @IBOutlet public var orderConfirmationView: OrderConfirmationView!

    @IBOutlet public var backButton: NSButton!
    @IBOutlet public var forwardButton: NSButton!
    @IBOutlet public var reloadButton: NSButton!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!

    @objc dynamic public var storeController: FastSpringStoreController!

    public var storeDelegate: FastSpringStoreDelegate? {
        get { storeController.storeDelegate }
        set { storeController.storeDelegate = newValue }
    }

    public override func showWindow(_ sender: Any?) {
        super.showWindow(sender)

        storeController.set(webView: webView)
        storeController.loadStore()
        storeController.orderConfirmationView = orderConfirmationView

        loadingIndicator.startAnimation(self)
    }

    @IBAction public func reloadStore(_: AnyObject) {
        storeController.loadStore()
    }
}
