//
//  WZPageMenuView.swift
//  AnyBit-swift
//
//  Created by kl on 2022/3/22.
//

import UIKit

protocol WZPageMenuViewDelegate: AnyObject {
    func pageMenuViewSelectedAtIndex(_ index: Int)
}

struct WZPageMenuTextAttribute {
    var normalColor: UIColor = .gray
    var selectedColor: UIColor = .black
    var backgroundColr: UIColor = .white
    
    var normalFont: UIFont = UIFont.systemFont(ofSize: 14.0)
    var selectedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    var isShowUnderline: Bool = true
    var underlineColor: UIColor = .orange
    var underlineWidth: CGFloat = 20.0
    var underlineHeight: CGFloat = 2.0
    var underlineBottomMargin: CGFloat = 5.0
    var underlineCornerRadiu: CGFloat = 1.0
    
    //menu的宽度是否相同
    var isSameWidth: Bool = true
    var sameWidth: CGFloat = 50.0
    var differentWidths: [CGFloat] = []
}

class WZPageMenuView: UIView {
    
    let cellIdentifier = "WZPageMenuCellIdentifier"
    
    // MARK: - Property
    
    private var titles: [String] = []
    private var currentIndex: Int = 0
    private weak var delegate: WZPageMenuViewDelegate?
    private var textAttribute = WZPageMenuTextAttribute()
    
    private var needScrollToCenterItemStartIndex = 0
    private var needScrollToCenterItemEndIndex = 0
    private var scrollContentOffsetX = 0.0

    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect,
                     titles: [String],
                     delegate: WZPageMenuViewDelegate? = nil,
                     textAttribute: WZPageMenuTextAttribute = WZPageMenuTextAttribute()) {
        self.init(frame: frame)
        
        self.titles = titles
        self.delegate = delegate
        self.textAttribute = textAttribute
        
        needScrollToCenterItemStartIndex = calculateNeedScrollToCenterItemStartIndex()
        needScrollToCenterItemEndIndex = calculateNeedScrollToCenterItemEndIndex()
        
        setupLayout()
    }
    
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubview(collectionView)
        
        if textAttribute.isShowUnderline {
            collectionView.addSubview(underline)
            
            var firstItemWidth = 0.0
            if textAttribute.isSameWidth {
                firstItemWidth = textAttribute.sameWidth
            }else {
                firstItemWidth = textAttribute.differentWidths[0] + 20
            }
            let underlineX = (firstItemWidth - textAttribute.underlineWidth) / 2.0
            let underlineW = textAttribute.underlineWidth
            let underlineH = textAttribute.underlineHeight
            let underlineY = frame.size.height - textAttribute.underlineBottomMargin - underlineH
            underline.frame = CGRect(x: underlineX,
                                     y: underlineY,
                                     width: underlineW,
                                     height: underlineH)
        }
    }
    
    // MARK: - Private
    
    private func calculateNeedScrollToCenterItemStartIndex() -> Int {
        let centerPointX = frame.size.width / 2
        
        var needScrollToCenterIndex = 0
        var sumCenterPointX = 0.0
        
        for i in 0..<titles.count {
            var width = 0.0;
            if textAttribute.isSameWidth {
                width = textAttribute.sameWidth
            }else {
                width = textAttribute.differentWidths[i] + 20
            }
            
            let itemCenterPointX = width / 2
            
            sumCenterPointX += itemCenterPointX
            
            if sumCenterPointX < centerPointX {
                needScrollToCenterIndex += 1
                sumCenterPointX += itemCenterPointX
            }else {
                break
            }
        }
        
        return needScrollToCenterIndex
    }
    
    private func calculateNeedScrollToCenterItemEndIndex() -> Int {
        let centerPointX = frame.size.width / 2
        
        var needScrollToCenterIndex = titles.count - 1
        var sumCenterPointX = 0.0
        
        for i in 0..<titles.count {
            var width = 0.0;
            if textAttribute.isSameWidth {
                width = textAttribute.sameWidth
            }else {
                width = textAttribute.differentWidths[titles.count - 1 - i] + 20
            }
            
            let itemCenterPointX = width / 2
            
            sumCenterPointX += itemCenterPointX
            
            if sumCenterPointX < centerPointX {
                needScrollToCenterIndex -= 1
                sumCenterPointX += itemCenterPointX
            }else {
                break
            }
        }
        
        return needScrollToCenterIndex
    }
    
    private func itemScrollToIndex(_ index: Int) {
        if index < needScrollToCenterItemStartIndex {
            // 滑动到起点
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else if index > needScrollToCenterItemEndIndex {
            // 滑动到终点
            let offsetX = collectionView.contentSize.width - frame.size.width
            collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }else {
            // 滑动到中央
            let currentCenterOffsetX = scrollContentOffsetX + frame.size.width / 2.0
            var itemCenterPointX = 0.0
            
            for i in 0...index {
                var width = 0.0;
                if textAttribute.isSameWidth {
                    width = textAttribute.sameWidth
                }else {
                    width = textAttribute.differentWidths[i] + 20
                }
                
                if i == index {
                    itemCenterPointX += width / 2.0
                }else {
                    itemCenterPointX += width
                }
            }
        
            let offsetX = scrollContentOffsetX - (currentCenterOffsetX - itemCenterPointX)
            collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
        if textAttribute.isShowUnderline {
            let underlineH = textAttribute.underlineHeight
            let underlineY = frame.size.height - textAttribute.underlineBottomMargin - underlineH
            var underlineCenterX = 0.0
            let underlineCenterY = underlineY + underlineH / 2.0

            for i in 0...index {
                var width = 0.0;
                if textAttribute.isSameWidth {
                    width = textAttribute.sameWidth
                }else {
                    width = textAttribute.differentWidths[i] + 20
                }

                if i == index {
                    underlineCenterX += width / 2.0
                }else {
                    underlineCenterX += width
                }
            }
            UIView.animate(withDuration: 0.2) {
                self.underline.center = CGPoint(x: underlineCenterX, y: underlineCenterY)
            }
        }
    }
    
    // MARK: - Public
    
    func moveItemToIndex(_ index: Int) {
        guard index != currentIndex else {
            return
        }
        currentIndex = index
        collectionView.reloadData()
        
        itemScrollToIndex(currentIndex)
    }
    
    // MARK: - lazy
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundView = nil
        cv.backgroundColor = .white
        cv.register(WZPageMenuCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return cv
    }()
    
    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = textAttribute.underlineColor
        view.layer.cornerRadius = textAttribute.underlineCornerRadiu
        view.layer.masksToBounds = true
        return view
    }()
}

extension WZPageMenuView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollContentOffsetX = scrollView.contentOffset.x
    }
}

extension WZPageMenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = 0.0;
        if textAttribute.isSameWidth {
            width = textAttribute.sameWidth
        }else {
            width = textAttribute.differentWidths[indexPath.row] + 20
        }
        return CGSize(width: width, height: frame.size.height)
    }
}

extension WZPageMenuView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: WZPageMenuCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? WZPageMenuCollectionViewCell
        if cell == nil {
            cell = WZPageMenuCollectionViewCell()
        }
        cell?.isHighlighted = false
        cell?.backgroundColor = .clear
        cell?.update(isCurrent: currentIndex == indexPath.row, text: titles[indexPath.row], textAttribute: textAttribute)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != currentIndex else {
            return
        }
        currentIndex = indexPath.row
        collectionView.reloadData()
        
        itemScrollToIndex(currentIndex)
        
        if let d = delegate {
            d.pageMenuViewSelectedAtIndex(currentIndex)
        }
    }
}
