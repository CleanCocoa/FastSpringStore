//  Copyright © 2024 Christian Tietze. All rights reserved. Distributed under the MIT License.

public struct FastSpringPurchase: Equatable {
    public struct License: Equatable {
        public enum LicenseType: String {
            case cocoaFob = "CocoaFob_license"
        }

        public let licenseCode: String
        public let licenseName: String
        public let licenseType: String

        public init(
            licenseCode: String,
            licenseName: String,
            licenseType: String
        ) {
            self.licenseCode = licenseCode
            self.licenseName = licenseName
            self.licenseType = licenseType
        }
    }

    public let product: String
    public let quantity: Int
    public let licenses: [License]

    public init(
        product: String,
        quantity: Int,
        licenses: [License]
    ) {
        self.product = product
        self.quantity = quantity
        self.licenses = licenses
    }
}

extension FastSpringPurchase.License: Decodable {
    enum CodingKeys: String, CodingKey {
        case licenseCode = "license", licenseName, licenseType
    }
}

extension FastSpringPurchase: Decodable {
    enum CodingKeys: String, CodingKey {
        case product, quantity, fulfillments
    }

    /// Uses to iterate over all `"fulfillment"` keys that contain instructions for the shop page and license codes to collect all ``License``s.
    struct DynamicFulfillmentsCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // Integer values not expected.
        var intValue: Int? = nil
        init?(intValue: Int) { nil }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let product = try container.decode(String.self, forKey: .product)
        let quantity = try container.decode(Int.self, forKey: .quantity)

        let fulfillmentsContainer = try container.nestedContainer(keyedBy: DynamicFulfillmentsCodingKeys.self, forKey: .fulfillments)
        var licenses: [License] = []
        for key in fulfillmentsContainer.allKeys {
            do {
                let decodedLicenses = try fulfillmentsContainer.decode([License].self, forKey: key)
                    .filter { $0.licenseType == License.LicenseType.cocoaFob.rawValue }
                licenses.append(contentsOf: decodedLicenses)
            } catch {
                continue
            }
        }

        self.init(
            product: product,
            quantity: quantity,
            licenses: licenses
        )
    }
}
