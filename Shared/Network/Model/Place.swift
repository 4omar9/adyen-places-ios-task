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

    var address: String {
        location.formattedAddress ??
        location.address ??
        ""
    }
    enum CodingKeys: String, CodingKey {
        case name
        case id = "fsq_id"
        case categories
        case distance
        case location
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(categories, forKey: .categories)
        try container.encode(distance, forKey: .distance)
        try container.encode(location, forKey: .location)
    }
}
extension Place {
    // MARK: - Category
    struct Category: Codable {
        let id: Int
        let name: String
    }

    // MARK: - Location
    struct Location: Codable {
        let address: String?
        let formattedAddress: String?
        
        enum CodingKeys: String, CodingKey {
            case address
            case formattedAddress = "formatted_address"
        }
    }
}
