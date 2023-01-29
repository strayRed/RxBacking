
import UIKit

fileprivate func typeName<T>(of subject: T.Type) -> String {
    let typeName: String = {
        let fullTypeName = String(reflecting: subject)
        let typeNameParts = fullTypeName.components(separatedBy: ".")
        let hasModulePrefix = typeNameParts.count > 1
        return hasModulePrefix
            ? typeNameParts.dropFirst().joined(separator: ".")
            : fullTypeName
    }()
    return typeName
}

public protocol ReusableItem {
    var type: UIView.Type { get }
    var reuseIdentifier: String { get }
    var nibName: String? { get }

}

extension ReusableItem {
    var nib: UINib? {
        if let nibName = nibName
        { return .init(nibName: nibName, bundle: .init(for: type)) }
        return nil
    }
}


/// A generic class that represents reusable cells.
public struct AnyReusableCell: ReusableItem {
    
    public let type: UIView.Type
    public let reuseIdentifier: String
    public var nibName: String? = nil
    
    /// - Parameters:
    ///   - type: The type of cell
    ///   - fromNib: Is cell form nib. Nib name is equal to cell class name.
    public init(type: UIView.Type, fromNib: Bool = false) {
        self.type = type
        self.reuseIdentifier = typeName(of: self.type)
        if fromNib { self.nibName = self.reuseIdentifier }
    }
    
}


/// A generic class that represents reusable views.
public struct AnyReusableView: ReusableItem {

    public let type: UIView.Type
    public let reuseIdentifier: String
    public var nibName: String? = nil
    
    /// - Parameters:
    ///   - type: The type of view
    ///   - fromNib: Is cell form nib. Nib name is equal to view class name.
    public init(type: UIView.Type, fromNib: Bool = false) {
        self.type = type
        self.reuseIdentifier = typeName(of: self.type)
        if fromNib { self.nibName = self.reuseIdentifier }
    }

}


