//
//  UICollectionView+ItemSize.swift
//  RxBacking
//
//  Created by strayRed on 2021/10/7.
//

import Foundation

private var cellReferencesKey: Void?
private var headerFooterViewReferencesKey: Void?


extension UICollectionView {
    
    private var cellReferences: [AnyHashable: UICollectionViewCell] {
        set {
            objc_setAssociatedObject(self, &cellReferencesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &cellReferencesKey) as? [AnyHashable: UICollectionViewCell]) ?? [:]
        }
    }
    
    private var headerFooterViewReferences: [AnyHashable: UICollectionReusableView] {
        set {
            objc_setAssociatedObject(self, &headerFooterViewReferencesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &headerFooterViewReferencesKey) as? [AnyHashable: UICollectionReusableView]) ?? [:]
        }
    }
    
    
    private func makeCollectionViewCell(token: AnyReusableCell) -> UICollectionViewCell {
        if let cell = cellReferences[token.reuseIdentifier] {
            cell.prepareForReuse()
            return cell
        }
        let cell: UICollectionViewCell = token.makeView()
        //Using `reuseIdentifier` as the key to avoid unnecessary memory consumption.
        cellReferences[token.reuseIdentifier] = cell
        return cell
    }
    
    private func makeHeaderFooterView(token: AnyReusableView) -> UICollectionReusableView {
        if let view = headerFooterViewReferences[token.reuseIdentifier] {
            view.prepareForReuse()
            return view
        }
        let view: UICollectionReusableView = token.makeView()
        headerFooterViewReferences[token.reuseIdentifier] = view
        return view
    }
    
    func caculateItemSize(kind: ListItemKind, constraint: LayoutSizeConstraint?, indexPath: IndexPath, dataSource: ListItemSizingDataSource) -> CGSize? {
        let model: Any
        let item: ListItemStateSynchronizable & UIView
        let itemToken: ReusableViewToken
        switch kind {
        case .cell:
            guard let reusableCell = dataSource.reusableCell(at: indexPath) else { return nil }
            model = dataSource.sectionModelItem(at: indexPath)
            item = makeCollectionViewCell(token: reusableCell)
            itemToken = reusableCell
        case .header, .footer:
            let section = indexPath.section
            guard let resuableView = kind == .header ? dataSource.reusableSectionHeaderView(at: section) : dataSource.reusableSectionFooterView(at: section) else { return nil }
            model = dataSource.sectionModel(at: section)
            item = makeHeaderFooterView(token: resuableView)
            itemToken = resuableView
        }
        
        // If model or item has provided the height, just use it.
        if let heightProvider = model as? CollectionViewItemSizeProvidable ?? item as? CollectionViewItemSizeProvidable {
            if heightProvider.isNeedStateSynchronized {
                dataSource.synchronizeItem(item, withState: model, atIndexPath: indexPath, kind: kind)
            }
            return heightProvider.collectionViewItemSize(state: model, token: itemToken, collectionViewWidth: bounds.width)
        }
        
        dataSource.synchronizeItem(item, withState: model, atIndexPath: indexPath, kind: kind)
        
        if let constraint = constraint {
            let size = item.caculateAutoLayoutSize(sizeConstraint: constraint, style: .compressed)
            return size
        }
        return nil

    }
}
