//
//  RxCollectionViewBacking.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/7.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import ViewSizeCalculation
import UIKit

open class RxCollectionViewBacking<SectionModel: SectionModelType, DataSource: CollectionViewSectionedDataSource<SectionModel> & RxCollectionViewDataSourceType>: Backing<UICollectionView>, _RxSectionedViewBackingType, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout where DataSource.Element == [SectionModel] {

    public typealias ParentObject = UICollectionView
    
    public typealias CellConfiguration = (_ cell: UICollectionViewCell, _ sectionItem: Model.Element.Item, _ indexPath: IndexPath) -> ()
    
    public typealias FlowLayoutHeaderFooterConfiguration = (_ view: UICollectionReusableView, _ sectionModel: Model.Element, _ section: Int) -> ()
    
    public typealias FlowLayoutCellSize = (_ sectionItem: Model.Element.Item, _ indexPath: IndexPath) -> (CGSize)
    
    public typealias FlowLayoutHeaderFooterSize = (_ sectionModel: Model.Element, _ section: Int) -> (CGSize)
    
    public typealias FlowLayoutCellSizeConstraint = (_ sectionItem: Model.Element.Item, _ indexPath: IndexPath) -> UIView.LayoutSizeConstraint
    
    public typealias FlowLayoutViewSizeConstraint = (_ sectionModel: Model.Element, _ section: Int) -> UIView.LayoutSizeConstraint

    open var parentDelegate: ParentObject.Delegate {
        self
    }
    
    open var dataSourceItems: DataSourceItems<[SectionModel]> {
        parentObject.rx.items(dataSource: dataSource)
    }
    
    open var reusableCell: SectionedViewTypealias.ReusableCell<Model.Element.Item>?
    
    open var reusableSectionHeaderView: SectionedViewTypealias.ReusableView<Model.Element>?
    
    open var reusableSectionFooterView: SectionedViewTypealias.ReusableView<Model.Element>?
    
    open var cellSize: FlowLayoutCellSize?
    
    open var headerSize: FlowLayoutHeaderFooterSize?
    
    open var footerSize: FlowLayoutHeaderFooterSize?
    
    open var cellSizeConstraint: FlowLayoutCellSizeConstraint?
    
    open var headerSizeConstraint: FlowLayoutViewSizeConstraint?
    
    open var footerSizeConstraint: FlowLayoutViewSizeConstraint?
    
    open var cellConfigurationBeforeSynchronized: CellConfiguration?
    
    open var cellConfigurationAfterSynchronized: CellConfiguration?
    
    open var headerConfigurationBeforeSynchronized: FlowLayoutHeaderFooterConfiguration?
    
    open var headerConfigurationAfterSynchronized: FlowLayoutHeaderFooterConfiguration?
    
    open var footerConfigurationBeforeSynchronized: FlowLayoutHeaderFooterConfiguration?
    
    open var footerConfigurationAfterSynchronized: FlowLayoutHeaderFooterConfiguration?
    
    open func reusableCell(_ reusableCell: @escaping SectionedViewTypealias.ReusableCell<Model.Element.Item>) -> Self {
        self.reusableCell = reusableCell
        return self
    }
    
    open func reusableSectionHeaderView(_ reusableSectionHeaderView: @escaping SectionedViewTypealias.ReusableView<Model.Element>) -> Self {
        self.reusableSectionHeaderView = reusableSectionHeaderView
        return self
    }
    
    open func reusableSectionFooterView(_ reusableSectionFooterView: @escaping SectionedViewTypealias.ReusableView<Model.Element>) -> Self {
        self.reusableSectionFooterView = reusableSectionFooterView
        return self
    }
    
    open func cellSize(_ cellSize: @escaping FlowLayoutCellSize) -> Self {
        self.cellSize = cellSize
        return self
    }
    
    open func headerSize(_ headerSize: @escaping FlowLayoutHeaderFooterSize) -> Self {
        self.headerSize = headerSize
        return self
    }
    
    open func footerSize(_ footerSize: @escaping FlowLayoutHeaderFooterSize) -> Self {
        self.footerSize = footerSize
        return self
    }
    
    open func cellSizeConstraint(_ cellSizeConstraint: @escaping FlowLayoutCellSizeConstraint) -> Self {
        self.cellSizeConstraint = cellSizeConstraint
        return self
    }
    
    open func headerSizeConstraint(_ headerSizeConstraint: @escaping FlowLayoutViewSizeConstraint) -> Self {
        self.headerSizeConstraint = headerSizeConstraint
        return self
    }
    
    open func footerSizeConstraint(_ footerSizeConstraint: @escaping FlowLayoutViewSizeConstraint) -> Self {
        self.footerSizeConstraint = footerSizeConstraint
        return self
    }
    
    open func cellConfigurationAfterSynchronized(_ cellConfigurationAfterSynchronized: @escaping CellConfiguration) -> Self {
        self.cellConfigurationAfterSynchronized = cellConfigurationAfterSynchronized
        return self
    }
    
    open func cellConfigurationBeforeSynchronized(_ cellConfigurationBeforeSynchronized: @escaping CellConfiguration) -> Self {
        self.cellConfigurationBeforeSynchronized = cellConfigurationBeforeSynchronized
        return self
    }
    
    open func headerConfigurationBeforeSynchronized(_ headerConfigurationBeforeSynchronized: @escaping FlowLayoutHeaderFooterConfiguration) -> Self {
        self.headerConfigurationBeforeSynchronized = headerConfigurationBeforeSynchronized
        return self
    }
    
    open func headerConfigurationAfterSynchronized(_ headerConfigurationAfterSynchronized: @escaping FlowLayoutHeaderFooterConfiguration) -> Self {
        self.headerConfigurationAfterSynchronized = headerConfigurationAfterSynchronized
        return self
    }
    
