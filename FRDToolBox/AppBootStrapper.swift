//
//  AppBootStrapper.swift
//  FRDToolBox
//
//  Created by Sebastien Windal on 7/24/16.
//  Copyright © 2016 Sebastien Windal. All rights reserved.
//

import Foundation

class AppBootStrapper: NSObject {
    
    override init() {
        super.init()
    }
    
    func setup(items: [BootStrapItem]) {
        for item in items {
            print("Bootstrapping \(item.name())");
            item.setup()
        }
    }
}