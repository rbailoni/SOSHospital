//
//  HospitalViewController.swift
//  SOSHospital
//
//  Created by William kwong huang on 04/11/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var hospitalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var hospital: Hospital!
    var originLocation: CLLocationCoordinate2D!
    
    private enum Apps: String {
        case Waze = "waze"
        case GoogleMaps = "comgooglemaps"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _ = hospital else {
            return
        }
        
        self.nameLabel.text = hospital.name
        self.addressLabel.text = hospital.state
        
    }
    
    private func abrirRota(app: Apps) {
        
        let url = NSURL(string: "\(app.rawValue)://")!
        
        if UIApplication.sharedApplication().canOpenURL(url) {
            
            switch app {
            case Apps.Waze:
                openUrl("waze://?ll=\(hospital!.latitude),\(hospital!.longitude)&navigate=yes")
            case Apps.GoogleMaps:
                openUrl("comgooglemaps://?saddr=\(originLocation.latitude),\(originLocation.longitude)&daddr=\(hospital.latitude),\(hospital.longitude)&directionsmode=driving")
            }
            
        }
        else {
            let alertaSemApp = UIAlertController(
                title: "Sem App",
                message: "Este aplicativo não está instalado. Deseja instalar agora?",
                preferredStyle: .Alert
            )
            
            alertaSemApp.addAction(UIAlertAction(title: "Sim", style: .Cancel)
                { action -> Void in
                    switch app {
                    case .Waze:
                        self.openUrl("https://itunes.apple.com/br/app/waze-gps-social-mapas-e-transito/id323229106?mt=8")
                    case .GoogleMaps:
                        self.openUrl("https://itunes.apple.com/br/app/google-maps/id585027354?mt=8")
                    }
                }
            )
            
            alertaSemApp.addAction(UIAlertAction(title: "Não", style: .Default, handler: nil))
            presentViewController(alertaSemApp, animated: true, completion: nil)
        }
        
    }
    
    private func openUrl(urlString: String) {
        
        let url = NSURL(string: urlString)
        UIApplication.sharedApplication().openURL(url!)
        
    }
    
    
    @IBAction func appleMapsSelected(sender: UIButton) {
        
    }
    
    @IBAction func googleMapsSelected(sender: UIButton) {
        abrirRota(Apps.GoogleMaps)
    }
    
    @IBAction func wazeSelected(sender: UIButton) {
        abrirRota(Apps.Waze)
    }
    
}
