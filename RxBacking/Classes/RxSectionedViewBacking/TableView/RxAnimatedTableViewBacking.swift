//
//  AnimatedTableViewBacking.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/3.
//

import RxDataSources

 
open class RxAnimatableTableViewBacking<SectionModel: AnimatableSectionModelType>: RxTableViewBacking<SectionModel, RxTableViewSectionedAnimatedDataSource<SectionModel>> {
    
    public var animationConfiguration: () -> AnimationConfiguration = { .init() }
    
    open func animationConfiguration(_ animationConfiguration: @autoclosure @escaping () -> AnimationConfiguration) -> Self {
        self.animationConfiguration = animationConfiguration
        return self
    }
    
    open var decideViewTransition: RxTableViewSectionedAnimatedDataSource<SectionModel>.DecideViewTransition = { _, _, _ in .animated }
    
    open func decideViewTransition(_ decideViewTransition: @escaping RxTableViewSectionedAnimatedDataSource<SectionModel>.DecideViewTransition) -> Self {
        self.decideViewTransition = decideViewTransition
        return self
    }
    
    open override var dataSource: RxTableViewSectionedAnimatedDataSource<SectionModel> {
        .init(animationConfiguration: animationConfiguration(), decideViewTransition: decideViewTransition, configureCell: configureCell, titleForHeaderInSection: titleForHeaderInSection, titleForFooterInSection: titleForFooterInSection, canEditRowAtIndexPath: canEditRowAtIndexPath, canMoveRowAtIndexPath: canMoveRowAtIndexPath, sectionIndexTitles: sectionIndexTitles, sectionForSectionIndexTitle: sectionForSectionIndexTitle)
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

