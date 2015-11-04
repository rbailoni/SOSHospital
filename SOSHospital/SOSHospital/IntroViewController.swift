//
//  IntroViewController.swift
//  SOSHospital
//
//  Created by William kwong huang on 31/10/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit

///
/// ViewController para o carregamento das informações iniciais do app
///
class IntroViewController: UIViewController {
    
    private var identifierSegue = "principalSegue"
    
    private var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private var hospitalData = Hospital()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Caso o CoreData nao tenha dados, faz a primeira carga
        if hospitalData.findHospitals(context).count <= 0 {
            
            print("Carregando dados!")
            
            // Inicia o bloco assincrono em background
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                
                if let arquivoJSON = NSBundle.mainBundle().URLForResource("data", withExtension: "json"),
                       dataJSON = NSData(contentsOfURL: arquivoJSON) {
                        
                        let json = JSON(data: dataJSON)
                        for (_, item): (String, JSON) in json {
                            self.hospitalData.save(self.context, data: item)
                        }
                        
                }
                
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
                
                print("CoreData foi carregado!")
                
                // Chama imediatamente a próxima tela
                dispatch_sync(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier(self.identifierSegue, sender: self)
                }
            }
            
        }
        else {
            print("Não há dados para carregar!")
            
            // Carga já foi feita, então carrega a página
            self.performSegueWithIdentifier(self.identifierSegue, sender: self)
        }
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
