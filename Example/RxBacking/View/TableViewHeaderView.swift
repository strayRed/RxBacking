//
//  TableViewHeaderView.swift
//  RxBacking_Example
//
//  Created by strayRed on 2023/1/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class TableViewHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var contentLabel: UILabel = {
      let label = UILabel()
        contentView.addSubview(label)
        label.numberOfLines = 0
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func synchronizeWithState(_ state: Any?, at indexPath: IndexPath) {
        guard let state = state as? Section else { return }
        contentLabel.text = state.title
    }
}
