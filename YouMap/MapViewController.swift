//
//  ViewController.swift
//  YouMap
//
//  Created by Francesco on 25/01/16.
//  Copyright © 2016 effesoft. All rights reserved.
//

import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, RestServiceDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var currentAnnotation : FBAnnotation?
    var pins : [Pin]!
    private let clusteringManager = FBClusteringManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestService(delegate: self).makeRequest()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didRecivePins(pins: [Pin]) {
        self.pins = pins
        var annotations = [FBAnnotation]()
        for pin in pins{
             annotations.append(pin.toMKAnnotation())
        }
        self.clusteringManager.addAnnotations(annotations)
       
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        currentAnnotation = view.annotation as? FBAnnotation
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        
        for view in views{
            let pinView = view as? MKPinAnnotationView
            let button = UIButton(type: .DetailDisclosure)
            button.addTarget(self, action: "pressed", forControlEvents: UIControlEvents.TouchUpInside)
            pinView?.rightCalloutAccessoryView = button
            pinView?.pinTintColor = Helper.UIColorFromRGB(0x00cc66)
        }
    }
    
    func pressed(){
        let desc = currentAnnotation?.pin.getDescription()
        let types: NSTextCheckingType = .Link
        do{
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matchesInString(desc!, options: .ReportCompletion, range: NSMakeRange(0, desc!.characters.count))
            
            for match in matches {
                UIApplication.sharedApplication().openURL(match.URL!)

                print(match.URL!)
            }
        }catch{
            
        }
        print(currentAnnotation?.pin.getDescription())
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var reuseId = ""
        if annotation.isKindOfClass(FBAnnotationCluster) {
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId)
            return clusterView
        }else {
            reuseId = "Pin"
            let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            return pinView
        }
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        NSOperationQueue().addOperationWithBlock({
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.mapView)
        })
    }



}

