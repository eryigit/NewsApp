
import UIKit

class NewsDetailVC: UIViewController {
    
    var newsDetail : String?
    var newsPicture: String?
    
    private let detailText = UITextView()
    private let imageView = UIImageView()
    private let backBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func configureImageView(){
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        guard let newPicture = newsPicture else { return }
        guard let url = URL(string: newPicture) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data,_,_) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self!.imageView.image = UIImage(data: data)
            }
            
        }.resume()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureDetailText() {
        view.addSubview(detailText)
        detailText.translatesAutoresizingMaskIntoConstraints = false
        detailText.text = newsDetail
        detailText.font = .systemFont(ofSize: 20)
        detailText.textContainer.lineBreakMode = .byWordWrapping
        detailText.isScrollEnabled = false
        detailText.isEditable = false
        detailText.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NSLayoutConstraint.activate([
            detailText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            detailText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailText.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            detailText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
    }
    
    private func configureBackBtn() {
        view.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.configuration = .borderless()
        backBtn.configuration?.image = UIImage(systemName: "arrowshape.turn.up.backward")
        backBtn.configuration?.title = "Back"
        backBtn.addTarget(self, action: #selector(actionBack), for: .touchUpInside)

        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 19),
            backBtn.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -15),
            backBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 3),
        ])
    }
    
    @objc private func actionBack() {
        dismiss(animated: true)
    }
    
    private func setupUI() {
        configureImageView()
        configureBackBtn()
        configureDetailText()
    }

}
