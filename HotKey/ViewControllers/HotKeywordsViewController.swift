// ViewControllers/HotKeywordsViewController.swift

import UIKit

class HotKeywordsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var displayedHotKeywords: [HotKeyword] = []
    
    private let backgroundColors = ["#16702e", "#005a51", "#996c00", "#5c0a6b", "#006d90", "#974e06", "#99272e", "#89221f", "#00345d"].map { UIColor(hexString: $0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        fetchHotKeywords()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HotKeywordCell.self, forCellWithReuseIdentifier: HotKeywordCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: .init(200)),
            collectionView.centerYAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 0.5)
        ])
    }
    
    private func fetchHotKeywords() {
        self.displayedHotKeywords = APIService.shared.generateMockData()
        Task { @MainActor in
            self.collectionView.reloadData()
        }
        
//        APIService.shared.fetchHotKeywords { [weak self] keywords in
//            guard let self = self, let keywords = keywords else {
//                Logger().log("error fetching hot keywords")
//                return
//            }
//            self.displayedHotKeywords = keywords
//            
//            Task { @MainActor in
//                self.collectionView.reloadData()
//            }
//        }
    }
}

// MARK: - UICollectionViewDataSource & DelegateFlowLayout

extension HotKeywordsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedHotKeywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let keyword = displayedHotKeywords[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotKeywordCell.identifier, for: indexPath) as? HotKeywordCell else {
            return UICollectionViewCell()
        }
        let backgroundColor = backgroundColors[indexPath.item % backgroundColors.count]
        cell.configure(with: keyword, backgroundColor: backgroundColor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let keyword = displayedHotKeywords[indexPath.item]
        let content = keyword.name
        
        let font = UIFont.systemFont(ofSize: 14)
        let maxWidth = collectionView.frame.width - 32

        let size = calculateTextSize(text: content, font: font, maxWidth: maxWidth)

        let height: CGFloat = 160
        let minWidth = max(size.width, 80)

        return CGSize(width: min(minWidth, maxWidth), height: height)
    }

    private func calculateTextSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let constraintSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        
        let boundingBox = text.boundingRect(with: constraintSize,
                                            options: .usesLineFragmentOrigin,
                                            attributes: attributes,
                                            context: nil)
        
        return CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.transform = CGAffineTransform.identity
                }
            }
        }
    }
}
