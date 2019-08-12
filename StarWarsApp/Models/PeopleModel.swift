import Foundation

struct PeopleContainer: Codable {
    let results: [PeopleInfo]
}

struct PeopleInfo: Codable {
    let name: String
    let hairColor: String
    let eyeColor: String
    let birthYear: String
    let created: String
    enum CodingKeys: String, CodingKey {
        case name
        case hairColor = "hair_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case created
    }
}
