//
//  Hospital.swift
//  SOSHospital
//
//  Created by Swift-Noturno on 27/10/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit
import CoreData

class Hospital: NSManagedObject {
    
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    private func findAllHospitals() -> [Hospital] {
        
        // Criar request
        let fetchRequest = NSFetchRequest(entityName: "Hospital")
        //fetchRequest.predicate = NSPredicate(format: "id == %@", username)
        
        // Executar request
        
        var result = [Hospital]()
        
        do {
            result = try context.executeFetchRequest(fetchRequest) as! [Hospital]
        } catch {
            print("Erro ao consultar: \(error)")
        }
        
        // Ler resultado
        return result
    }
    
    private func findHospital(id: Int) -> Hospital? {
        
        // Criar request
        let fetchRequest = NSFetchRequest(entityName: "Hospital")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        // Executar request
        
        var result : Hospital?
        
        do {
            result = try (context.executeFetchRequest(fetchRequest) as! [Hospital]).first
        } catch {
            print("Erro ao consultar: \(error)")
        }
        
        return result
    }
    
    private func saveHospital(data: [String: AnyObject]) {
        
        let hospital : Hospital
        
        // Verifica se já existe hospital cadastrado
        if let searchHospital = findHospital(data["id"] as! Int) {
            
            hospital = searchHospital
            
        }
        else {
            
            // Criar Hospital
            hospital = NSEntityDescription.insertNewObjectForEntityForName("Hospital", inManagedObjectContext: context) as! Hospital
            hospital.id = data["id"] as? NSNumber
            
        }
        
        hospital.name = data["name"]?.string
        hospital.descriptionHospital = data["description"]?.string
        hospital.latitude = data["latitude"] as? NSDecimalNumber
        hospital.longitude = data["longitude"] as? NSDecimalNumber
        
        // 3: Inserir/Atualizar no "banco"
        do {
            try context.save()
        } catch  {
            print("Erro ao salvar: \(error)")
        }
    }
    
    
}
