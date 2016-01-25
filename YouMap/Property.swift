//
//  Property.swift
//  YouMap
//
//  Created by Francesco on 25/01/16.
//  Copyright © 2016 effesoft. All rights reserved.
//

import UIKit

class Property: NSObject {
    
    var title : String!
    var descrizione : String!
    var id : String!
    
    required init(id : String, title : String, description : String) {
        super.init()
        self.title = title
        self.descrizione = description
    }

}
