//
//  StackLayout.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 1/22/20.
//

import UIKit

/*
A wrapper for UIStackView

For example:

```
// Basic usage:
let layout = StackLayout()
   .direction(.vertical)
   .alignItems(.center)
   .children([
       view1,
       view2,
       view3,
       ...
   ])

// Custom space between items:
let layout = StackLayout()
    .direction(.vertical)
    .alignItems(.center)
    .children([
        view1,
        StackSpaceItem(height: 20),
        view2,
        StackSpaceItem(height: 20),
        view3,
        ...
    ])

// Stack items with attributes:
let layout = StackLayout()
    .direction(.vertical)
    .alignItems(.center)
    .children([
        StackViewItem(view: view1, attribute: .centerX),
        StackViewItem(view: view2, attribute: .margin(.only(top: 20))),
        view3,
        ...
   ])
```
*/
class StackLayout: UIStackView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    /// Subclasses use this for customizations
    func setupView() {}
}

extension StackLayout {
    
    /// Define stack layout axis
    @discardableResult
    func direction(_ axis: NSLayoutConstraint.Axis) -> StackLayout {
        self.axis = axis
        return self
    }
    
    /// Define how stack layout aligns its children
    @discardableResult
    func alignItems(_ alignment: Alignment) -> StackLayout {
        self.alignment = alignment
        return self
    }
    
    /// Define how stack layout distributes its children
    @discardableResult
    func justifyContent(_ distribution: Distribution) -> StackLayout {
        self.distribution = distribution
        return self
    }
    
    /// Spacing between stack items
    @discardableResult
    func spacing(_ value: CGFloat) -> StackLayout {
        spacing = value
        return self
    }
    
    /// Add children into stack layout, accept only UIView or StackItem type,
    /// otherwise will be ignore
    @discardableResult
    func children(_ children: [Any]) -> StackLayout {
        children.forEach { child in
            if let view = getView(for: child) {
                addArrangedSubview(view)
            }
        }
        return self
    }
    
    /// Insert a child at specific index, accept only UIView or StackItem type,
    /// otherwise will be ignore
    @discardableResult
    func child(_ child: Any, at index: Int) -> StackLayout {
        guard index >= 0 && index < arrangedSubviews.count else { return self }
        
        if let view = getView(for: child) {
            insertArrangedSubview(view, at: index)
        }
        
        return self
    }
    
    /// Remove a specific child at index
    @discardableResult
    func removeChild(at index: Int) -> StackLayout {
        guard index >= 0 && index < arrangedSubviews.count else { return self }
        
        let child = arrangedSubviews[index]
        removeArrangedSubview(child)
        child.removeFromSuperview()
        
        return self
    }
    
    /// Get the view for a child, only accept UIView or StackItem type
    private func getView(for child: Any) -> UIView? {
        if let stackItem = child as? StackItem {
            return stackItem.build(with: self)
        } else if let view = child as? UIView {
            return view
        }
        
        return nil
    }
}

/// Basic protocol for item inside a stack layout
protocol StackItem {
    func build(with layout: StackLayout) -> UIView
}

/*
 Stack view item wrapper
 
 Basically wrap a view into a parent view with custom constraints definition
 For example:
 
 ```
 // Center in stack
 StackViewItem(view: logoView) { view in
     view.autoAlignAxis(toSuperviewAxis: .vertical)
     view.autoPinEdge(toSuperviewEdge: .top)
     view.autoPinEdge(toSuperviewEdge: .bottom)
 }
 
 // Using attribute
 StackViewItem(view: logoView, attribute: .centerX)
 ```
 */
class StackViewItem: UIView, StackItem {
    
    enum Attribute {
        /// Align left with insets
        case leading(insets: UIEdgeInsets)
        
        /// Align right with insets
        case trailing(insets: UIEdgeInsets)
        
        /// Align top with insets
        case top(insets: UIEdgeInsets)
        
        /// Align bottom with insets
        case bottom(insets: UIEdgeInsets)
        
        /// Center the view
        case center(insets: UIEdgeInsets)
        
        /// Fill the content with insets
        case fill(insets: UIEdgeInsets)
    }
    
    private let originalView: UIView
    private let constraintsDefinition: ((UIView) -> ())

    /// Constructor that takes a custom constraints definition
    init(view: UIView, constraintsDefinition: @escaping ((UIView) -> ())) {
        self.originalView = view
        self.constraintsDefinition = constraintsDefinition
        super.init(frame: .zero)
    }
    
    /// Constructor with custom attribute
    init(view: UIView, attribute: Attribute) {
        self.originalView = view
        self.constraintsDefinition = { (view) in
            switch attribute {
            case .leading(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .trailing)
                view.autoPinEdge(toSuperviewEdge: .trailing, withInset: insets.right, relation: .greaterThanOrEqual)
                
            case .trailing(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .leading)
                view.autoPinEdge(toSuperviewEdge: .leading, withInset: insets.left, relation: .greaterThanOrEqual)
                
            case .top(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
                view.autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom, relation: .greaterThanOrEqual)
                
            case .bottom(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .top)
                view.autoPinEdge(toSuperviewEdge: .top, withInset: insets.top, relation: .greaterThanOrEqual)
                
            case .center(let insets):
                view.autoCenterInSuperview()
                view.autoPinEdge(toSuperviewEdge: .top, withInset: insets.top, relation: .greaterThanOrEqual)
                view.autoPinEdge(toSuperviewEdge: .leading, withInset: insets.left, relation: .greaterThanOrEqual)
                view.autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom, relation: .greaterThanOrEqual)
                view.autoPinEdge(toSuperviewEdge: .trailing, withInset: insets.right, relation: .greaterThanOrEqual)
                
            case .fill(let insets):
                view.autoPinEdgesToSuperviewEdges(with: insets)
            }
        }
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build(with layout: StackLayout) -> UIView {
        addSubview(originalView)
        constraintsDefinition(originalView)
        return self
    }
}

/// Custom spacing between stack items
struct StackSpaceItem: StackItem {
    
    private let width: CGFloat
    private let height: CGFloat
    
    /// Constructor with both width and height the same size
    init(size: CGFloat) {
        width = size
        height = size
    }
    
    /// Constructor with width only, mostly use in horizontal stack layout
    init(width: CGFloat) {
        self.width = width
        self.height = 0
    }
    
    /// Construtor with height only, mostly use in vertical stack layout
    init(height: CGFloat) {
        self.width = 0
        self.height = height
    }
    
    func build(with layout: StackLayout) -> UIView {
        let view = UIView()
        view.autoSetDimensions(to: CGSize(width: width, height: height))
        
        return view
    }
}
