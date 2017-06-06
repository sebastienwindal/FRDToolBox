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
    static func postRoute() -> String
    static func updateRoute() -> String
    static func deleteRoute() -> String
}

open class BaseModelObject:BaseModel {
    
    required public init?(map: Map) {
        
    }
    
    public init() {
        
    }
    
    open func mapping(map: Map) {
    }
    
    open class func indexRoute() -> String {
        fatalError("Subclasses need to implement the `indexRoute()` method.")
    }
    
    open class func getRoute() -> String {
        fatalError("Subclasses need to implement the `getRoute()` method.")
    }
    
    open class func postRoute() -> String {
        fatalError("Subclasses need to implement the `postRoute()` method.")
    }
    
    open class func updateRoute() -> String {
        fatalError("Subclasses need to implement the `updateRoute()` method.")
    }
    
    open class func deleteRoute() -> String {
        fatalError("Subclasses need to implement the `deleteRoute()` method.")
    }
}
