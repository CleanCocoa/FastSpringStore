// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public struct FastSpringStoreInfo {
    
    let storeId: String
    
    let productName: String
    let productId: String
    
    let storeMode: String
    
    init(storeId: String, productName: String, productId: String, storeMode: String) {
        
        self.storeId = storeId
        self.productName = productName
        self.productId = productId
        self.storeMode = storeMode
    }
}
