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

class FilterTableViewController:  UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var hospitals = [Hospital]()
    
    @IBOutlet var searchTextField: UITextField!
    
    private var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private var hospitalData = Hospital()
    
    var locationManager = CLLocationManager()
    private var lastLocation = CLLocation(latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField.delegate = self
        self.locationManager.delegate = self
        print("bem vindo filtro")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if !self.locationManager.requestAuthorization() {
            presentViewController(self.locationManager.showNegativeAlert(), animated: true, completion: nil)
        }
        
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let text = textField.text
        print(text)
        loadTableView(text)
        
        self.searchTextField.resignFirstResponder()
        return true
    }
    
    private func loadTableView(searchString: String? = nil) {
        
        // Localização do usuário
        guard let userLocation = locationManager.location else {
            return
        }
        
        // Limpa o array de hospitais
        self.hospitals.removeAll()
        
        self.hospitals = hospitalData.findHospitals(self.context, origin: userLocation, maxDistance: 5_000)

        if searchString != nil {
            if let search = searchString {
                let searchHospital = hospitals.filter { (item) -> Bool in
                    item.name!.containsString("\(search)")
                }
                self.hospitals = searchHospital
            }
        }
        
        // Ordena por distancia
        self.hospitals.sortInPlace({$0.distance < $1.distance})
        
        self.tableView.reloadData()
        
    }
    
    @IBAction func showOptions(sender: UIBarButtonItem) {
        
        let alerta = UIAlertController(
            title: "Filtro",
            message: "Selecione o filtro",
            preferredStyle: UIAlertControllerStyle.ActionSheet
        )
        
        // adicionar ações
        let cancelAction = UIAlertAction(
            title: "Cancelar",
            style: UIAlertActionStyle.Cancel) { (action) -> Void in
                
        }
        
        let filterPerDistance = UIAlertAction(
            title: "Filtrar por distância",
            style: UIAlertActionStyle.Default) { (action) -> Void in
        
                self.hospitals.sortInPlace({$0.distance < $1.distance})
                self.tableView.reloadData()
        }
        
        let filterPerNameAction = UIAlertAction(
            title: "Filtrar por nome",
            style: UIAlertActionStyle.Default) { (action) -> Void in

                self.hospitals.sortInPlace({$0.name < $1.name})
                self.tableView.reloadData()
        }
        
        alerta.addAction(cancelAction)
        alerta.addAction(filterPerDistance)
        alerta.addAction(filterPerNameAction)
        
        // exibir alerta
        presentViewController(alerta, animated: true, completion: nil)
        
    }

    
    // MARK LocationManager
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let coordinate = locations.last!.coordinate
        print("Filter --> \(NSDate()) lat:\(coordinate.latitude), long:\(coordinate.longitude)")
        
        if let loc = locationManager.location {
            if lastLocation.distanceFromLocation(loc) > 100 {
                lastLocation = locationManager.location!
                loadTableView()
            }
        }
        
        // para a atualizacao da localizacao
        locationManager.stopUpdatingLocation()
        
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
        
        cell.imagemView.image = UIImage(named: FilterCell.HospitalNameImage)

        return cell
    }
    
    @IBAction func refreshTableView(sender: UIRefreshControl) {
        
        self.searchTextField.text = ""
        locationManager.startUpdatingLocation()
        sender.endRefreshing()
        
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].+
        // Pass the selected object to the new view controller.
        
        let viewController = segue.destinationViewController as! DetailViewController

        if let indexPathSelecionado = tableView.indexPathForSelectedRow {
            
            viewController.hospital = hospitals[indexPathSelecionado.row]
            viewController.originLocation = locationManager.location?.coordinate
        }
        
    }
    
}
