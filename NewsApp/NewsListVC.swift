
import UIKit
import Alamofire

class NewsListVC: UIViewController {
    
    var newsTitle = [String]()
    var newsPicture = [String]()
    var newsDetail = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.backgroundColor = .systemBackground
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return tableView
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["News - US", "News - TR"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News"
        view.backgroundColor = .systemBackground
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureSegmentControl()
        configureTableView()
        getNewsInfo(info: "us")

    }
    
    private func configureSegmentControl() {
        view.addSubview(segmentControl)
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            segmentControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc fileprivate func handleSegmentChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            newsTitle.removeAll()
            newsPicture.removeAll()
            newsDetail.removeAll()
            getNewsInfo(info: "us")
        case 1:
            newsTitle.removeAll()
            newsPicture.removeAll()
            newsDetail.removeAll()
            getNewsInfo(info: "tr")
        default:
            break
        }
        
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
   private func getNewsInfo(info: String) {
        AF.request("https://newsapi.org/v2/top-headlines?country=\(info)&apiKey=fdc8d7529c534dc19303dcef553347c1", method: .get).response { [self] response in
            guard let data = response.data else { return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String:Any]
                let newsArticle = jsonResponse!["articles"] as? [[String:Any]]
                for x in 0...newsArticle!.count-1 {
                    let newsTitle = newsArticle![x]["title"] as? String
                    let newsPicture = newsArticle![x]["urlToImage"] as? String ?? "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg"
                    let newsDetail = newsArticle![x]["description"] as? String ?? "Empty Description"
                    
                    self.newsTitle.append(newsTitle!)
                    self.newsPicture.append(newsPicture)
                    self.newsDetail.append(newsDetail)
                }
                
            }catch {
                print(error.localizedDescription)
            }
            tableView.reloadData()
        }
    }
    

}

extension NewsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell
        cell!.newsTitle.text = newsTitle[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = NewsDetailVC()
        detailVC.newsPicture = newsPicture[indexPath.row]
        detailVC.newsDetail = newsDetail[indexPath.row]
        present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let readAction = UIContextualAction(style: .normal, title: "Read") { _, _, comp in
            self.newsTitle.remove(at: indexPath.row)
            tableView.reloadData()
        }
        readAction.image = UIImage(systemName: "message.fill")
        return UISwipeActionsConfiguration(actions: [readAction])
    }

}
