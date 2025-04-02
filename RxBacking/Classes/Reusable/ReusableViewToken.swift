
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

public protocol ReusableViewToken {
    var type: UIView.Type { get }
    var reuseIdentifier: String { get }
    var nibName: String? { get }
}

public extension ReusableViewToken {
    var nib: UINib? {
        if let nibName = nibName
        { return .init(nibName: nibName, bundle: .init(for: type)) }
        return nil
    }
    
    func makeView<View: UIView>(nibOwner: Any? = nil, nibOptions: [UINib.OptionsKey : Any]? = nil, nibIndex: Int = 0) -> View {
        castOrFatalError(nib == nil ? type.init(frame: .zero) : nib?.instantiate(withOwner: nil)[nibIndex])
    }
}


/// A generic type that represents reusable cells.
public struct AnyReusableCell: ReusableViewToken {
    
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


/// A generic type that represents reusable views.
public struct AnyReusableView: ReusableViewToken {

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


