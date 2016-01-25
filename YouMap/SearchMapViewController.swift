//
//  SearchMapViewController.swift
//  YouMap
//
//  Created by Francesco Thiery on 25/01/16.
//  Copyright © 2016 effesoft. All rights reserved.
//

import MapKit

class SearchMapViewController: MapViewController, UITextFieldDelegate, TableViewResDelegate {
    
    var tap : UITapGestureRecognizer!
    var pan : UIPanGestureRecognizer!
    var tableView : UITableView?
    var controller : TableViewController!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGesturesRecognizer()
        self.addGesturesRecognizer()
        self.textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeGesturesRecognizer()
    }
    
    @IBAction func didSearchText(sender: UITextField) {
        
        if((sender.text != nil) && !sender.text!.isEmpty){
            
            if tableView == nil {
                self.tableView = UITableView(frame: self.view.frame)
                self.tableView?.frame.origin.y += 85
                self.controller = TableViewController(delegate: self)
                self.controller.results = Helper.searchTitles(self.pins, text: sender.text!)
                self.tableView!.delegate = controller
                self.tableView!.dataSource = controller
                self.view.addSubview(tableView!)
            }else{
                self.controller.results = Helper.searchTitles(self.pins, text: sender.text!)
            }
            
            self.tableView?.reloadData()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismiss()
        return false
    }
    
    func dismiss(){
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        self.tableView?.removeFromSuperview()
        self.tableView = nil
    }
    
    private func setGesturesRecognizer(){
        self.tap = UITapGestureRecognizer(target: self, action: "dismiss")
        self.pan = UIPanGestureRecognizer(target: self, action: "dismiss")
        self.tap.cancelsTouchesInView = false
        self.pan.cancelsTouchesInView = false
    }
    
    private func addGesturesRecognizer(){
        self.mapView.addGestureRecognizer(tap)
        self.mapView.addGestureRecognizer(pan)
    }
    
    private func removeGesturesRecognizer(){
        self.tap.removeTarget(self, action: "dismiss")
        self.pan.removeTarget(self, action: "dismiss")
        self.view.removeGestureRecognizer(tap)
        self.view.removeGestureRecognizer(pan)
    }
    
    func didSelectRow(pin: Pin) {
        mapView.setRegion(MKCoordinateRegion(center: pin.toMKAnnotation().coordinate, span: MKCoordinateSpanMake(0, 0)), animated: true)
        self.dismiss()
    }
    
    
}
