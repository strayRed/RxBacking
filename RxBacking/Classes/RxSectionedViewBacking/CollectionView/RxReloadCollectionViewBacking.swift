//
//  RxReloadCollectionViewBacking.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/7.
//

import Foundation
import RxDataSources

open class RxReloadCollectionViewBacking<SectionModel: SectionModelType>: RxCollectionViewBacking<SectionModel, RxCollectionViewSectionedReloadDataSource<SectionModel>>, ListIndePathSizedItemStorageContainer {

    open override var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel> {
        return .init(configureCell: configureCell, configureSupplementaryView: configureSupplementaryView, moveItem: moveItem, canMoveItemAtIndexPath: canMoveItemAtIndexPath)
    }
    
    var cellIndePathSizedItemStorage: ListIndePathSizedItemStorage {
        return sizeProvider
    }
    
    override func metricIdentifier(kind: ListItemKind, indexPath: IndexPath) -> AnyHashable {
        switch kind {
        case .cell:
            return indexPath
        case .header, .footer:
            return indexPath.section
        }
    }
}
