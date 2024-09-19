import UIKit

public class HotKeywordCell: UICollectionViewCell {
    static let identifier = "HotKeywordCell"
    private var taskIdentifier: UUID?
    
    private let keywordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "imgPlaceholder")
        return imageView
    }()
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let keywordBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(keywordImageView)
        contentView.addSubview(keywordBackgroundView)
        keywordBackgroundView.addSubview(keywordLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            keywordImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            keywordImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            keywordImageView.widthAnchor.constraint(equalToConstant: 80),
            keywordImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            keywordBackgroundView.topAnchor.constraint(equalTo: keywordImageView.bottomAnchor, constant: 8),
            keywordBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            keywordBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            keywordBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            keywordLabel.topAnchor.constraint(equalTo: keywordBackgroundView.topAnchor, constant: 8),
            keywordLabel.bottomAnchor.constraint(equalTo: keywordBackgroundView.bottomAnchor, constant: -8),
            keywordLabel.leadingAnchor.constraint(equalTo: keywordBackgroundView.leadingAnchor, constant: 8),
            keywordLabel.trailingAnchor.constraint(equalTo: keywordBackgroundView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with keyword: HotKeyword, backgroundColor: UIColor) {
        keywordLabel.text = keyword.name
        keywordBackgroundView.backgroundColor = backgroundColor
        loadImage(from: keyword.icon, taskId: UUID())
    }
    
    private func loadImage(from urlString: String, taskId: UUID) {
        keywordImageView.image = UIImage(named: "imgPlaceholder")
        
        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
            keywordImageView.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            Logger().log("URL is invalid: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                Logger().log("Error downloading image: \(error.localizedDescription)")
                Task { @MainActor in
                    if self.taskIdentifier == taskId {
                        self.keywordImageView.image = UIImage(named: "imgPlaceholder")
                    }
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                Logger().log("Cannot create UIImage from data")
                Task { @MainActor in
                    if self.taskIdentifier == taskId {
                        self.keywordImageView.image = UIImage(named: "imgPlaceholder")
                    }
                }
                return
            }
            
            ImageCache.shared.setObject(image, forKey: urlString as NSString)
            
            Task { @MainActor in
                if self.taskIdentifier == taskId {
                    self.keywordImageView.image = image
                }
            }
        }.resume()
    }
}
