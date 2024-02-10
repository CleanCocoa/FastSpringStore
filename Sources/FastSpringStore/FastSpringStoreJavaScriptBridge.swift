//  Copyright © 2024 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Foundation
import WebKit

typealias JSON = [String : Any]

class FastSpringStoreJavaScriptBridge {
    /// Avoids potential retain cycles between `WKUserContentController` and `FastSpringStoreEventHandler`.
    private class WeakProxy: NSObject, WKScriptMessageHandler {
        private weak var bridge: FastSpringStoreJavaScriptBridge?

        init(bridge: FastSpringStoreJavaScriptBridge) {
            super.init()
            self.bridge = bridge
        }

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard let messageName = MessageName(rawValue: message.name) else { return }
            bridge?.handleMessage(name: messageName, body: message.body)
        }
    }

    /// FastSpring embedded store messages we're interested in.
    enum MessageName: String, CaseIterable {
        /// Receives `data-data-callback`. That's the pipeline for everything that the Store Builder Library produces.
        ///
        /// The JSON object passed through the `data-data-callback`  is the entire object associated with the session. It contains all available products in the associated store, for example.
        ///
        /// > Note: Only register this in your embedded store HTML for testing, especially since this is quite noisy.
        ///
        /// - Documentation: <https://developer.fastspring.com/reference/callbacks#data-callback>
        /// - Online examples: <https://fastspringexamples.com/callback/data-data-callback/>
        case fastSpringDataReceived

        /// Receives `data-popup-webhook-received`. That's being used for completed purchases, but for nothing else.
        ///
        /// - Documentation: <https://developer.fastspring.com/reference/callbacks#popup-webhook-received-callback>
        /// - Online examples: <https://fastspringexamples.com/callback/data-popup-webhook-received/>
        case fastSpringPopupWebhookReceived
    }

    private lazy var proxy = WeakProxy(bridge: self)

    let purchaseEventHandler: ([JSON]) -> Void

    init(purchaseEventHandler: @escaping ([JSON]) -> Void) {
        self.purchaseEventHandler = purchaseEventHandler
    }

    func register(in userContentController: WKUserContentController) {
        let callbackInstallationScript = WKUserScript(
            source: """
function fsprg_dataDataCallback(data) {
  if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.\(MessageName.fastSpringDataReceived)) {
      window.webkit.messageHandlers.\(MessageName.fastSpringDataReceived).postMessage(data);
  }
}
function fsprg_dataPopupWebhookReceived(data) {
  if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.\(MessageName.fastSpringPopupWebhookReceived)) {
    window.webkit.messageHandlers.\(MessageName.fastSpringPopupWebhookReceived).postMessage(data);
  }
}
""",
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        userContentController.addUserScript(callbackInstallationScript)
        MessageName.allCases
            .map(\.rawValue)
            // Warning: creates a strong reference, so make sure you remove the handler again e.g. via `unregister(from:)` to be safe.
            .forEach { userContentController.add(proxy, name: $0) }
    }

    func unregister(from userContentController: WKUserContentController) {
        MessageName.allCases
            .map(\.rawValue)
            .forEach(userContentController.removeScriptMessageHandler(forName:))
    }

    /// - Parameters:
    ///   - name: Name of the message that was received.
    ///   - body: Allowed types are the same as `WKScriptMessage`'s: `NSNumber`, `NSString`, `NSDate`, `NSArray`, `NSDictionary`, and `NSNull`.
    func handleMessage(
        name messageName: MessageName,
        body: Any
    ) {
        switch messageName {
        case .fastSpringDataReceived:
            guard let jsonPayload = body as? JSON else { return }
            #if DEBUG
            print("Received data-data-callback: \(jsonPayload)")
            #endif

        case .fastSpringPopupWebhookReceived:
            guard let jsonPayload = body as? JSON else {
                assertionFailure("Data should be a JSON object representation")
                return
            }
            assert(jsonPayload["items"] != nil,
                   "Data should contain an `items` key")
            guard let items = jsonPayload["items"] as? [JSON] else {
                assertionFailure("`items` should be an object array")
                return
            }
            purchaseEventHandler(items)
        }
    }
}