    open func footerConfigurationBeforeSynchronized(_ footerConfigurationBeforeSynchronized: @escaping FlowLayoutHeaderFooterConfiguration) -> Self {
        self.footerConfigurationBeforeSynchronized = footerConfigurationBeforeSynchronized
        return self
    }
    
    open func footerConfigurationAfterSynchronized(_ footerConfigurationAfterSynchronized: @escaping FlowLayoutHeaderFooterConfiguration) -> Self {
        self.footerConfigurationAfterSynchronized = footerConfigurationAfterSynchronized
        return self
    }
    
    open var moveItem: CollectionViewSectionedDataSource<SectionModel>.MoveItem =  { _, _, _ in () }
    
    open func moveItem(_ moveItem: @escaping CollectionViewSectionedDataSource<SectionModel>.MoveItem) -> Self {
        self.moveItem = moveItem
        return self
    }
    
    open var canMoveItemAtIndexPath: CollectionViewSectionedDataSource<SectionModel>.CanMoveItemAtIndexPath = { _, _ in false }
    
    open func canMoveItemAtIndexPath(_ canMoveItemAtIndexPath: @escaping CollectionViewSectionedDataSource<SectionModel>.CanMoveItemAtIndexPath) -> Self {
        self.canMoveItemAtIndexPath = canMoveItemAtIndexPath
        return self
    }
    
    open var dataSource: DataSource { abstractMethod() }
    

    open var configureCell: RxCollectionViewSectionedReloadDataSource<Model.Element>.ConfigureCell {
        return { [weak self] (dataSource, collectionView, indexPath, item) in
            guard let self = self, let reusableCell = self.reusableCell(at: indexPath) else { return .init() }
            let cell = collectionView.dequeue(reusableCell, for: indexPath)
            self.synchronizeItem(cell, withState: item, atIndexPath: indexPath, kind: .cell)
            return cell
        }
    }
    
    open var configureSupplementaryView: CollectionViewSectionedDataSource<SectionModel>.ConfigureSupplementaryView? {
        if self.reusableSectionHeaderView == nil && self.reusableSectionHeaderView == nil { return nil }
        return { [weak self] (dataSource, collectionView, kind, indexPath) in
            guard let self = self else { return .init() }
            let sectionModel = dataSource.sectionModels[indexPath.section]
            let view: UICollectionReusableView
            if kind == UICollectionView.elementKindSectionHeader, let reusableHeaderView = self.reusableSectionHeaderView, let reusableView = reusableHeaderView(sectionModel, indexPath.section) {
                view = collectionView.dequeue(reusableView, kind: .header, for: indexPath)
                self.synchronizeItem(view, withState: sectionModel, atIndexPath: indexPath, kind: .header)
            }
            
            else if kind == UICollectionView.elementKindSectionFooter, let reusableFooterView = self.reusableSectionHeaderView, let reusableView = reusableFooterView(sectionModel, indexPath.section) {
                view = collectionView.dequeue(reusableView, kind: .footer, for: indexPath)
                self.synchronizeItem(view, withState: sectionModel, atIndexPath: indexPath, kind: .footer)
            }
            else {  return UICollectionReusableView()  }
            return view
        }
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let headerSize = headerSize {
            return headerSize(strongModel[section], section)
        }
        
        if let headerSize = sizeProvider.makeSize(kind: .header, constraint: headerSizeConstraint?(strongModel[section], section), indexPath: .init(item: 0, section: section)) {
            return headerSize
        }
        
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let footerSize = sizeProvider.makeSize(kind: .footer, constraint: headerSizeConstraint?(strongModel[section], section), indexPath: .init(item: 0, section: section)) {
           return footerSize
        }
        
        if let footerSize = footerSize {
            return footerSize(strongModel[section], section)
        }
        
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let cellSize = cellSize {
            return cellSize(strongModel[indexPath], indexPath)
        }
        
        if let cellSize = sizeProvider.makeSize(kind: .cell, constraint: cellSizeConstraint?(strongModel[indexPath], indexPath), indexPath: indexPath) { return cellSize
            
        }
        
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
    }
    
    open func modelDidUpdate(model: inout [SectionModel]) { }
    
    
    //MARK: - Internal
    lazy var sizeProvider = RxCollectionViewCellSizeProvider(collectionView: parentObject, dataSource: self)
    
    func synchronizeItem(_ item: ListItemStateSynchronizable, withState state: Any, atIndexPath indexPath: IndexPath, kind: ListItemKind) {
        switch kind {
        case .cell:
            if let cell = item as? UICollectionViewCell, let item = state as? SectionModel.Item {
                cellConfigurationBeforeSynchronized?(cell, item, indexPath)
                cell.synchronizeWithState(item, at: indexPath)
                cellConfigurationAfterSynchronized?(cell, item, indexPath)
            }
        case .header:
            if let view = item as? UICollectionReusableView, let item = state as? SectionModel {
                headerConfigurationBeforeSynchronized?(view, item, indexPath.section)
                view.synchronizeWithState(item, at: indexPath)
                headerConfigurationAfterSynchronized?(view, item, indexPath.section)
            }
        case .footer:
            if let view = item as? UICollectionReusableView, let item = state as? SectionModel {
                footerConfigurationBeforeSynchronized?(view, item, indexPath.section)
                view.synchronizeWithState(item, at: indexPath)
                footerConfigurationAfterSynchronized?(view, item, indexPath.section)
            }
        }
    }
    
    func metricIdentifier(kind: ListItemKind, indexPath: IndexPath) -> AnyHashable {
        abstractMethod()
    }
}

