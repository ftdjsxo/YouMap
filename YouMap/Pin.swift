//
//  Pin.swift
//  YouMap
//
//  Created by Francesco on 25/01/16.
//  Copyright © 2016 effesoft. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject {
    
    var property : Property!
    var geometry : Geometry!
    var id : String!
    
    convenience init(property : Property, geometry : Geometry?) {
        self.init()
        self.property = property
        self.geometry = geometry
        self.id = property.id
    }
    
    func getTitle() -> String{
        return property.title
    }
    
    func getDescription() ->String{
        return self.property.descrizione
    }
    
    func getCoordinates()-> CLLocationCoordinate2D{
        return CLLocationCoordinate2DMake(geometry.getLat(), geometry.getLon())
    }
    
    func toMKAnnotation() -> FBAnnotation{
        let annotation = FBAnnotation()
        annotation.coordinate = self.getCoordinates()
        annotation.title = getTitle()
        annotation.subtitle = getDescription()
        annotation.pin = self
        return annotation
    }

}
