//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/12/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: ContainerViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocations()
    }
  
    override func loadLocations(){
            API.getStudentsLocations { errorString in
                guard errorString == nil else{
                    self.showAlert(title: "ERROR", message: errorString!)
                    return
                }
                guard StudentsLocationModel.locations.count > 0 else {
                    self.showAlert(title: "Error", message: "No pins found")
                    return
                }
                self.loadAnnotation()
            }
        }

      func loadAnnotation(){
        var annotations = [MKPointAnnotation]()
        for location in StudentsLocationModel.locations {
            
            let latitude = CLLocationDegrees(location.latitude ?? 0)
            let longitude = CLLocationDegrees(location.longitude ?? 0)
                        
                
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
            let first = location.firstName ?? ""
            let last = location.lastName ?? ""
            let mediaURL = location.mediaURL ?? ""
                    
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

     func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let toOpen = view.annotation?.subtitle!
            if let toOpen = toOpen,
                let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else{
               showAlert(title: "ERROR", message: "Failed to open \(toOpen ?? "URL")")
            }
        }
    }
    
    override func refresh(_ sender: Any) {
        super.refresh(sender)
        loadAnnotation()
    }
}
