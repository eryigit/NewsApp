
import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "cell"
    
    private let myImageView: UIImageView = {
        let myImageView = UIImageView()
        myImageView.contentMode = .scaleAspectFit
        myImageView.tintColor = .label
        return myImageView
    }()
    
    let newsTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        return title
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureImageView()
        configurateTitle()


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        func configureImageView() {
        self.contentView.addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.image = UIImage(named: "news")
            
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            myImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            myImageView.widthAnchor.constraint(equalToConstant: 80),
            myImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
    }
    
    func configurateTitle() {
        self.contentView.addSubview(newsTitle)
        
        NSLayoutConstraint.activate([
            newsTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            newsTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            newsTitle.leadingAnchor.constraint(equalTo: self.myImageView.trailingAnchor, constant: 15),
            newsTitle.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
    }
}
