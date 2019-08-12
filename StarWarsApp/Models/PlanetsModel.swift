import Foundation

struct PlanetsContainer: Codable {
    let result: [PlanetInfo]
}

struct PlanetInfo: Codable {
    let name: String
    let climate: String
    let population: String
    let created: String
}
