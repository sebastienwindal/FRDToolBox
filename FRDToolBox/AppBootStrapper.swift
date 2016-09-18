//
//  AppBootStrapper.swift
//  FRDToolBox
//
//  Created by Sebastien Windal on 7/24/16.
//  Copyright © 2016 Sebastien Windal. All rights reserved.
//

import UIKit

open class AppBootStrapper: NSObject {
    
    public override init() {
        super.init()
    }
    
    open func setup(_ items: [BootStrapItem]) {
        for item in items {
            print("Bootstrapping \(item.name())");
            item.setup()
        }
    }
}
