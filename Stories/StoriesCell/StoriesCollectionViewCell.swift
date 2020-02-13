//
//  StoriesCollectionViewCell.swift
//  Instagram
//
//  Created by João Pedro De Souza Coutinho on 28/11/19.
//  Copyright © 2019 João Pedro De Souza Coutinho. All rights reserved.
//

import UIKit
import Kingfisher

class StoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var borderView: UIView! {
        didSet {
            borderView.layer.borderWidth = 2
            borderView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.contentMode = .scaleAspectFill
            userImageView.clipsToBounds = true
        }
        
    }
    
    @IBOutlet weak var addStoryButton: UIImageView! {
        didSet {
            addStoryButton.clipsToBounds = true
            addStoryButton.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var userNicknameLabel: UILabel! {
        didSet {
            userNicknameLabel.textAlignment = .center
            userNicknameLabel.textColor = .black
            userNicknameLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        borderView.layer.cornerRadius = borderView.frame.height/2
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        addStoryButton.layer.cornerRadius = addStoryButton.frame.width/2
    }
    
    func configure(imageUrl: String, label: String, userCell: Bool = false, mainColor: UIColor, secondaryColor: UIColor) {
        addStoryButton.isHidden = !userCell
        addStoryButton.backgroundColor = mainColor
        addStoryButton.tintColor = secondaryColor
        borderView.layer.borderColor = userCell ? UIColor.clear.cgColor: mainColor.cgColor
        userImageView.kf.setImage(with: URL(string: imageUrl))
        userNicknameLabel.text = label
        userNicknameLabel.textColor = mainColor
        
        // Forcing relayout
        setNeedsLayout()
        layoutIfNeeded()
    }

}
