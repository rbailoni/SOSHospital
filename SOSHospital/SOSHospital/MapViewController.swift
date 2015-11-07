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
    
    private var identifierSegue = "detailSegue"
    private let hospitalData = Hospital()
    
    private var lastLocation = CLLocation(latitude: 0, longitude: 0)
    private var distanciaMapa = 1_000.0
    private var isCenter = false
    
    //var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("bem vindo mapView")
        
    }
    
    override func viewDidAppear(animated: Bool) {

        //locationManager? = CLLocationManager()
        //locationManager?.requestAuthorization()
        
    }
    
    @IBAction func changeRegionMap(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: // 500 m
            distanciaMapa = 500
        case 1: // 1 km
            distanciaMapa = 1_000
        case 2: // 2 km
            distanciaMapa = 2_000
        case 3: // 5 km
            distanciaMapa = 5_000
        default:
            distanciaMapa = 500
        }
        centralizar(distanciaMapa)
        updatePins()
        
    }
    
    func centralizar(distancia: Double) {
        
        let userCoordinate = mapView.userLocation.coordinate
        
        var startCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
        if userCoordinate.latitude == 0.0 && userCoordinate.longitude == 0.0 {
            startCoord = CLLocationCoordinate2DMake(-22.903539299999998, -43.209586899999998)
        }
        else {
            startCoord = CLLocationCoordinate2DMake(userCoordinate.latitude, userCoordinate.longitude)
        }
        let adjustedRegion: MKCoordinateRegion = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(startCoord, distancia, distancia))
        mapView.setRegion(adjustedRegion, animated: true)
        self.isCenter = true
        
    }

    
//    private func centralizar(coordinate: CLLocationCoordinate2D) {
//        
//        mapView.setCenterCoordinate(coordinate, animated: true)
//        let center = MKCoordinateRegion(
//            center: coordinate,
//            //span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009) // 1KM
//            span: MKCoordinateSpan(latitudeDelta: 0.045, longitudeDelta: 0.045) // 5KM
//        )
//        mapView.setRegion(center, animated: true)
//        self.isCenter = true
//        
//    }
    
    private func updatePins() {
        
        // Localização do usuário
        guard let userLocation = mapView.userLocation.location else {
            return
        }
        
        // Remove todos os pins
        mapView.removeAnnotations(mapView.annotations)
        
        // Procura os hospitais no range
        for hosp: Hospital in hospitalData.findHospitals(context, origin: userLocation, maxDistance: distanciaMapa) {
            
            let coordinate = CLLocationCoordinate2D(latitude: hosp.latitude, longitude: hosp.longitude)
            
            let ca = CustomAnnotation()
            ca.id = Int(hosp.id)
            ca.coordinate = coordinate
            ca.title = hosp.name
            ca.subtitle = "distância: \(hosp.distance)m"
            mapView.addAnnotation(ca)
            
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
            let imagemView = UIImageView(image: imagem)
            imagemView.contentMode = UIViewContentMode.ScaleAspectFit
            imagemView.frame = CGRectMake(0,0,40,40);
            pin.leftCalloutAccessoryView = imagemView
            
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
            self.performSegueWithIdentifier(self.identifierSegue, sender: annotation)
            
        default:
            break
        }
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let coordinate = userLocation.location!.coordinate
        
        if !isCenter {
            centralizar(self.distanciaMapa)
        }
        print("MapView --> \(NSDate()) lat:\(coordinate.latitude), long:\(coordinate.longitude)")
        
        if lastLocation.distanceFromLocation(userLocation.location!) > 100 {
            lastLocation = userLocation.location!
            updatePins()
        }
        
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print(error)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].+
        // Pass the selected object to the new view controller.

        let viewController = segue.destinationViewController as! DetailViewController
        
        
        if let ca = sender as? CustomAnnotation {
            viewController.hospital = hospitalData.findHospital(self.context, id: ca.id)!
        }
        
        viewController.originLocation = mapView.userLocation.location?.coordinate
        
    }

}
