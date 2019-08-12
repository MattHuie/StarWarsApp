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
    
    private let peopleAPI = PeopleAPIClient()
    var pageNumber = 1
    let dateFormatter = DateFormatter()
    let datePrint = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        datePrint.dateFormat = "dd-MM-yyyy (HH:mm:ss)"
        loadPeopleData(pageNumber: pageNumber)
    }
    
    func loadPeopleData(pageNumber: Int) {
        peopleAPI.getPeople(page: pageNumber) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            case .success(let data):
                DispatchQueue.main.async {
                    self?.updateWithNewContent(morePeople: data.results)
                }
            }
        }
    }
    
    private func updateWithNewContent(morePeople: [PeopleInfo]) {
        let offset = self.people.count
        self.people += morePeople
        var indexPaths = [IndexPath]()
        for i in 0..<morePeople.count {
            indexPaths.append(IndexPath(row: offset + i, section: 0))
        }
        peopleTableView.performBatchUpdates({
            peopleTableView.insertRows(at: indexPaths, with: .automatic)
        }, completion: nil)
        
    }
    
}

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == people.count - 1 {
            pageNumber += 1
            loadPeopleData(pageNumber: pageNumber)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = peopleTableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleTableViewCell
        let cellToSet = people[indexPath.row]
        cell.nameLabel.text = cellToSet.name
        cell.eyeColorLabel.text = "Eye Color: \(cellToSet.eyeColor.capitalized)"
        cell.hairColorLabel.text = "Hair Color: \(cellToSet.hairColor.capitalized)"
        cell.birthYearLabel.text = "Born: \(cellToSet.birthYear)"
        if let date = dateFormatter.date(from: cellToSet.created) {
            cell.createdLabel.text = ("Date Created: \(datePrint.string(from: date))")
        }
        cell.nameLabel.makeBorder()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
