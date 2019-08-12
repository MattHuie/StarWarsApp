import Foundation

class PeopleAPIClient {
    public func getPeople(page: Int, onCompletion: @escaping (Result<PeopleContainer, NewtworkError>) -> Void) {
        let endpoint = "https://swapi.co/api/people/?page=\(page)"
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
                    let people = try JSONDecoder().decode(PeopleContainer.self, from: data)
                    onCompletion(.success(people))
                }
                catch {
                    onCompletion(.failure(.jsonDecodingError(error)))
                }
            }
        }
        task.resume()
    }
}
