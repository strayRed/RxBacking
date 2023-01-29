//
//  CollectionViewCell.swift
//  ViewSizeCalculation_Example
//
//  Created by strayRed on 2023/1/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    lazy var contentLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func synchronizeWithState(_ state: Any?, at indexPath: IndexPath) {
        guard let state = state as? Model else { return }
        contentLabel.text = state.content
    }

}
