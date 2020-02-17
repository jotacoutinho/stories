//
//  ExampleViewController.swift
//  Stories
//
//  Created by João Pedro De Souza Coutinho on 10/02/20.
//  Copyright © 2020 João Pedro De Souza Coutinho. All rights reserved.
//

import Foundation
import UIKit
import Stories

final class ExampleViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var storiesContainerView: StoriesCollectionView! {
        didSet {
            storiesContainerView.mainColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
            storiesContainerView.secondaryColor = UIColor(red: 170/255, green: 60/255, blue: 50/255, alpha: 1)
        }
    }
    
    // MARK: Variables
    private let transition = CircularScaleTransition()
    private var transitioningViewFrame: CGRect = CGRect(origin: .zero, size: .zero)
    weak var storiesDelegate: StoriesDelegate?
    var collectionData: [StoriesCollectionData] = []
    let exampleCollectionData = ExampleCollectionData()
    let exampleStoriesData = ExampleStoriesData()

    // MARK: Life Cycle
    init() {
        super.init(nibName: String(describing: "ExampleViewController"), bundle: .main)
        self.view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (index, _) in exampleCollectionData.imageUrls.enumerated() {
            collectionData.append(StoriesCollectionData(imageUrl: exampleCollectionData.imageUrls[index],
                                                        label: exampleCollectionData.labels[index]))
        }
        storiesContainerView.configure(storiesCollectionData: collectionData, delegate: self)
    }
}

// MARK: StoriesCollectionView
extension ExampleViewController: StoriesCollectionViewDelegate {
    func didSelectCell(index: Int, frame: CGRect) {
        let data = StoriesData(stories: exampleStoriesData.stories[index],
                               usernameLabel: exampleCollectionData.labels[index],
                               userImageUrl: exampleCollectionData.imageUrls[index])
        
        let viewController = StoriesViewController(transitioningDelegate: self,
                                                   storiesData: data,
                                                   mainColor: .white,
                                                   secondaryColor: UIColor(red: 170/255, green: 60/255, blue: 50/255, alpha: 1))
        storiesDelegate = viewController
        transitioningViewFrame = frame
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true, completion: {
            self.storiesDelegate?.didFinishOpeningStories()
        })
    }
}

// MARK: Transitioning Delegate
extension ExampleViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.viewColor = UIColor(red: 19/255, green: 19/255, blue: 19/255, alpha: 1)
        transition.triggeringFrame = transitioningViewFrame
        return transition
    }
}
