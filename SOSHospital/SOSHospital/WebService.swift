//
//  WebService.swift
//  SOSHospital
//
//  Created by Swift-Noturno on 27/10/15.
//  Copyright © 2015 Quaddro. All rights reserved.
//

import UIKit

class WebService {
    
    private let baseURL = NSURL(string: "http://api.databr.io:80")!
    private let apiVersion = "/v1"
    private let endpoint = "/states/sp/reservoirs"
    private var serviceURL: NSURL {
        return baseURL.URLByAppendingPathComponent(apiVersion + endpoint)
    }

    // MARK: - Session
    
    private var sessionConfig: NSURLSessionConfiguration {
        return NSURLSessionConfiguration.defaultSessionConfiguration()
    }
    
    private lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.sessionConfig)
    }()

    private func request(completion: (data: JSON?, error: NSError?) -> Void) {
        
        var json: JSON?
        
        session.dataTaskWithURL(serviceURL) { ( data: NSData?,
                                                response: NSURLResponse?,
                                                error: NSError?) -> Void in
            
//            println(data)
//            println(response)
//            println(error)
            
//            do {
//                json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments )as? [String: AnyObject]
//            }
//            catch let error as NSError {
//                errorData = error
//            }
//            catch {
//                print(error)
//            }
            
            if error == nil {

                json = JSON(data: data!)
                
            }
            
            // como estamos em background é melhor chamar em main_queue
            // assim se atualizar a interface já está pronto
            dispatch_sync(dispatch_get_main_queue()) {
                completion(data: json, error: error)
            }
        }.resume()
    }

}
