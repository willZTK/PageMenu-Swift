//
//  NormalViewController.swift
//  PageMenu-Swift
//
//  Created by kl on 2022/3/25.
//

import UIKit

class NormalViewController: UIViewController {
    
    // MARK: - Property
    
    var backColor: UIColor = .white
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backColor
        view.addSubview(label)
    }
    
    // MARK: - Lazy
    
    private lazy var label: UILabel = {
        let la = UILabel()
        la.frame = CGRect(x: 0, y: 0, width: 300, height: 30)
        la.textAlignment = .center
        la.center = view.center
        la.text = "Hello world"
        la.textColor = .black
        la.font = .boldSystemFont(ofSize: 14)
        return la
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
