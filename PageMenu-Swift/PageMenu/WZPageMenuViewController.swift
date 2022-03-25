//
//  WZPageMenuViewController.swift
//  AnyBit-swift
//
//  Created by kl on 2022/3/22.
//

import UIKit

protocol WZPageMenuViewControllerDelegate: AnyObject {
    func pageMenuControllerDidScrollTo(index: Int)
}

class WZPageMenuViewController: UIViewController {
    
    let cellIdentifier = "WZPageMenuViewControllerCellIdentifier"
    
    // MARK: - Property
    
    private var viewControllers: [UIViewController] = []
    private weak var delegate: WZPageMenuViewControllerDelegate?
    private var viewFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var currentIndex: Int = 0
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame viewFrame: CGRect,
         viewControllers: [UIViewController],
         delegate: WZPageMenuViewControllerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
        self.delegate = delegate
        self.viewFrame = viewFrame
        
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        view.addSubview(collectionView)
    }
    
    // MARK: - Public Method
    
    func scrollToIndex(_ index: Int) {
        collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .right, animated: false)
    }
    
    // MARK: - Lazy
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let frame = CGRect(x: self.viewFrame.origin.x,
                           y: self.viewFrame.origin.y,
                           width: self.viewFrame.size.width,
                           height: self.viewFrame.size.height)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundView = nil
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return cv
    }()
}

extension WZPageMenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScroll(scrollView)
    }
    
    private func handleScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.width
        let i = lrintf(Float(index))
        guard i != currentIndex else{ return }
        currentIndex = i
        
        if let d = delegate {
            d.pageMenuControllerDidScrollTo(index: i)
        }
    }
}

extension WZPageMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.viewFrame.size.width, height: self.viewFrame.size.height)
    }
}

extension WZPageMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let v = viewControllers[indexPath.row]
        for _v in cell.contentView.subviews{
            _v.removeFromSuperview();
        }

        v.removeFromParent()
        v.view.frame =  CGRect (x: 0, y: 0, width: self.viewFrame.size.width, height: self.viewFrame.size.height)
        
        self.addChild(v)
        cell.contentView.addSubview(v.view)
        return cell
    }
}
