// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public struct FastSpringStoreInfo {
    let storeID: String
    
    let productName: String
    let productID: String
    
    let storeMode: String
    
    public init(
        storeID: String,
        productName: String,
        productId: String,
        storeMode: String
    ) {
        self.storeID = storeID
        self.productName = productName
        self.productID = productId
        self.storeMode = storeMode
    }
}
