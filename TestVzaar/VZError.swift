//
//  VZError.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import Foundation
import UIKit

class VZError: NSObject{

    static func alert(viewController: UIViewController, errors: NSArray){
        
        if let error = errors[0] as? NSDictionary{
            if let message = error["detail"] as? String, let title = error["message"] as? String{
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                viewController.present(alertController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    static func alert(viewController: UIViewController, title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
}
