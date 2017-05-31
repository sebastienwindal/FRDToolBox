//
//  BaseModelObject.swift
//  FRDToolBox
//
//  Created by Sebastien Windal on 5/31/17.
//  Copyright © 2017 Sebastien Windal. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol BaseModel:Mappable {
    static func indexRoute() -> String
    static func getRoute() -> String
}

open class BaseModelObject:BaseModel {
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
    }
    
    public class func indexRoute() -> String {
        fatalError("Subclasses need to implement the `indexRoute()` method.")
    }
    
    public class func getRoute() -> String {
        fatalError("Subclasses need to implement the `getRoute()` method.")
    }
    
}
