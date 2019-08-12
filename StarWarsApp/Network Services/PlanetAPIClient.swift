import Foundation

class PlanetAPIClient {
    public func searchPlanet(onCompletion: @escaping (Result<[PlanetInfo], NewtworkError>) -> Void) {
        let endpoint = "https://swapi.co/api/planets"
        guard let url = URL(string: endpoint) else {
            onCompletion(.failure(.badURL))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onCompletion(.failure(.apiError(error)))
            } else if let data = data {
                do {
                    let planet = try JSONDecoder().decode(PlanetsContainer.self, from: data)
                    onCompletion(.success(planet.result))
                }
                catch {
                    onCompletion(.failure(.jsonDecodingError(error)))
                }
            }
        }
        task.resume()
    }
}

