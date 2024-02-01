// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

extension FastSpringStoreInfo {
    public init?(
        fromPlist url: URL,
        storeMode: StoreMode = .active
    ) {
        guard let info = NSDictionary(contentsOf: url) as? [String : String] else { return nil }
        self.init(
            fromDictionary: info,
            storeMode: storeMode
        )
    }

    public init?(
        fromDictionary info: [String : String],
        storeMode: StoreMode = .active
    ) {
        guard let storeID = info["storeID"],
              let productName = info["productName"],
              let productID = info["productID"]
        else { return nil }

        self.init(
            storeID: storeID,
            productName: productName,
            productID: productID,
            storeMode: storeMode
        )
    }
}
