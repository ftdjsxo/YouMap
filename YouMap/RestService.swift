//
//  RestService.swift
//  YouMap
//
//  Created by Francesco on 25/01/16.
//  Copyright © 2016 effesoft. All rights reserved.
//

import UIKit

protocol RestServiceDelegate{
    func didRecivePins(pins: [Pin])
}

class RestService: NSObject, NSURLConnectionDataDelegate {
    
    private var connection:NSURLConnection?
    private var responseData:NSMutableData?
    private var delegate : RestService!
    private var restServiceDelegate : RestServiceDelegate?
    
    static let MAPURL = "https://api.mapbox.com/v4/sgnoogle.mnp7idjo/features.json?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpamVuY3cxbzAwMG12ZGx4cGljbGtqMGUifQ.vpDqms08MBqoRgp667Yz5Q"
    
    convenience init(delegate :RestServiceDelegate){
        self.init()
        self.restServiceDelegate = delegate
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        let jsItem = NSUserDefaults.standardUserDefaults().objectForKey(Helper.UNPARSED_ELEMENTS_KEY)
        let jsPins = jsItem!["features"] as? NSMutableArray
        let elements = parseFeatures(jsPins)
        
        if elements != nil{
           restServiceDelegate?.didRecivePins(elements!)
        }
        
        print("Errore: ", error.localizedDescription)
    }
    
    func makeRequest(){
        self.delegate = self
        let url = NSURL(string: RestService.MAPURL)
        let urlRequest = NSURLRequest(URL: url!)
        self.connection = NSURLConnection(request: urlRequest, delegate: self)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if self.responseData==nil {
            print("La connessione non ha riportato alcun risultato")
        }
        
        do{
        
            if let _ = NSString(data: self.responseData!, encoding: NSUTF8StringEncoding){
                let jsItem = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                print("Richiesta mappa: " , jsItem["id"] as! String , "completata")
                let jsPins = jsItem["features"] as! NSMutableArray
                let elements = parseFeatures(jsPins)
                if elements == nil{
                    return
                }
                self.restServiceDelegate?.didRecivePins(elements!)
                NSUserDefaults.standardUserDefaults().setObject(jsItem, forKey: Helper.UNPARSED_ELEMENTS_KEY)
                print("Aggiunti ", elements!.count, "elementi")
             }
        }catch{
        }
        
    }
    
    private func parseProperty(property : NSDictionary) -> Property{
        let title = property["title"] as! String
        let id = property["id"] as! String
        let descrizione = property["description"] as! String
        return Property(id : id, title: title, description: descrizione)
    }
    
    private func parseGeom(geom : NSDictionary) -> Geometry{
        let mutableCo = geom["coordinates"] as! NSMutableArray
        var coordinates = [Double]()
        for coordinata in mutableCo{
            coordinates.append(coordinata as! Double)
        }
        return Geometry(coordinates: coordinates)
    }
    
    private func parseFeatures(jsPins : NSMutableArray?) ->[Pin]?{
        var elements = [Pin]()
        
        if jsPins == nil{
            return nil
        }
        
        for jP in jsPins!{
            let property = jP["properties"] as! NSDictionary
            let geom = jP["geometry"] as! NSDictionary
            
            let pin = Pin(property: parseProperty(property), geometry: parseGeom(geom))
            elements.append(pin)
        }
        return elements
    }
    
    
    /***
        https://api.mapbox.com/v4/sgnoogle.mnp7idjo/features.json?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpamVuY3cxbzAwMG12ZGx4cGljbGtqMGUifQ.vpDqms08MBqoRgp667Yz5Q
    
    
    mapID = sgnoogle.mnp7idjo
    token = pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpamVuY3cxbzAwMG12ZGx4cGljbGtqMGUifQ.vpDqms08MBqoRgp667Yz5Q
    ***/

}
