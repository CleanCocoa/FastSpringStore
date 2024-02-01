// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation
import FsprgEmbeddedStore  // for the store mode constants

extension FastSpringStoreInfo {
    public init?(fromPlist url: URL) {
        guard let info = NSDictionary(contentsOf: url) as? [String : String]
        else { return nil }
        self.init(fromDictionary: info)
    }

    public init?(fromDictionary info: [String : String]) {
        guard let storeID = info["storeID"],
              let productName = info["productName"],
              let productID = info["productID"]
        else { return nil }

#if DEBUG
        NSLog("Test Store Mode")
        let storeMode = kFsprgModeTest
#else
        let storeMode = kFsprgModeActive
#endif

        self.init(
            storeID: storeID,
            productName: productName,
            productId: productID,
            storeMode: storeMode
        )
    }
}
