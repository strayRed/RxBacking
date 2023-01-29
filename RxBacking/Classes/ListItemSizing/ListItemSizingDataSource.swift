//
//  ListItemSizingDataSource.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/17.
//

import Foundation

enum ListItemKind: Hashable {
    case cell
    case header
    case footer
}

protocol ListItemSizingDataSource: AnyObject {
    
    func reusableCell(at indexPath: IndexPath) -> AnyReusableCell?
    func reusableSectionHeaderView(at section: Int) -> AnyReusableView?
    func reusableSectionFooterView(at section: Int) -> AnyReusableView?
    
    func metricIdentifier(kind: ListItemKind, indexPath: IndexPath) -> AnyHashable
    
    func synchronizeItem(_ item: ListItemStateSynchronizable, withState state: Any, atIndexPath indexPath: IndexPath, kind: ListItemKind)
    
    func item(at indexPath: IndexPath) -> Any
    func sectionModel(at section: Int) -> Any
}

