// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Cocoa
import FsprgEmbeddedStore
import TrialLicense

public class FastSpringStoreController: NSObject {
    public weak var storeDelegate: FastSpringStoreDelegate?
    public var orderConfirmationView: OrderConfirmationView?

    @objc dynamic public let storeController: FsprgEmbeddedStoreController
    public let storeInfo: FastSpringStoreInfo

    public init(storeInfo: FastSpringStoreInfo) {
        self.storeController = FsprgEmbeddedStoreController()
        self.storeInfo = storeInfo

        super.init()

        storeController.delegate = self
    }

    public func loadStore() {
        storeController.load(with: storeParameters)
    }

    public var storeParameters: FsprgStoreParameters {
        let storeParameters = FsprgStoreParameters()

        // Set up store to display the correct product
        storeParameters.orderProcessType = kFsprgOrderProcessDetail
        storeParameters.setStoreId(self.storeInfo.storeID,
                                   withProductId: self.storeInfo.productID)
        storeParameters.mode = self.storeInfo.storeMode

        // Pre-populate form fields with personal contact details
        let me = Me()

        storeParameters.contactFname = me.firstName
        storeParameters.contactLname = me.lastName
        storeParameters.contactCompany = me.organization

        storeParameters.contactEmail = me.primaryEmail
        storeParameters.contactPhone = me.primaryPhone

        return storeParameters
    }

    // MARK: Forwarding to FsprgEmbeddedStoreController

    func set(webView: WebView) {
        storeController.webView = webView
    }
}

extension FastSpringStoreController: FsprgEmbeddedStoreDelegate {
    public func didLoadStore(_ url: URL!) { }
    public func didLoadPage(_ url: URL!, of pageType: FsprgPageType) { }
    public func webView(_ sender: WebView!, didFailProvisionalLoadWithError error: Error!, for frame: WebFrame!) { }
    public func webView(_ sender: WebView!, didFailLoadWithError error: Error!, for frame: WebFrame!) { }
    // MARK: Order received

    public func didReceive(_ order: FsprgOrder!) {
        // Thanks Obj-C bridging without nullability annotations:
        // implicit unwrapped optionals are not safe
        guard let order = order
        else { return }

        if let license = license(fromOrder: order) {
            storeDelegate?.didPurchaseLicense(license: license)
        }
    }

    fileprivate func license(fromOrder order: FsprgOrder) -> License? {
        guard let items = order.orderItems as? [FsprgOrderItem],
              let license = items
            .filter(orderItemIsForThisApp)
            .compactMap(license(fromOrderItem:))
            .first
        else { return nil }

        return license
    }

    fileprivate func orderItemIsForThisApp(orderItem: FsprgOrderItem) -> Bool {
        guard let productName = orderItem.productName
        else { return false }

        let appName = storeInfo.productName
        return productName.hasPrefix(appName)
    }

    fileprivate func license(fromOrderItem orderItem: FsprgOrderItem) -> License? {
        guard let orderLicense = orderItem.license,
              let name = orderLicense.licenseName,
              let licenseCode = orderLicense.firstLicenseCode
        else { return nil }

        return License(name: name, licenseCode: licenseCode)
    }


    // MARK: Thank-you view

    public func view(withFrame frame: NSRect, for order: FsprgOrder!) -> NSView! {
        guard let orderConfirmationView = orderConfirmationView,
              let license = license(fromOrder: order)
        else { return nil }

        orderConfirmationView.displayLicenseCode(licenseCode: license.licenseCode)

        return orderConfirmationView
    }
}
