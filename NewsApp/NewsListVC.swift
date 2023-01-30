
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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News"
        view.backgroundColor = .systemBackground
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureTableView()
        getNewsInfo()

    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func getNewsInfo() {
        AF.request("https://newsapi.org/v2/top-headlines?country=us&apiKey=fdc8d7529c534dc19303dcef553347c1", method: .get).response { [self] response in
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

}
