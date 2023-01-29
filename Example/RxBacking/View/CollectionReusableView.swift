//
//  CollectionReusableView.swift
//  RxBacking_Example
//
//  Created by strayRed on 2023/1/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
    lazy var contentLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        return label
    }()
    
    
    override func synchronizeWithState(_ state: Any?, at indexPath: IndexPath) {
        guard let state = state as? Section else { return }
        contentLabel.text = state.title
        
    }
}
