//
//  RxCollectionViewCellSizeProvider.swift
//  RxBacking
//
//  Created by strayRed on 2021/10/12.
//

import Foundation
import UIKit

class RxCollectionViewCellSizeProvider: ListIndePathSizedItemStorage {

    private weak var collectionView: UICollectionView?
    
    private weak var dataSource: ListItemSizingDataSource?
    
    private var sizeStroages: [ListItemKind: ListItemStorage.KeyIdentified<AnyHashable, CGSize>] = [:]
    
    
    init(collectionView: UICollectionView, dataSource: ListItemSizingDataSource) {
        self.collectionView = collectionView
        self.dataSource = dataSource
    }
    
    private func size(inKind kind: ListItemKind, forKey key: AnyHashable) -> CGSize? {
        guard let stroage = sizeStroages[kind] else {
            sizeStroages[kind] = .init(); return nil
        }
        return stroage.item(forKey: key)
    }
    
    func storeSize(_ size: CGSize, inKind kind: ListItemKind, forKey key: AnyHashable) {
        sizeStroages[kind]?.store(size, forKey: key)
    }
    
    func makeSize(kind: ListItemKind, constraint: UIView.LayoutSizeConstraint?, indexPath: IndexPath) -> CGSize? {
        guard let collectionView = self.collectionView, let dataSource = dataSource else { return nil }
        let key = dataSource.metricIdentifier(kind: kind, indexPath: indexPath)
        if let size = size(inKind: kind, forKey: key) {
            return size
        }
        let newSize = collectionView.caculateItemSize(kind: kind, constraint: constraint, indexPath: indexPath, dataSource: dataSource)
        if let newSize = newSize {
            storeSize(newSize, inKind: kind, forKey: key)
        }
        return newSize
        
    }

    func removeAllItems() {
        sizeStroages.removeAll(keepingCapacity: true)
    }
    
    
}
