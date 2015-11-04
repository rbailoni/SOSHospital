//
//  CLLocationManagerExtension.swift
//  SOSHospital
//
//  Created by William kwong huang on 04/11/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationManager {
    
    func requestAuthorization() {
        
        // Verifica se o serviço de localização está habilitado
        if CLLocationManager.locationServicesEnabled() {
            //locationManager = CLLocationManager()
            //self.locationManager?.delegate = self
            
            switch CLLocationManager.authorizationStatus() {
                
                // AuthorizedAlways: usuário permitiu sempre
                // AuthorizedWhenInUse: usuário permitiu quando app aberto
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                self.desiredAccuracy = kCLLocationAccuracyHundredMeters
                self.requestAlwaysAuthorization()
                self.startUpdatingLocation()
                break
                
                // NotDetermined: usuário ainda não escolheu autorizar
            case .NotDetermined:
                self.requestWhenInUseAuthorization()
                break
                
                // Restricted: usuário tem restrição para ligar a localização
                // Denied: usuário negou a localização
            case .Restricted, .Denied:
                
                // TODO:
                // Fazer um alerta
                print("usuário negou a localização")
                break
            }
            
        }
        
    }
    
}
