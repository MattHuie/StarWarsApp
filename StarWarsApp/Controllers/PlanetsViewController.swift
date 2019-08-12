import UIKit

class PlanetsViewController: UIViewController {

    @IBOutlet weak var planetsTableView: UITableView!
    
    private var planetAPI = PlanetAPIClient()
    var planets = [PlanetInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.planetsTableView.reloadData()
            }
        }
    }
    
    var pageNumber = 1
    let dateFormatter = DateFormatter()
    let datePrint = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planetsTableView.dataSource = self
        planetsTableView.delegate = self
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        datePrint.dateFormat = "dd-MM-yyyy (HH:mm:ss)"
        loadPlanetsData(pageNumber: pageNumber)

    }
    
    private func loadPlanetsData(pageNumber: Int) {
        planetAPI.getPlanets(page: pageNumber) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let data):
                DispatchQueue.main.async {
                    self?.updateWithNewContent(morePlanets: data.results)
                }
            }
        }
    }
    
    private func updateWithNewContent(morePlanets: [PlanetInfo]) {
        let offset = self.planets.count
        self.planets += morePlanets
        var indexPaths = [IndexPath]()
        for i in 0..<morePlanets.count {
            indexPaths.append(IndexPath(row: offset + i, section: 0))
        }
        planetsTableView.performBatchUpdates({
            planetsTableView.insertRows(at: indexPaths, with: .automatic)
        }, completion: nil)
        
    }
    
}
extension PlanetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == planets.count - 1 {
            pageNumber += 1
            loadPlanetsData(pageNumber: pageNumber)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = planetsTableView.dequeueReusableCell(withIdentifier: "PlanetCell", for: indexPath) as? PlanetsTableViewCell else {return PlanetsTableViewCell()}
        let cellToSet = planets[indexPath.row]
        cell.planetNameLabel.text = cellToSet.name
        cell.planetClimateLabel.text = "Climate: \(cellToSet.climate.capitalized)"
        cell.planetPopulationLabel.text = "Population: \(cellToSet.population)"
        if let date = dateFormatter.date(from: cellToSet.created) {
            cell.planetCreatedLabel.text = ("Date Created: \(datePrint.string(from: date))")
        }
        cell.planetNameLabel.makeBorder()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
}
