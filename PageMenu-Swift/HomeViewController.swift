//
//  HomeViewController.swift
//  PageMenu-Swift
//
//  Created by kl on 2022/3/25.
//

import UIKit

let WIDTH_SCREEN = UIScreen.main.bounds.width
let HEIGHT_SCREEN = UIScreen.main.bounds.height

let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let kNavigationBarHeight: CGFloat = 44.0
let kTopBarHeight = (kStatusBarHeight + kNavigationBarHeight)
let kHomeIndicatorHeight: CGFloat = (kStatusBarHeight > 20 ? 34.0 : 0)
let kTabbarHeight = (kHomeIndicatorHeight + 49.0)

class HomeViewController: UIViewController {
    
    // MARK: - Property
    
    private let categoryTitles = ["精选", "海淘", "创意生活", "送女票", "科技范", "送爸妈", "送基友", "送闺蜜", "送同事", "送宝贝", "设计感", "文艺范", "奇葩搞怪", "萌萌哒"]
    private var menuView: WZPageMenuView!
    private var pageMenuViewController: WZPageMenuViewController!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        setupMenuView()
        setupContentView()
    }
    
    private func setupMenuView() {
        var textAttribute = WZPageMenuTextAttribute()
        textAttribute.isSameWidth = false
        
        for item in categoryTitles {
            let width = calculateWidth(font: textAttribute.selectedFont, string: item)
            textAttribute.differentWidths.append(width)
        }
        
        menuView = .init(frame: CGRect(x: 0, y: 0, width: WIDTH_SCREEN, height: 44),
                         titles: categoryTitles,
                         delegate: self,
                         textAttribute: textAttribute)
        navigationItem.titleView = menuView
    }
    
    private func setupContentView() {
        let frame = CGRect(x: 0,
                           y: kTopBarHeight,
                           width: WIDTH_SCREEN,
                           height: HEIGHT_SCREEN - kTopBarHeight)
        let firstVC = NormalViewController()
        firstVC.backColor = .orange
        let viewControllers = [firstVC,
                               TableViewController(frame: frame),
                               NormalViewController(),
                               TableViewController(frame: frame),
                               NormalViewController(),
                               TableViewController(frame: frame),
                               NormalViewController(),
                               TableViewController(frame: frame),
                               NormalViewController(),
                               TableViewController(frame: frame),
                               NormalViewController(),
                               TableViewController(frame: frame),
                               NormalViewController(),
                               TableViewController(frame: frame)]
        pageMenuViewController = .init(frame: frame, viewControllers: viewControllers, delegate: self)
        self.addChild(pageMenuViewController)
        view.addSubview(pageMenuViewController.view)
    }
    
    // MARK: - Utils
    
    private func calculateWidth(font: UIFont, height: CGFloat, string: String) -> CGFloat {
        
        let str = string as NSString
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style.copy()]
        
        let rect = str.boundingRect(with: .init(width: 0, height: height), options: options, attributes: attributes, context: nil)
        
        return CGFloat(ceilf(Float(rect.width)))
    }
    
    private func calculateWidth(font: UIFont, string: String) -> CGFloat {
        return calculateWidth(font: font, height: font.lineHeight, string: string)
    }
}

extension HomeViewController: WZPageMenuViewDelegate {
    func pageMenuViewSelectedAtIndex(_ index: Int) {
        pageMenuViewController.scrollToIndex(index)
    }
}

extension HomeViewController: WZPageMenuViewControllerDelegate {
    func pageMenuControllerDidScrollTo(index: Int) {
        menuView.moveItemToIndex(index)
    }
}
