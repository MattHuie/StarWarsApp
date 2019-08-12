import Foundation

struct PlanetsContainer: Codable {
    let results: [PlanetInfo]
}

struct PlanetInfo: Codable {
    let name: String
    let climate: String
    let population: String
    let created: String
}
