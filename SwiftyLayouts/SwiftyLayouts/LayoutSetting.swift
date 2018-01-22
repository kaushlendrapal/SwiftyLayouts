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
    
    init() {
        self.contentMargin = UIEdgeInsets.zero
        self.sectionMargin = UIEdgeInsets.zero
        self.cellMargin    = UIEdgeInsets.zero
    }
    
}
