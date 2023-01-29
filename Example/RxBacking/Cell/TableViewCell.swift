//
//  TableViewCell.swift
//  RxBacking_Example
//
//  Created by strayRed on 2023/1/25.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxBacking
import ViewSizeExpandable

class TableViewCell: UITableViewCell, ReusableViewSizeExpandable {
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(label)
        return label
    }()
    
    private var pureContentText: String?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func synchronizeWithState(_ state: Any?, at indexPath: IndexPath) {
        guard let state = state as? Model else { return }
        pureContentText = state.content
    }
    
    
    //MARK: -ReusableViewSizeExpandable
    
    lazy var indicator: ExpansionEmptyIndicator = {
       let indicator = ExpansionEmptyIndicator()
        self.contentView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return indicator
    }()

    var expansionActivator: ExpansionActivator { indicator }
    
    var containerViewDefaultHeight: CGFloat? { 76 }
    
    func layoutContainerViewSubviews(expansionState: ExpansionState) {
        photoImageView.snp.removeConstraints()
        contentLabel.snp.removeConstraints()
        indicator.isUserInteractionEnabled = true
        switch expansionState {
        case .expanded:
            if let text = pureContentText {
                let attributedText = NSMutableAttributedString.init(string: text)
                let indicatorText = NSMutableAttributedString.init(string: " \nhide", attributes: [.foregroundColor: UIColor.red])
                attributedText.append(indicatorText)
                contentLabel.attributedText = attributedText
            }
            layoutContainerSubviewsWithoutExpansion()
        case .collapsed:
            if let text = pureContentText {
                let attributedText = NSMutableAttributedString.init(string: text)
                let indicatorText = NSMutableAttributedString.init(string: "show", attributes: [.foregroundColor: UIColor.red])
                attributedText.append(indicatorText)
                contentLabel.attributedText = attributedText
            }
            photoImageView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().offset(8)
                make.bottom.lessThanOrEqualToSuperview().offset(-8)
                make.height.width.equalTo(40)
            }
            contentLabel.snp.makeConstraints { make in
                make.top.equalTo(photoImageView)
                make.leading.equalTo(photoImageView.snp.trailing).offset(16)
                make.trailing.equalToSuperview().offset(-8)
                make.height.lessThanOrEqualTo(60)
                make.bottom.lessThanOrEqualToSuperview().offset(-8)
            }
        case .invalid:
            if let text = pureContentText {
                contentLabel.attributedText = .init(string: text)
            }
            indicator.isUserInteractionEnabled = false
            layoutContainerSubviewsWithoutExpansion()
        }
    }
    
    func layoutContainerSubviewsWithoutExpansion() {
        photoImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.height.width.equalTo(40)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView)
            make.leading.equalTo(photoImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
}
