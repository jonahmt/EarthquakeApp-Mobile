//
//  ViewController.swift
//  EarthquakeApp
//
//  Created by Mobile on 11/13/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomStepper: UIStepper!
    
    var feature:Feature?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set Labels:
        
        magLabel.text = "Magnitdue \(feature!.properties.mag)"
        
        let unixTime = feature!.properties.time // this is in milliseconds

        let date = Date(timeIntervalSince1970: TimeInterval(unixTime/1000)) // milliseconds to seconds
        let dateFormatter = DateFormatter()

        // unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
        //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm zzz" // specify desired date format
        dateFormatter.dateFormat = "dd LLLL yyyy HH:mm zzz"
        let dateString = dateFormatter.string(from: date)
        
        timeLabel.text = dateString
        locLabel.text = feature!.properties.place
        
        // Set mapView properties:
        
        mapView.mapType = .standard
        
        let centerLoc = CLLocationCoordinate2D(latitude: feature!.geometry.coordinates[1], longitude: feature!.geometry.coordinates[0])
        let span = MKCoordinateSpan(latitudeDelta: pow(2, -zoomStepper.value), longitudeDelta: pow(2, -zoomStepper.value))
        let region = MKCoordinateRegion(center: centerLoc, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let mapAnnotation = MKPointAnnotation()
        mapAnnotation.title = feature!.properties.place
        mapAnnotation.coordinate = centerLoc
        mapView.addAnnotation(mapAnnotation)
        
    }
    
    // Change the span of the region (log scale) and reset center when the stepper is used.
    @IBAction func changeZoom(_ sender: UIStepper) {
        
        let span = MKCoordinateSpan(latitudeDelta: pow(2, -zoomStepper.value), longitudeDelta: pow(2, -zoomStepper.value))
        let centerLoc = CLLocationCoordinate2D(latitude: feature!.geometry.coordinates[1], longitude: feature!.geometry.coordinates[0])
        let region = MKCoordinateRegion(center: centerLoc, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    


}

