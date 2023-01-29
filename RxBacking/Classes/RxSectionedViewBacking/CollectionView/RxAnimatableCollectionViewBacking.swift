//
//  RxAnimatableCollectionViewBacking.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/8.
//

import Foundation
import RxDataSources

open class RxAnimatableCollectionViewBacking<SectionModel: AnimatableSectionModelType>: RxCollectionViewBacking<SectionModel, RxCollectionViewSectionedAnimatedDataSource<SectionModel>> {
    
    public var animationConfiguration: () -> AnimationConfiguration = { .init() }
    
    open func animationConfiguration(_ animationConfiguration: @autoclosure @escaping () -> AnimationConfiguration) -> Self {
        self.animationConfiguration = animationConfiguration
        return self
    }
    
    open var decideViewTransition: RxCollectionViewSectionedAnimatedDataSource<SectionModel>.DecideViewTransition = { _, _, _ in .animated }
    
    open func decideViewTransition(_ decideViewTransition: @escaping RxCollectionViewSectionedAnimatedDataSource<SectionModel>.DecideViewTransition) -> Self {
        self.decideViewTransition = decideViewTransition
        return self
    }
    
    open override var dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionModel> {
        .init(animationConfiguration: animationConfiguration(), decideViewTransition: decideViewTransition, configureCell: configureCell, configureSupplementaryView: configureSupplementaryView, moveItem: moveItem, canMoveItemAtIndexPath: canMoveItemAtIndexPath)
    }
    
    override func metricIdentifier(kind: ListItemKind, indexPath: IndexPath) -> AnyHashable {
        switch kind {
        case .cell:
            return strongModel[indexPath].metricIdentity
        case .header, .footer:
            return strongModel[indexPath.section].metricIdentity
        }
    }
    
}
