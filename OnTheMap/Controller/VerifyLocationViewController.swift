//
//  VerifyLocationViewController.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/16/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import UIKit
import MapKit
class VerifyLocationViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    var location: StudentLocation?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnnotation()
    }
    
    private func setAnnotation(){
        guard  location != nil else{
            return
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: location?.latitude ?? 0.0, longitude: location?.latitude ?? 0.0)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        let firstName = location?.firstName ?? ""
        let lastName = location?.lastName ?? ""
        annotation.title = firstName + " " + lastName
        annotation.subtitle = location?.mediaURL ?? ""
        
        
        mapView.addAnnotation(annotation)
       
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 60000, longitudinalMeters: 60000)
        mapView.setRegion(region, animated: true)
        
        
    }
    
    @IBAction func finishBtnTapped(_ sender: Any) {
        activityIndicator.stopAnimating()
        API.postLocation(studentLocation: location!) { (errorString) in
            self.activityIndicator.stopAnimating()
            guard errorString == nil else{
                self.showAlert(title: "ERROR", message: errorString!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension VerifyLocationViewController: MKMapViewDelegate {
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         let reuseIdentifier = "pin"
         var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView

         if pinView == nil {
             pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
             pinView!.canShowCallout = true
             pinView!.pinColor = .red
            pinView!.isDraggable = true
            pinView!.animatesDrop = true
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
                 showAlert(title: "ERROR", message: "Failed to open\(toOpen ?? "URL")")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
    switch newState {
    case .starting:
        view.dragState = .dragging
    case .ending:
        view.dragState = .none
        let droppedAt = view.annotation?.coordinate
        location?.longitude = droppedAt?.longitude
        location?.latitude = droppedAt?.latitude
    case .canceling: view.dragState = .none
    default: break
    }
}

    
}
