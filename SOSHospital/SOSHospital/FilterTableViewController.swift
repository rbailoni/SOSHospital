//
//  FilterTableViewController.swift
//  SOSHospital
//
//  Created by William kwong huang on 11/3/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class FilterTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var hospitals = [Hospital]()
    
    @IBOutlet var searchTextField: UITextField!
    
    private var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private var hospitalData = Hospital()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        print("bem vindo filtro")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        locationManager.requestAuthorization()
        
    }
    
    private func loadTableView() {
        
        // Localização do usuário
        guard let userLocation = locationManager.location else {
            return
        }
        
        // para a atualizacao da localizacao
        locationManager.stopUpdatingLocation()
        
        // Limpa o array de hospitais
        self.hospitals.removeAll()
        
        for hosp: Hospital in hospitalData.findHospitals(self.context) {
            
            // Verifica se o hospital esta proximo
            let meters = userLocation.distanceFromLocation(hosp.Location)
            
            if meters <= 5_000 {
                
                hosp.distance = Int(meters)
                hospitals.append(hosp)
                
            }
        }
        
        // Ordena por distancia
        self.hospitals.sortInPlace({$0.distance < $1.distance})
        
        self.tableView.reloadData()
        
    }

    
    // MARK LocationManager
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let coordinate = locations.last!.coordinate
        print("Filter --> \(NSDate()) lat:\(coordinate.latitude), long:\(coordinate.longitude)")
        loadTableView()
        
    }
    
    // MARK: TableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hospitals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FilterCell.Identifier, forIndexPath: indexPath) as! FilterCell
        
        let hospital = self.hospitals[indexPath.row]
        
        cell.hospitalLabel.text = hospital.name
        
        cell.distanceLabel.text = "distância: \(hospital.distance)m"
        
        cell.imagemView.image = UIImage(named: "Hospital")

        return cell
    }
    
    @IBAction func refreshTableView(sender: UIRefreshControl) {
        
        locationManager.startUpdatingLocation()
        sender.endRefreshing()
        
    }
    
}
