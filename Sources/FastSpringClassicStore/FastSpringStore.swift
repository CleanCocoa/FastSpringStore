// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation
import TrialLicense

public protocol FastSpringStoreDelegate: AnyObject {
    func didPurchaseLicense(license: License)
}

public class FastSpringStore {
    
    public let storeInfo: FastSpringStoreInfo
    
    public var storeDelegate: FastSpringStoreDelegate?
    
    public let storeWindowController: FastSpringStoreWindowController
    public lazy var storeController: FastSpringStoreController = FastSpringStoreController(storeInfo: self.storeInfo)
    
    public convenience init(storeInfo: FastSpringStoreInfo) {
        
        self.init(storeInfo: storeInfo, storeWindowController: FastSpringStoreWindowController())
    }
    
    public init(storeInfo: FastSpringStoreInfo, storeWindowController: FastSpringStoreWindowController) {
        
        self.storeWindowController = storeWindowController
        self.storeInfo = storeInfo
    }
    
    var didLoad = false
    
    public func showStore() {
        
        if didLoad {
            storeWindowController.reloadStore(self)
            return
        }
        
        storeWindowController.storeController = storeController
        storeWindowController.showWindow(self)
        storeWindowController.storeDelegate = storeDelegate
        didLoad = true
    }
    
    public func closeStore() {
        
        storeWindowController.close()
    }
}
