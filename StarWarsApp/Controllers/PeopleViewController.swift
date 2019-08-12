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
        let cell = peopleTableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)
        let peopleToSet = people[indexPath.row]
        cell.textLabel?.text = peopleToSet.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
