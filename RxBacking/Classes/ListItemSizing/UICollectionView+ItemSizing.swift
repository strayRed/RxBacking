//
//  UICollectionView+ItemSizing.swift
//  RxBacking
//
//  Created by strayRed on 2021/10/7.
//

import Foundation

private var cellReferencesKey: Void?
private var headerViewReferencesKey: Void?
private var footerViewReferencesKey: Void?

extension UICollectionView {
    
    private var cellReferences: [AnyHashable: UICollectionViewCell] {
        set {
            objc_setAssociatedObject(self, &cellReferencesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &cellReferencesKey) as? [AnyHashable: UICollectionViewCell]) ?? [:]
        }
    }
    
    private var headerViewReferences: [AnyHashable: UICollectionReusableView] {
        set {
            objc_setAssociatedObject(self, &headerViewReferencesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &headerViewReferencesKey) as? [AnyHashable: UICollectionReusableView]) ?? [:]
        }
    }
    
    private var footerViewReferences: [AnyHashable: UICollectionReusableView] {
        
        set {
            objc_setAssociatedObject(self, &footerViewReferencesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &footerViewReferencesKey) as? [AnyHashable: UICollectionReusableView]) ?? [:]
        }
    }
    
    private func makeCollectionViewCell(from reusableCell: AnyReusableCell, at indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = cellReferences[reusableCell.reuseIdentifier] {
            cell.prepareForReuse()
            return cell
        }
        let cell = reusableCell.nib == nil ? castOrFatalError(reusableCell.type.init(frame: .zero)) : dequeue(reusableCell, for: indexPath)
        //Using `reuseIdentifier` as the key to avoid unnecessary memory consumption.
        cellReferences[reusableCell.reuseIdentifier] = cell

        return cell
    }
    
    private func makeHeaderView(from reusableView: AnyReusableView, at section: Int) -> UICollectionReusableView {
        if let view = headerViewReferences[reusableView.reuseIdentifier] {
            view.prepareForReuse()
            return view
        }
        let view = dequeue(reusableView, kind: .header, for: .init(item: 0, section: section))
        headerViewReferences[reusableView.reuseIdentifier] = view
        return view
    }
    
    private func makeFooterView(from reusableView: AnyReusableView, at section: Int) -> UICollectionReusableView {
        if let view = footerViewReferences[reusableView.reuseIdentifier] {
            view.prepareForReuse()
            return view
        }
        let view = dequeue(reusableView, kind: .footer, for: .init(item: 0, section: section))
        footerViewReferences[reusableView.reuseIdentifier] = view
        return view
    }
    
    
    func caculateItemSize(kind: ListItemKind, constraint: LayoutSizeConstraint?, indexPath: IndexPath, dataSource: ListItemSizingDataSource) -> CGSize? {
        let model: Any
        let item: ListItemStateSynchronizable & UIView
        let reusableItem: ReusableItem
        switch kind {
        case .cell:
            guard let reusableCell = dataSource.reusableCell(at: indexPath) else { return nil }
            model = dataSource.item(at: indexPath)
            item = makeCollectionViewCell(from: reusableCell, at: indexPath)
            reusableItem = reusableCell
        case .header, .footer:
            let section = indexPath.section
            guard let resuableView = kind == .header ? dataSource.reusableSectionHeaderView(at: section) : dataSource.reusableSectionFooterView(at: section) else { return nil }
            model = dataSource.sectionModel(at: section)
            item = kind == .header ? makeHeaderView(from: resuableView, at: section) : makeFooterView(from: resuableView, at: section)
            reusableItem = resuableView
        }
        // If cell or model has provided the height, just use it.
        if let heightProvider = model as? CollectionViewItemSizeProvidable {
            return heightProvider.collectionViewItemSize(state: model, reusableItem: reusableItem, collectionViewWidth: bounds.width) }

        if let heightProvider = item as? CollectionViewItemSizeProvidable {
            if heightProvider.isNeedStateSynchronized {
                dataSource.synchronizeItem(item, withState: model, atIndexPath: indexPath, kind: kind)
            }
            return heightProvider.collectionViewItemSize(state: model, reusableItem: reusableItem, collectionViewWidth: bounds.width)
        }
        
        dataSource.synchronizeItem(item, withState: model, atIndexPath: indexPath, kind: kind)
        
        if let constraint = constraint {
            let size = item.caculateAutoLayoutSize(sizeConstraint: constraint, style: .compressed)
            return size
        }
        return nil

    }
}
