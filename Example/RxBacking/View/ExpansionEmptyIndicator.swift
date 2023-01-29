//
//  ExpansionEmptyIndicator.swift
//  RxBacking_Example
//
//  Created by strayRed on 2023/1/27.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import ViewSizeExpandable

class ExpansionEmptyIndicator: UIView, ExpansionIndicator {
    func expansionStateDidChanged(expansionState: ExpansionState) { }
    let bag = DisposeBag()
    init() {
        super.init(frame: .zero)
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        tap.rx.event.bind { [weak self] pan in
            if pan.state == .ended {
                self?.toggleExpansionState()
            }
        }.disposed(by: bag)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
