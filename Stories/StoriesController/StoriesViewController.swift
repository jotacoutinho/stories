//
//  StoriesViewController.swift
//  MyTFT
//
//  Created by João Pedro De Souza Coutinho on 01/11/19.
//  Copyright © 2019 João Pedro De Souza Coutinho. All rights reserved.
//

import UIKit

public protocol StoriesDelegate: AnyObject {
    func didFinishOpeningStories()
}

public class StoriesViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var storiesContentView: UIView! {
        didSet {
            storiesContentView.backgroundColor = .clear
            storiesContentView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var contentImageView: UIImageView! {
        didSet {
            contentImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var headerImageView: UIImageView! {
        didSet {
            headerImageView.contentMode = .scaleAspectFill
            headerImageView.layer.cornerRadius = headerImageView.frame.height / 2
        }
    }
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var rewindView: UIView! {
        didSet {
            rewindView.backgroundColor = .clear
            rewindView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var forwardView: UIView! {
        didSet {
            forwardView.backgroundColor = .clear
            forwardView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var swipeView: UIView! {
        didSet {
            swipeView.backgroundColor = .clear
            swipeView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Variables
    private var firstRun: Bool = true
    private var stories: [String] = []
    private var usernameLabel: String = ""
    private var userImageUrl: String = ""
    private var mainColor: UIColor = .white
    private var secondaryColor: UIColor = .white
    private var originalFrame: CGRect
    private var storiesDuration: TimeInterval = 3
    private var indicatorTimer: Timer?
    private var contentTimer: Timer?
    private var currentStory: Int = 1
    private var currentStoryTime: TimeInterval = 0
    private let spacingSize: CGFloat = 8
    private var stackViewFreeSize: CGFloat = 0
    private var timerSize: CGFloat = 0
    
    // MARK: - Life cycle
    public init(transitioningDelegate: UIViewControllerTransitioningDelegate? = nil, stories: [String], usernameLabel: String, userImageUrl: String, mainColor: UIColor, secondaryColor: UIColor) {
        self.originalFrame = CGRect()
        super.init(nibName: "StoriesViewController", bundle: Bundle(for: type(of: self)))
        self.transitioningDelegate = transitioningDelegate
        self.stories = stories
        self.usernameLabel = usernameLabel
        self.userImageUrl = userImageUrl
        self.mainColor = mainColor
        self.secondaryColor = secondaryColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.originalFrame = CGRect()
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up first story
//        contentImageView.kf.setImage(with: URL(string: stories[0]))
        contentImageView.kf.setImage(with: URL(string: stories[0]), placeholder: nil, options: nil, progressBlock: nil) { (result) in
            switch result {
            case .success:
                if self.firstRun {
                    print("did set image")
                    self.firstRun = false
                    self.currentStoryTime = Date().timeIntervalSinceReferenceDate
                    self.configureTimers()
                }
                self.initializeTimer()
            case .failure(let error):
                print(error)
            }
        }
            
        headerImageView.kf.setImage(with: URL(string: userImageUrl))
        headerLabel.text = usernameLabel
        headerLabel.textColor = mainColor
        
        
        originalFrame = view.frame
        storiesContentView.frame = originalFrame
        stackViewFreeSize = originalFrame.width - 32 - (spacingSize * CGFloat(stories.count-1))
        timerSize = stackViewFreeSize / CGFloat(stories.count)
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGestureAnimation(sender:)))
        let rewindGesture = UITapGestureRecognizer(target: self, action: #selector(rewindStories(sender:)))
        let forwardGesture = UITapGestureRecognizer(target: self, action: #selector(forwardStories(sender:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pauseStory(sender:)))
        
        swipeView.addGestureRecognizer(swipeGesture)
        swipeView.addGestureRecognizer(longPressGesture)
        rewindView.addGestureRecognizer(rewindGesture)
        forwardView.addGestureRecognizer(forwardGesture)
       
        configureStoriesIndicators()
    }
    
    func configureStoriesIndicators() {
        stories.forEach { _ in
            let fadedIndicatorView = UIView()
            fadedIndicatorView.backgroundColor = secondaryColor.withAlphaComponent(0.5)
            fadedIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            
            fadedIndicatorView.widthAnchor.constraint(equalToConstant: timerSize).isActive = true
            fadedIndicatorView.heightAnchor.constraint(equalToConstant: stackView.frame.height).isActive = true
            fadedIndicatorView.clipsToBounds = true
            
            stackView.addArrangedSubview(fadedIndicatorView)
        }
    }
    
    @objc func storyIndicatorHelper(didSeek: Bool = false) {
        if currentStory < stories.count, currentStory >= 0 {
//            if didSeek {
//                configureIndicatorsForCurrentStory()
//            }
            currentStory += 1
            startStoryTimerIndicator()
            initializeTimer()
        } else if currentStory > stories.count {
            dismiss(animated: true, completion: nil)
        } else {
            indicatorTimer?.invalidate()
            contentTimer?.invalidate()
        }
    }
    
    func startStoryTimerIndicator() {
        let timerIndicatorView = UIView()
        
        timerIndicatorView.backgroundColor = secondaryColor
        timerIndicatorView.frame = CGRect(x: CGFloat(currentStory-1) * (timerSize + 8),
                                          y: 0,
                                          width: 0,
                                          height: 2)
        
        timerView.addSubview(timerIndicatorView)
        
        configureContentView()

        animateTimerIndicator(timerIndicatorView)
    }
    
    func animateTimerIndicator(_ timerIndicatorView: UIView) {
//        print(indicatorTimer?.timeInterval)
        let timeIntervalValue = Date().timeIntervalSinceReferenceDate - currentStoryTime
        let widthScaleFactor =  timeIntervalValue / storiesDuration //currentStoryTime > 0 ? CGFloat(currentStoryTime) : CGFloat(storiesDuration)
        let width = Int(widthScaleFactor) == 1 ? timerSize : timerSize * (1 - CGFloat(widthScaleFactor))
        let intervalOffset = Int(timeIntervalValue) == 3 ? 0 : timeIntervalValue
        UIView.animate(withDuration: storiesDuration - intervalOffset, animations: {
            timerIndicatorView.frame = CGRect(x: (CGFloat(self.currentStory-1)) * (self.timerSize + 8) + (self.timerSize - width),
                                              y: 0,
                                              width: width,
                                              height: 2)
        })
    }
    
    func configureIndicatorsForSkippedStories() {
        timerView.subviews.forEach({ subview in
            subview.removeFromSuperview()
        })
        
        //let timeIntervalValue = CGFloat(indicatorTimer?.timeInterval ?? 0)
        //let widthScaleFactor = currentStoryTime > 0 ? CGFloat(currentStoryTime) : CGFloat(storiesDuration)
        if currentStory > 1 {
            for story in 1...currentStory - 1 {
                //let width = story == currentStory - 1 ? timerSize * (CGFloat(storiesDuration) / widthScaleFactor) : timerSize
                let timerIndicatorView = UIView()
                timerIndicatorView.backgroundColor = secondaryColor
                timerIndicatorView.frame = CGRect(x: CGFloat(story - 1) * (timerSize + 8),
                                                  y: 0,
                                                  width: timerSize,
                                                  height: 2)
                timerView.addSubview(timerIndicatorView)
            }
        }
    }
    
    @objc func rewindStories(sender: UITapGestureRecognizer) {
        if sender.state == .ended, currentStory != 1 {
            indicatorTimer?.invalidate()
            contentTimer?.invalidate()
            
            currentStory -= 1
            configureIndicatorsForSkippedStories()
            
            if currentStory < 0 {
                dismiss(animated: true, completion: nil)
            } else {
                currentStoryTime = Date().timeIntervalSinceReferenceDate
                configureTimers()
            }
        }
    }
    
    @objc func forwardStories(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            indicatorTimer?.invalidate()
            contentTimer?.invalidate()
            
            currentStory += 1
            configureIndicatorsForSkippedStories()
            
            if currentStory > stories.count {
                dismiss(animated: true, completion: nil)
            } else {
                currentStoryTime = Date().timeIntervalSinceReferenceDate
                configureTimers()
            }
        }
    }
    
    @objc func pauseStory(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            currentStoryTime = indicatorTimer?.timeInterval ?? 0
            print(Int(Date().timeIntervalSinceReferenceDate))
            indicatorTimer?.invalidate()
        } else if sender.state == .ended {
            configureTimers()
        }
    }
    
    func configureContentView() {
        contentImageView.kf.setImage(with: URL(string: stories[currentStory-1]), placeholder: nil, options: nil, progressBlock: nil) { (result) in
            switch result {
            case .success:
//                if self.firstRun {
//                    print("did set image")
//                    self.firstRun = false
//                    self.currentStoryTime = Date().timeIntervalSinceReferenceDate
//                    self.configureTimers()
//                }
                self.initializeTimer()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func handleSwipeGestureAnimation(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: swipeView)
        if sender.state == .began {
            if translation.y < 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin = CGPoint(x: 0,
                                                     y: -self.originalFrame.maxY)
                }, completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
            } else if translation.y > 0 {
               dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleSwipeGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
        
            if translation.y < 0 {
                view.frame = CGRect(x: view.frame.minX, y: view.frame.maxY - translation.y, width: view.frame.width, height: view.frame.height)
            } else {
                
            }
        }
        else if sender.state == .ended {
            if view.frame.height < originalFrame.height / 2 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.storiesContentView.frame.origin = CGPoint(x: 0,
                                                     y: -self.originalFrame.maxY)
                }, completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = self.originalFrame
                })
            }
        }
    }
    
    func configureTimers() {
        startStoryTimerIndicator()
        
//        initializeTimer()
//        contentTimer = Timer.scheduledTimer(timeInterval: storiesDuration, target: self, selector: #selector(configureContentView), userInfo: nil, repeats: true)
    }
    
    func initializeTimer() {
        indicatorTimer?.invalidate()
        currentStoryTime = Date().timeIntervalSinceReferenceDate
        indicatorTimer = Timer.scheduledTimer(timeInterval: storiesDuration, target: self, selector: #selector(storyIndicatorHelper), userInfo: nil, repeats: false)
    }
}

extension StoriesViewController: StoriesDelegate {
    public func didFinishOpeningStories() {
//        currentStory = 1
    }
}
