import Cocoa
import WebKit

extension NSAppearance {
    fileprivate var isDarkMode: Bool {
        if #available(macOS 10.14, *) {
            if self.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

/// > Note: The ``navigationDelegate`` should call ``updateContentForEffectiveAppearance()`` in `WKNavigationDelegate.webView(_:didFinish:)`.
public class DynamicAppearanceWebView: WKWebView {
    private var didInitialize = false

    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        didInitialize = true
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInitialize = true
    }

    public override func viewDidChangeEffectiveAppearance() {
        self.updateContentForEffectiveAppearance()
        if #available(macOS 10.14, *) {
            super.viewDidChangeEffectiveAppearance()
        }
    }

    public func updateContentForEffectiveAppearance() {
        guard didInitialize && self.isLoading == false else { return }

        let funcName = self.effectiveAppearance.isDarkMode
            ? "switchToDarkMode"
            : "switchToLightMode"

        // Call the named function only if it is implemented
        let switchScript = "if (typeof(\(funcName)) == 'function') { \(funcName)(); }"
        self.evaluateJavaScript(switchScript)
    }
}
