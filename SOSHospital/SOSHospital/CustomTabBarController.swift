//
//  CustomTabBarController.swift
//  SOSHospital
//
//  Created by William kwong huang on 11/3/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit
import CoreLocation

class CustomTabBarController: UITabBarController, CLLocationManagerDelegate {
    
    // MARK: Variaveis globais
    
    private var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private var hospitalData = Hospital()
    
    var locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        print("bem vindo tabBar")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.locationManager.requestAuthorization()
        
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        // Tomar cuidado
        switch item.title! {
            
        // Mapa
        //case 0:
            
        // Filtro
//        case "Filtro":
            
//            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            
//            let controller = storyBoard.instantiateViewControllerWithIdentifier("FilterTableViewController") as? FilterTableViewController
//            
//            controller?.locationManager = self.locationManager
            
            
        // Credito
        case "Créditos":
            locationManager.stopUpdatingLocation()
            
        default:
            locationManager.requestAuthorization()
            break
        }
        
    }
    
    // MARK: Location Manager Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.coordinate = locations.last!.coordinate
        print("TabBar --> \(NSDate()) lat:\(coordinate!.latitude), long:\(coordinate!.longitude)")
        locationManager.stopUpdatingLocation()

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
}
