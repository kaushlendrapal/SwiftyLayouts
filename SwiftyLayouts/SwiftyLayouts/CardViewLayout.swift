//
//  CardViewLayout.swift
//  SwiftyLayouts
//
//  Created by kaushal on 19/01/18.
//  Copyright © 2018 kaushal. All rights reserved.
//

import UIKit

public class CardViewLayout: UICollectionViewLayout {
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
}

//MARK: - Private Methods
private extension CardViewLayout {
    
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }
    
    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
    }
    
    private func prepareCache() {
        // method to prepare cache.
    }
    
    private func updateCells(_ attributes: UICollectionViewLayoutAttributes, halfHeight: CGFloat, halfCellHeight: CGFloat) {
    
    }
    
    private func updateSupplementaryViews(attributes: UICollectionViewLayoutAttributes, collectionView: UICollectionView, indexPath: IndexPath) {

    }
}

// MARK: - LAYOUT CORE PROCESS
extension CardViewLayout {
    public override func prepare() {
        
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}

//MARK: - PROVIDING ATTRIBUTES TO THE COLLECTIONVIEW
extension CardViewLayout {
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return nil
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
}




