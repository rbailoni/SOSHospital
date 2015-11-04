//
//  MapViewController.swift
//  SOSHospital
//
//  Created by William kwong huang on 30/10/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    private let hospitalData = Hospital()
    
    //var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("bem vindo mapView")
        
    }
    
    override func viewDidAppear(animated: Bool) {

        //locationManager? = CLLocationManager()
        //locationManager?.requestAuthorization()
        
    }
    
    private func centralizar(coordinate: CLLocationCoordinate2D) {
        mapView.setCenterCoordinate(coordinate, animated: true)
        let center = MKCoordinateRegion(
            center: coordinate,
            //span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009) // 1KM
            span: MKCoordinateSpan(latitudeDelta: 0.045, longitudeDelta: 0.045) // 5KM
        )
        mapView.setRegion(center, animated: true)
    }
    
    private func adicionarPinosNoMapa() {
        
        // Localização do usuário
        guard let userLocation = mapView.userLocation.location else {
            return
        }
        
        // Remove todos os pins
        mapView.removeAnnotations(mapView.annotations)
        
        for hosp: Hospital in hospitalData.findHospitals(self.context) {
            
            // Verifica se o hospital esta proximo
            let meters = userLocation.distanceFromLocation(hosp.Location)
            
            if meters <= 5_000 {
                
                hosp.distance = Int(meters)
                
                let coordinate = CLLocationCoordinate2D(latitude: hosp.latitude, longitude: hosp.longitude)
                
                let ca = CustomAnnotation()
                ca.id = Int(hosp.id)
                ca.coordinate = coordinate
                ca.title = hosp.name
                ca.subtitle = "distância: \(hosp.distance)m"
                mapView.addAnnotation(ca)
                
            }
        }
        
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        switch annotation {
        case is CustomAnnotation:
            let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotation.Identifier)
            pin.image = UIImage(named: CustomAnnotation.PinName)
            pin.canShowCallout = true
            
            // criando um botão
            let botao = UIButton(type: UIButtonType.InfoLight)
            pin.rightCalloutAccessoryView = botao
            
            // criando uma imagem
            let imagem = UIImage(named: CustomAnnotation.HospitalLeft)
            pin.leftCalloutAccessoryView = UIImageView(image: imagem)
            
            // caso precise ajustar:
            // centro dos pinos
            pin.centerOffset = CGPoint(x: 0.3, y: 0.3)
            pin.calloutOffset = CGPoint(x: 0.5, y: 0.5)
            return pin
            
        default:
            return nil
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        switch view.annotation {
        case is CustomAnnotation:
            let annotation = view.annotation as! CustomAnnotation
            print(annotation.id)
            //self.performSegueWithIdentifier(self.identifierSegue, sender: self)
            
            break
            
        default:
            break
        }
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
     
        let coordinate = userLocation.location!.coordinate
        centralizar(coordinate)
        print("MapView --> \(NSDate()) lat:\(coordinate.latitude), long:\(coordinate.longitude)")
        adicionarPinosNoMapa()
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print(error)
    }
    
}






