//
//  RxReloadTableViewBacking.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/3.
//

import RxDataSources


open class RxReloadTableViewBacking<SectionModel: SectionModelType>: RxTableViewBacking<SectionModel, RxTableViewSectionedReloadDataSource<SectionModel>>, ListIndePathSizedItemStorageContainer {

    open override var dataSource: RxTableViewSectionedReloadDataSource<SectionModel> {
        .init(configureCell: configureCell, titleForHeaderInSection: titleForHeaderInSection, titleForFooterInSection: titleForFooterInSection, canEditRowAtIndexPath: canEditRowAtIndexPath, canMoveRowAtIndexPath: canMoveRowAtIndexPath, sectionIndexTitles: sectionIndexTitles, sectionForSectionIndexTitle: sectionForSectionIndexTitle)
    }
    
    var cellIndePathSizedItemStorage: ListIndePathSizedItemStorage {
        return heightProvider
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
