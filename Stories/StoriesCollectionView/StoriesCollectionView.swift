//
//  StoriesCollectionView.swift
//  Stories
//
//  Created by João Pedro De Souza Coutinho on 11/02/20.
//  Copyright © 2020 João Pedro De Souza Coutinho. All rights reserved.
//

import UIKit

public class StoriesCollectionView: UIView {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = .clear
            collectionView.clipsToBounds = false
            collectionView.register(UINib(nibName: "StoriesCollectionViewCell",
                                          bundle: Bundle(for: StoriesCollectionView.self)),
                                    forCellWithReuseIdentifier: "storiesCollectionViewCell")
        }
    }
    
    // MARK: - Variables
    private var viewContent: UIView!
    private weak var delegate: StoriesCollectionViewDelegate?
    private var padding: CGFloat = 8
    private var storiesCollectionData: [StoriesCollectionData]?
    public var mainColor: UIColor = .black
    public var secondaryColor: UIColor = .red
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "StoriesCollectionView", bundle: bundle)
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        viewContent = nibView
        viewContent.clipsToBounds = true
        viewContent.backgroundColor = .clear
        viewContent.frame = bounds
        viewContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(viewContent)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    public func configure(storiesCollectionData: [StoriesCollectionData], delegate: StoriesCollectionViewDelegate? = nil) {
        self.delegate = delegate
        self.storiesCollectionData = storiesCollectionData
        collectionView.reloadData()
    }
    
    private func configureLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 0.75 * (viewContent.frame.height - padding), height: viewContent.frame.height - padding)
        layout.sectionInset = UIEdgeInsets(top: padding, left: 2 * padding, bottom: 0, right: padding)
        layout.minimumInteritemSpacing = 4 * padding
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
}

// MARK: - UICollectionViewDataSource
extension StoriesCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storiesCollectionData?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storiesCollectionViewCell", for: indexPath) as? StoriesCollectionViewCell
        
        cell?.configure(imageUrl: storiesCollectionData?[indexPath.item].imageUrl ?? "",
                        label: storiesCollectionData?[indexPath.item].label ?? "",
                        userCell: indexPath.item == 0,
                        mainColor: mainColor,
                        secondaryColor: secondaryColor)
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension StoriesCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storiesCollectionViewCell", for: indexPath) as? StoriesCollectionViewCell else { return }
        let frame = CGRect(x: cell.frame.minX, y: cell.frame.midY, width: cell.frame.width, height: cell.frame.width)
        delegate?.didSelectCell(index: indexPath.item, frame: frame)
    }
}
