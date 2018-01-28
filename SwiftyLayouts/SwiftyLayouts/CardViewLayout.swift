//
//  CardViewLayout.swift
//  SwiftyLayouts
//
//  Created by kaushal on 19/01/18.
//  Copyright © 2018 kaushal. All rights reserved.
//

import UIKit

public protocol LayoutDelegate : class {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

extension LayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        return 200
    }
}

public class CardViewLayout: UICollectionViewLayout {
    
    private var registeredDecorationClasses:[String:AnyClass] = [:]
    private var itemLayoutAttributeCache = [IndexPath: UICollectionViewLayoutAttributes]()
    private var decorationLayoutAttributeCache = [IndexPath: UICollectionViewLayoutAttributes]()
    private var headerLayoutAttributeCache = [Int: UICollectionViewLayoutAttributes]()
    private var footerLayoutAttributeCache = [Int: UICollectionViewLayoutAttributes]()

    private var collectionViewContentHeight: CGFloat = 0
    public var layoutSetting = LayoutSetting()
    public weak var delegate: LayoutDelegate!

    private var collectionViewContentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewContentWidth, height: collectionViewContentHeight)
    }
    
    private var cellWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right) - (layoutSetting.cellMargin.left + layoutSetting.cellMargin.right)
    }
    
    public override func register(_ viewClass: AnyClass?, forDecorationViewOfKind elementKind: String) {
        registeredDecorationClasses[elementKind] = viewClass
        super.register(viewClass, forDecorationViewOfKind: elementKind)
    }
}

// MARK: - Layout Core Process
extension CardViewLayout {
    public override func prepare() {
        //prepare item layout attributs
        prepareLayoutAttributesCache()
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for (_, attributes) in itemLayoutAttributeCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
   @discardableResult public override func shouldInvalidateLayout(
                                            forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.size.equalTo(self.collectionView!.frame.size)
    }
}

//MARK: - CollectionView Layout attributes
extension CardViewLayout {
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) ->            UICollectionViewLayoutAttributes? {
        return itemLayoutAttributeCache[indexPath]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind:String,
                                                              at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            guard let headerAttribute = headerLayoutAttributeCache[indexPath.section] else {
                fatalError("headerAttribute view elemen is must to draw layout")
            }
            return headerAttribute
        case UICollectionElementKindSectionFooter:
            guard let footerAttribute = footerLayoutAttributeCache[indexPath.section] else {
                fatalError("footerAttribute view elemen is must to draw layout")
            }
            return footerAttribute
        default:
            fatalError("wrong element kind for suplementry view")
        }
    }
    
    public override func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                           at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let decorationAttribute = decorationLayoutAttributeCache[indexPath] else {
            fatalError("decoration view elemen is must to draw layout")
        }
        return decorationAttribute
    }
}

//MARK: - Private Methods
private extension CardViewLayout {
    
    func layoutKeyForHeaderAtIndexPath(_ indexPath : IndexPath) -> String {
        return "h_\(indexPath.section)_\(indexPath.row)"
    }
    
    private func prepareLayoutAttributesCache() {
        // method to prepare cache.
        guard let collectionView = collectionView,
            itemLayoutAttributeCache.isEmpty else {
                return
        }
        collectionViewContentHeight = 0
        for section in 0 ..< collectionView.numberOfSections {
            
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let cellIndexPath = IndexPath(item: item, section: section)
                let attribute = createItemAttribute(forCellWith:cellIndexPath)
                collectionViewContentHeight = attribute.frame.maxY
                itemLayoutAttributeCache[cellIndexPath] = attribute
            }
            
        }
    }
    
    private func createItemAttribute(forCellWith cellIndexPath:IndexPath) -> (UICollectionViewLayoutAttributes) {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
        let cellHeight: CGFloat = delegate.collectionView(self.collectionView!, heightForPhotoAtIndexPath: cellIndexPath)
        let itemMinY:CGFloat = collectionViewContentHeight + layoutSetting.cellMargin.top
        let itemMaxY:CGFloat = collectionViewContentHeight + layoutSetting.cellMargin.top + cellHeight + layoutSetting.cellMargin.bottom
        let itemMinX:CGFloat = layoutSetting.cellMargin.left + layoutSetting.contentMargin.left
        let itemMaxX:CGFloat = collectionView!.bounds.width - (layoutSetting.cellMargin.right + layoutSetting.contentMargin.right)
        attribute.frame = CGRect(
            x:itemMinX,
            y:itemMinY,
            width:(itemMaxX - itemMinX),
            height:(itemMaxY - itemMinY)
        )
        attribute.zIndex = layoutSetting.minItemZIndex
        
       return attribute
    }
    
    private func updateCells(_ attributes: UICollectionViewLayoutAttributes, halfHeight: CGFloat, halfCellHeight: CGFloat) {
        
    }
    
    private func updateSupplementaryViews(attributes: UICollectionViewLayoutAttributes, collectionView: UICollectionView, indexPath: IndexPath) {
        
    }
    
    func invalidateLayoutWithCache() -> Void {
        // Invalidate cached Components
        itemLayoutAttributeCache.removeAll(keepingCapacity: true)
        decorationLayoutAttributeCache.removeAll(keepingCapacity: true)
        headerLayoutAttributeCache.removeAll(keepingCapacity: true)
        footerLayoutAttributeCache.removeAll(keepingCapacity: true)

        shouldInvalidateLayout(forBoundsChange: CGRect.zero)
    }
    
    func zIndexFor(_ elementKind:String, floating:Bool = false) -> CGFloat {
        
        if elementKind == LayoutElementKind.itemTopDecorator.rawValue {
            
        }
        
        return 10
    }

}



