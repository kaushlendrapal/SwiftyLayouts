//
//  LayoutSetting.swift
//  SwiftyLayouts
//
//  Created by kaushal on 19/01/18.
//  Copyright © 2018 kaushal. All rights reserved.
//

import Foundation

public struct LayoutSetting {
    
     var contentMargin:UIEdgeInsets
     var sectionMargin:UIEdgeInsets
     var cellMargin:UIEdgeInsets
     var minHeaderOverlayZIndex:Int = 100
     var minItemZIndex:Int = 10
     public var floatingHeaders:Bool = false
     var floatingFooters:Bool = false
     var globalHeader:Bool = false
    
    
    
    init() {
        self.contentMargin = UIEdgeInsets.zero
        self.sectionMargin = UIEdgeInsets.zero
        self.cellMargin    = UIEdgeInsets.zero
    }
 
    public init(contentMargin:UIEdgeInsets, sectionMargin:UIEdgeInsets, cellMargin:UIEdgeInsets) {
        self.contentMargin = contentMargin
        self.sectionMargin = sectionMargin
        self.cellMargin    = cellMargin
    }
    
    public mutating func updateCellMargin(cellMargin:UIEdgeInsets) {
        self.cellMargin = cellMargin
    }
        
}


public enum LayoutElementKind : String {
    case itemTopDecorator       = "itemTopDecorator"
    case itemLeadingDecorator   = "itemLeadingDecorator"
    case itembackgroundDecorator = "itembackgroundDecorator"
}


