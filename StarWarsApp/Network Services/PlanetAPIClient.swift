import Foundation

// This class is to get the data from the API, using result type which helps to validate a .success or .failure against the call
class PlanetAPIClient {
    public func getPlanets(page: Int, onCompletion: @escaping (Result<PlanetsContainer, NewtworkError>) -> Void) {
        let endpoint = "https://swapi.co/api/planets/?page=\(page)"
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
                    let planets = try JSONDecoder().decode(PlanetsContainer.self, from: data)
                    onCompletion(.success(planets))
                }
                catch {
                    onCompletion(.failure(.jsonDecodingError(error)))
                }
            }
        }
        task.resume()
    }
}

