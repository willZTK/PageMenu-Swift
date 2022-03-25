//
//  TableViewController.swift
//  PageMenu-Swift
//
//  Created by kl on 2022/3/25.
//

import UIKit

class TableViewController: UIViewController {
    
    // MARK: - Property
    
    private var viewFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    private let datas = ["个人信息", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址", "收货地址"]

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    init(frame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewFrame = frame
        view.addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lazy
    
    private lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: viewFrame.size.width, height: viewFrame.size.height)
        let view = UITableView(frame: frame, style: .plain)
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.estimatedRowHeight = 0
        view.estimatedSectionHeaderHeight = 0
        view.estimatedSectionFooterHeight = 0
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return view
    }()
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        cell.backgroundColor = indexPath.row % 2 == 0 ? .orange : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
