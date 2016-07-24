//
//  BootStrapItem.swift
//  FRDToolBox
//
//  Created by Sebastien Windal on 7/24/16.
//  Copyright © 2016 Sebastien Windal. All rights reserved.
//

import UIKit

public protocol BootStrapItem {
    func name() -> String
    func setup()
}