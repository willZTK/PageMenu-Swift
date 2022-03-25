//
//  WZPageMenuCollectionViewCell.swift
//  AnyBit-swift
//
//  Created by kl on 2022/3/23.
//

import UIKit
import SnapKit

class WZPageMenuCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(textLabel.font.lineHeight)
        }
    }
    
    // MARK: - Update
    
    func update(isCurrent: Bool, text: String, textAttribute: WZPageMenuTextAttribute) {
        textLabel.text = text
        
        if isCurrent {
            textLabel.textColor = textAttribute.selectedColor
            textLabel.font = textAttribute.selectedFont
        }else {
            textLabel.textColor = textAttribute.normalColor
            textLabel.font = textAttribute.normalFont
        }
        
        textLabel.snp.updateConstraints { make in
            make.height.equalTo(textLabel.font.lineHeight)
        }
    }
    
    // MARK: - Lazy
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
