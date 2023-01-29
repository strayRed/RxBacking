
import UIKit
//
/// An enumeration that represents UICollectionView supplementary view kind.
public enum SupplementaryViewKind: String {
  case header, footer

  public init?(rawValue: String) {
    switch rawValue {
    case UICollectionView.elementKindSectionHeader: self = .header
    case UICollectionView.elementKindSectionFooter: self = .footer
    default: return nil
    }
  }

  public var rawValue: String {
    switch self {
    case .header: return UICollectionView.elementKindSectionHeader
    case .footer: return UICollectionView.elementKindSectionFooter
    }
  }
}

extension UICollectionView {
    
    private func isViewRegistered(viewType: inout UIView.Type, kind: SupplementaryViewKind) -> Bool {
        let registerInfo = objc_getAssociatedObject(self, &viewType) as? [SupplementaryViewKind: Bool]
        return registerInfo?[kind] ?? false
    }
    
    private func setViewRegistionFlag(_ flag: Bool, forViewType viewType: inout AnyClass, andKind kind: SupplementaryViewKind) {
        var registerInfo = (objc_getAssociatedObject(self, &viewType) as? [SupplementaryViewKind: Bool]) ?? [:]
        // Avoid copy-on-write.
        objc_setAssociatedObject(self, &viewType, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        registerInfo[kind] = true
        objc_setAssociatedObject(self, &viewType, registerInfo, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension UICollectionView {
    func register(_ cell: AnyReusableCell) {
        defer {
            //Set flag true before returning.
            var mutatingClass: AnyClass = cell.type
            setRegistionFlag(true, forItemType: &mutatingClass)
        }
        if let nib = cell.nib {
            register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier); return
        }
        register(cell.type, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    public func register(_ view: AnyReusableView, kind: SupplementaryViewKind)  {
        defer {
            //Set flag true before returning.
            var mutatingClass: AnyClass = view.type
            setViewRegistionFlag(true, forViewType: &mutatingClass, andKind: kind)
        }
        if let nib = view.nib {
            register(nib, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: view.reuseIdentifier)
        }
        register(view.type, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: view.reuseIdentifier)
    }
    
}

extension UICollectionView {

    public func dequeue(_ cell: AnyReusableCell, for indexPath: IndexPath) -> UICollectionViewCell {
        var mutatingClass: AnyClass = cell.type
        // register the cell if the flag is false.
        if !isRegistered(for: &mutatingClass) {
            register(cell)
        }
        let cell = dequeueReusableCell(withReuseIdentifier: cell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    public func dequeue(_ view: AnyReusableView, kind: SupplementaryViewKind, for indexPath: IndexPath) -> UICollectionReusableView {
        var mutatingClass: UIView.Type = view.type
        if !isViewRegistered(viewType: &mutatingClass, kind: kind) {
            register(view, kind: kind)
        }
        
        return dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: view.reuseIdentifier, for: indexPath)
    }
}

extension AnyReusableCell {
    func makeCollectionViewCell() -> UICollectionViewCell {
        if let nib = self.nib {
            for view in nib.instantiate(withOwner: nil, options: nil) {
                if let cell = view as? UICollectionViewCell { return cell }
            }
        }
        if let type = self.type as? UICollectionViewCell.Type {
            return type.init()
        }
        fatalError("Mismatched ReusableCell type")
    }
}


