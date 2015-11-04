//
//  ViewController.swift
//  SOSHospital
//
//  Created by William kwong huang on 27/10/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    let hosp = Hospital()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Teste de retorno com todos os hospitais em SP
        let lst = hosp.findHospitals(context, name: nil, state: "SP")
        for h: Hospital in lst {
            print("Hospital: \(h.name!)")
        }
        print("Total de hospitais cadastrados: \(lst.count)")
    }
    
}

