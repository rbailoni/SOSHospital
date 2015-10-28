//
//  ViewController.swift
//  SOSHospital
//
//  Created by Swift-Noturno on 27/10/15.
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
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let arquivoJSON = NSBundle.mainBundle().URLForResource("data", withExtension: "json"),
//               dataJSON = NSData(contentsOfURL: arquivoJSON) {
//                
//                let json = JSON(data: dataJSON)
//
//                //print(item["nome"].stringValue)
//                
//                for (_, item): (String, JSON) in json {
//                    
//                    hosp.save(context, data: item)
//                    
//                }
//                
//        }
//        print("terminou!")
        
        let lst = hosp.findHospitals(context, name: nil, state: "SP")
        for h: Hospital in lst {
            print("Hospital: \(h.name!)")
        }
        print("Total de hospitais cadastrados: \(lst.count)")

        
        // Modo NSJSONSerialization
        //do {
        //    if let arquivoJSON = NSBundle.mainBundle().URLForResource("data", withExtension: "json"),
        //        dataJSON = NSData(contentsOfURL: arquivoJSON),
        //        json = try NSJSONSerialization.JSONObjectWithData(dataJSON, options: []) as? [AnyObject] {
        //
        //            let x = json[0] as! [String: AnyObject]
        //            print(x)
        //
        //            hosp.saveHospital(x)
        //    }
        //}
        //catch {
        //    print("Um erro aconteceu! \(error)")
        //}
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

