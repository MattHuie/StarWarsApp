import UIKit

class PeopleViewController: UIViewController {

    @IBOutlet weak var peopleTableView: UITableView!
    
    private var people = [PeopleInfo]() {
        didSet {
            DispatchQueue.main.async {
                self.peopleTableView.reloadData()
            }
        }
    }
    
    private let apiClient = PeopleAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        loadPeopleData()
    }
    
    func loadPeopleData() {
        apiClient.getPeople { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let data):
                self?.people = data
            }
        }
    }
}

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = peopleTableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleTableViewCell
        let cellToSet = people[indexPath.row]
        cell.nameLabel.text = cellToSet.name
        cell.birthYearLabel.text = "Born: \(cellToSet.birthYear)"
        cell.eyeColorLabel.text = "Eye Color: \(cellToSet.eyeColor)"
        cell.hairColorLabel.text = "Hair Color: \(cellToSet.hairColor)"
        cell.createdLabel.text = cellToSet.created
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
}
