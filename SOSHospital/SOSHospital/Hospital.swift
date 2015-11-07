//
//  Hospital.swift
//  SOSHospital
//
//  Created by William kwong huang on 27/10/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class Hospital: NSManagedObject {
    
    private let entityName = "Hospital"
    
    private enum jsonEnum: String {
        case id = "id"
        case name = "nome"
        case state = "estado"
        case coordinates = "coordinates"
        case latitude = "lat"
        case longitude = "long"
        case category = "categoria"
    }
    
    lazy var Location: CLLocation = {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }()
    
    var distance: Double = 0
    
    // MARK: - Create
    
    func createHospital(context: NSManagedObjectContext) -> Hospital {
        let item = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as! Hospital
        return item
    }
    
    // MARK: - Find
    
    func findHospitals(context: NSManagedObjectContext, name: String? = nil, state: String? = nil) -> [Hospital] {
        
        // cria a request
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        // faz algum filtro
        if let n = name, s = state {
            fetchRequest.predicate = NSPredicate(format: "name contains %@ and state contains %@", n, s)
        }
        if let s = state {
            fetchRequest.predicate = NSPredicate(format: "state contains %@", s)
        }
        if let n = name {
            fetchRequest.predicate = NSPredicate(format: "name contains %@", n)
        }

        //fetchRequest.predicate = NSPredicate(format: "id == %@", username)
        
        var result = [Hospital]()
        
        do {
            // busca a informação
            result = try context.executeFetchRequest(fetchRequest) as! [Hospital]
        } catch {
            print("Erro ao consultar: \(error)")
        }
        
        return result
    }
    
    func findHospitals(context: NSManagedObjectContext, origin: CLLocation, maxDistance: Double) -> [Hospital] {
    
        var result = [Hospital]()
        
        for item in findHospitals(context) {
            
            let meters = origin.distanceFromLocation(item.Location)
            
            if meters <= maxDistance {
                item.distance = meters
                result.append(item)
            }
            
        }
        
        return result
    }
    
    func findHospital(context: NSManagedObjectContext, id: Int) -> Hospital? {
        
        // cria a request
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        // faz algum filtro
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        var result : Hospital?
        
        do {
            // busca a informação
            result = try (context.executeFetchRequest(fetchRequest) as! [Hospital]).first
        } catch {
            print("Erro ao consultar id(\(id)): \(error)")
        }
        
        return result
    }
    
    // MARK: - Save
    
    func save(context: NSManagedObjectContext, data: JSON) {
        
        // Verifica se a categoria e um hospital
        if data[jsonEnum.category.rawValue].intValue != 1 {
            return
        }
        
        // Cria uma variavel de controle
        let hospital : Hospital
        
        // Verifica se já existe hospital cadastrado
        //  - se existir, deverá atribuir na variavel hospital
        //  - se não existir, deverá:
        //      - criar o objeto Hospital a partir do CoreData
        //      - atribuir o id
        
        if let founded = findHospital(context, id: Int(data["id"].intValue)) {
            hospital = founded
        }
        else {
            hospital = createHospital(context)
            hospital.id = Int64(data[jsonEnum.id.rawValue].intValue)
        }

        hospital.name = data[jsonEnum.name.rawValue].stringValue
        hospital.state = data[jsonEnum.state.rawValue].stringValue
        hospital.latitude = data[jsonEnum.coordinates.rawValue][jsonEnum.latitude.rawValue].doubleValue
        hospital.longitude = data[jsonEnum.coordinates.rawValue][jsonEnum.longitude.rawValue].doubleValue
        
        //        if let  c    = data["coordinates"] as? [String: AnyObject],
        //                lat  = c["lat"] as? String,
        //                long = c["long"] as? String {
        //
        //                hospital.latitude = NSDecimalNumber(string: lat)
        //                hospital.longitude = NSDecimalNumber(string: long)
        //        }

        
        // Validação
        if ((hospital.name?.isEmpty) != nil) {
            
        }
        
        if ((hospital.state?.isEmpty) != nil) {
            
        }
        
        if hospital.latitude.isZero {
            
        }
        
        if hospital.longitude.isZero {
            
        }
        
        
        // Inserir | Atualizar no CoreData
        do {
            try context.save()
            //print(hospital)
        } catch  {
            print("Erro ao salvar hospital \(hospital.name)): \n\n \(error)")
        }
    }
    
    
}
