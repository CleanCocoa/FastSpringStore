# FastSpringStore

Interfaces with the FastSpring store to offer secure in-app purchase windows.

> [!TIP]
> For setup instructions of your own store and app preparation with FastSpring, have a look at my book [_Make Money Outside the Mac App Store_](https://christiantietze.de/books/make-money-outside-mac-app-store-fastspring/).


## Installation

### Swift Package Manager

```swift
dependencies: [
  .package(url: "https://github.com/CleanCocoa/FastSpringStore.git", .upToNextMajor(from: Version(1, 0, 0))),
]
```

Add package depencency via Xcode by using this URL: `https://github.com/CleanCocoa/FastSpringStore.git`

## Usage

You need your FastSpring store identifier and your product identifier. Both can be copied from [the store backend.](https://app.fastspring.com) With these, you populate the store configuration:

```swift
let storeInfo = FastSpringStoreInfo(
  storeID: "your-fastspring-store-id",
  productName: "Best Mac App",
  productID: "best-mac-app",
  storeMode: .test  // Switch to .active in production
)
FastSpringStore(storeInfo: storeInfo).showStore()
```

### Complete store example

This class ties together initializing the store and then reacts to completed orders.

```swift
class PurchaseLicense {
    let store: FastSpringStore

    init() {
        let storeInfo = FastSpringStoreInfo(
          storeID: "your-fastspring-store-id",
          productName: "Best Mac App",
          productID: "best-mac-app",
          storeMode: .test  // Switch to .active in production
        )
        self.store = FastSpringStore(storeInfo: storeInfo)
    }

    func showStore() {
        store.delegate = self
        store.showStore()
    }
}

extension PurchaseLicense: FastSpringStoreDelegate {
    func didPurchaseLicense(license: License) {
        store.closeStore()
        // Unlock app with valid License code
    }
}
```

## License

Copyright (c) 2015 by [Christian Tietze](https://christiantietze.de/). Distributed under the MIT License. See the LICENSE file for details.
