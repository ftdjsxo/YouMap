//
//  Geometry.swift
//  YouMap
//
//  Created by Francesco on 25/01/16.
//  Copyright © 2016 effesoft. All rights reserved.
//

import UIKit

class Geometry: NSObject {
    
    var coordinates : [Double]!
    
    required init(coordinates : [Double]) {
        super.init()
        self.coordinates = coordinates
    }
    
    func getLat() -> Double{
        return self.coordinates[1]
    }
    
    func getLon() ->Double{
        return self.coordinates[0]
    }
    
}
