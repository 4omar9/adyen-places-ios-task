//
//  Place.swift
//
//
//
// TODO: Cleanup the data that I am not using
import Foundation

internal struct Place: Codable {
    let name: String
    let id: String
    let categories: [Category]
    let distance: Int
    let location: Location
    let geocodes: Geocodes

    var address: String {
        location.formattedAddress ??
        location.address ??
        ""
    }
    enum CodingKeys: String, CodingKey {
        case id = "fsq_id"
        case distance
        case categories
        case location
        case name
        case geocodes
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(categories, forKey: .categories)
        try container.encode(distance, forKey: .distance)
        try container.encode(location, forKey: .location)
        try container.encode(geocodes, forKey: .geocodes)
    }
}
extension Place {
    // MARK: - Category
    struct Category: Codable {
        let id: Int
        let name: String
    }

    // MARK: - Geocodes
    struct Geocodes: Codable {
        let main: Center
    }

    // MARK: - Center
    struct Center: Codable {
        let latitude: Double
        let longitude: Double
    }

    // MARK: - Location
    struct Location: Codable {
        let address: String?
        let country: String?
        let formattedAddress: String?
        let postcode: String?
        let region: String?
        
        enum CodingKeys: String, CodingKey {
            case address
            case country
            case formattedAddress = "formatted_address"
            case postcode
            case region
        }
    }
}
