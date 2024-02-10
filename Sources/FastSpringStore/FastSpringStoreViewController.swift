//  Copyright © 2024 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit
import WebKit

class FastSpringStoreViewController: NSViewController, WKNavigationDelegate {
    let storeURL: URL

    lazy var webView: DynamicAppearanceWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.suppressesIncrementalRendering = true
        if #available(OSX 10.11, *) {
            configuration.allowsAirPlayForMediaPlayback = false
        }

        let webView = DynamicAppearanceWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self

        if #available(OSX 10.11, *) {
            webView.allowsLinkPreview = false
        }

        return webView
    }()

    lazy var bridge = FastSpringStoreJavaScriptBridge() { itemsJSON in
        do {
            // Convert JSON back to data for decoding.
            let itemsData = try JSONSerialization.data(withJSONObject: itemsJSON, options: [])
            let decoder = JSONDecoder()
            let purchases = try decoder.decode([FastSpringPurchase].self, from: itemsData)
            print(purchases) // FIXME: stub
        } catch {
            assertionFailure("Decoding error: \(error)")
        }
    }

    required init(storeURL: URL) {
        self.storeURL = storeURL
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("not implemented") }

    override func loadView() {
        let view = NSView()
        defer { self.view = view }

        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(greaterThanOrEqualToConstant: minimumWindowSize.width).prioritized(.required),
            webView.heightAnchor.constraint(greaterThanOrEqualToConstant: minimumWindowSize.height).prioritized(.required),
        ])

        view.addSubview(webView)
        webView.constrainToSuperviewBounds()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        let urlRequest = URLRequest(url: storeURL)
        bridge.register(in: webView.configuration.userContentController)
        webView.load(urlRequest)
    }

    override func viewDidDisappear() {
        bridge.unregister(from: webView.configuration.userContentController)
        super.viewDidDisappear()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.updateContentForEffectiveAppearance()
    }
}
