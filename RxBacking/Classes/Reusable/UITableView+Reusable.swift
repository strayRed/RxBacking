
import UIKit

extension UIScrollView {
    func isRegistered(for itemType: inout AnyClass) -> Bool {
        (objc_getAssociatedObject(self, &itemType) as? Bool) ?? false
    }
    
    func setRegistionFlag(_ flag: Bool, forItemType itemType: inout AnyClass) {
        objc_setAssociatedObject(self, &itemType, flag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


private var dequeuingCellsKey: Void?

extension UITableView {
    func register(_ cell: AnyReusableCell) {
        defer {
            //Set flag true before returning.
            var mutatingClass: AnyClass = cell.type
            setRegistionFlag(true, forItemType: &mutatingClass)
        }
        if let nib = cell.nib {
            register(nib, forCellReuseIdentifier: cell.reuseIdentifier); return
        }
        register(cell.type, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    
    func register(_ view: AnyReusableView) {
        defer {
            //Set flag true before returning.
            var mutatingClass: AnyClass = view.type
            setRegistionFlag(true, forItemType: &mutatingClass)
        }
        if let nib = view.nib {
            register(nib, forHeaderFooterViewReuseIdentifier: view.reuseIdentifier); return
        }
        register(view.type, forHeaderFooterViewReuseIdentifier: view.reuseIdentifier)
    }
    
    
    public func dequeue(_ cell: AnyReusableCell) -> UITableViewCell {
        var mutatingClass: AnyClass = cell.type
        // register the cell if the flag is false.
        if !isRegistered(for: &mutatingClass) {
            register(cell)
        }
          
        let cell = dequeueReusableCell(withIdentifier: cell.reuseIdentifier)!
        
        return cell
    }
}


extension UITableView {
    func dequeue(_ view: AnyReusableView) -> UITableViewHeaderFooterView {
        var mutatingClass: AnyClass = view.type
        if !isRegistered(for: &mutatingClass) { register(view) }
        return dequeueReusableHeaderFooterView(withIdentifier: view.reuseIdentifier)!
    }
}



