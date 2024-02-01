// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

public struct FastSpringStoreInfo: Equatable {
    public enum StoreMode: Equatable {
        case active, test
    }

    public let storeID: String

    public let productName: String
    public let productID: String

    public let storeMode: StoreMode

    public init(
        storeID: String,
        productName: String,
        productId: String,
        storeMode: StoreMode
    ) {
        self.storeID = storeID
        self.productName = productName
        self.productID = productId
        self.storeMode = storeMode
    }
}
