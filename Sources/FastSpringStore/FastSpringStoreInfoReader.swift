// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation
import FsprgEmbeddedStore

public class FastSpringStoreInfoReader {
    
    public static func defaultStoreInfo() -> FastSpringStoreInfo? {
        
        guard let url = Bundle.main.url(forResource: "FastSpringCredentials", withExtension: "plist")
            else { return nil }
            
        return storeInfo(fromUrl: url)
    }
    
    public static func storeInfo(fromUrl url: URL) -> FastSpringStoreInfo? {
        
        guard let info = NSDictionary(contentsOf: url) as? [String : String]
            else { return nil }
            
        return storeInfo(fromDictionary: info)
    }
    
    public static func storeInfo(fromDictionary info: [String : String]) -> FastSpringStoreInfo? {
        
        guard let storeId = info["storeId"],
            let productName = info["productName"],
            let productId = info["productId"]
            else { return nil }
                
        #if DEBUG
            NSLog("Test Store Mode")
            let storeMode = kFsprgModeTest
        #else
            NSLog("Active Store Mode")
            let storeMode = kFsprgModeActive
        #endif
        
        return FastSpringStoreInfo(storeId: storeId, productName: productName, productId: productId, storeMode: storeMode)
    }
}
