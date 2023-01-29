//
//  CollectionViewController.swift
//  RxBacking_Example
//
//  Created by strayRed on 2023/1/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxBacking

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var sections: [Section] = staticSections
    
    lazy var source: BehaviorRelay = .init(value: sections)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        return UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
    }()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        RxReloadCollectionViewBacking<Section>
            .init(parentObject: collectionView, shouldRetain: true)
            .reusableCell { _, _ in Reusable.collectionViewCell }
            .reusableSectionHeaderView { _, _ in Reusable.collectionViewHeaderFooter }
            .cellSizeConstraint { _, _ in .width((self.collectionView.bounds.width)) }
            .forwordObject(self)
            .dataSourceBinded(to: source.asObservable())
            .disposed(by: bag)
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 100)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
