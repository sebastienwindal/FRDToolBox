//
//  BaseModelObject.swift
//  FRDToolBox
//
//  Created by Sebastien Windal on 5/31/17.
//  Copyright © 2017 Sebastien Windal. All rights reserved.
//

import Foundation
import ObjectMapper

protocol BaseModel:Mappable {
    static func indexRoute() -> String
    static func getRoute() -> String
}

class BaseModelObject:BaseModel {
    
    public required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
    }
    
    class func indexRoute() -> String {
        fatalError("Subclasses need to implement the `indexRoute()` method.")
    }
    
    class func getRoute() -> String {
        fatalError("Subclasses need to implement the `getRoute()` method.")
    }
    
}
