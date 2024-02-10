//  Copyright © 2024 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
import FastSpringStore

/// Sort helper.
func licenseNameAsc(lhs: FastSpringPurchase.License, rhs: FastSpringPurchase.License) -> Bool {
    return lhs.licenseName < rhs.licenseName
}

final class FastSpringPurchaseTests: XCTestCase {
    static let purchaseJSONString = """
    {
        "irrelevant key": "irrelevant value",
        "quantity": 1,
        "product": "The Product Name",
        "fulfillments": {
            "instructions": "User-facing text for rendition",
            "product_license_0": [
                {
                    "license": "THE_LICENSE_CODE_0",
                    "licenseName": "Foo Bar",
                    "licenseType": "CocoaFob_license"
                }
            ],
            "product_license_1": [
                {
                    "license": "THE_LICENSE_CODE_1",
                    "licenseName": "Fizz Buzz",
                    "licenseType": "unknown license"
                }
            ],
            "totally_different_key": [
                {
                    "license": "THE_LICENSE_CODE_2",
                    "licenseName": "Buzz McFizz",
                    "licenseType": "CocoaFob_license"
                }
            ]
        }
    }
    """

    func testFastSpringPurchaseDecoding() throws {
        let jsonData = FastSpringPurchaseTests.purchaseJSONString.data(using: .utf8)!
        let decoder = JSONDecoder()

        let purchase = try decoder.decode(FastSpringPurchase.self, from: jsonData)

        XCTAssertEqual(purchase.product, "The Product Name")
        XCTAssertEqual(purchase.quantity, 1)

        let expectedLicense0 = FastSpringPurchase.License(licenseCode: "THE_LICENSE_CODE_0", licenseName: "Foo Bar", licenseType: "CocoaFob_license")
        // `product_license_1` is of unknown type and should be ignored
        let expectedLicense2 = FastSpringPurchase.License(licenseCode: "THE_LICENSE_CODE_2", licenseName: "Buzz McFizz", licenseType: "CocoaFob_license")
        let expectedLicenses = [expectedLicense0, expectedLicense2].sorted(by: licenseNameAsc)
        let actualLicenses = purchase.licenses.sorted(by: licenseNameAsc)
        XCTAssertEqual(actualLicenses, expectedLicenses)
    }
}
