//
//  DeviceList.swift
//  paasmerSDK
//
//  Created by MOBODEX INC on 4/24/17.
//  Copyright © 2017 mobodexter. All rights reserved.
//

import Foundation
public class DeviceListInformation: NSObject {
    public override init(){
        
    }
    public func DeviceList(parameters:NSDictionary,success:@escaping (_ deviceList: [String])->(),failure:@escaping (_ message: String)->()) {
        let post = "email=\(parameters.value(forKey: "email")!)"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let url = URL(string: "http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmer/deviceinfo.php")
        let postLength = "\(postData?.count)"
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                
                print("error=\(error)")
                let message:String = error as! String
                failure(message)
                return
            }
            
            guard let data = data else {
               failure("error")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
                print("jsonn=\(json)")
                if (json != nil)
                {
                    let loginDict:NSDictionary = json! as [AnyHashable:Any] as NSDictionary
                    let deviceNames = (loginDict.value(forKey: "Devicenames") as! NSArray)
                     DispatchQueue.main.async {
                    success(deviceNames as! [String])
                }
                }
            }
            catch
            {
                failure("failed")
            }
        })
        task.resume()
        
    }
}
public class DeviceData: NSObject {
    public override init(){
        
    }
   
    public func data(parameters:NSDictionary,success:@escaping (_ Data: NSDictionary)->(),failure:@escaping (_ message: String)->()) {
        let post = "email=\(parameters.value(forKey: "email")!)&devicename=\(parameters.value(forKey: "devicename")!)"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let url = URL(string: "http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmer/devicessensordata1.php")
        let postLength = "\(postData?.count)"
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData;
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                
                print("error=\(error)")
                failure("JSON error response")
                return
            }
            
            guard let data = data else {
               failure("JSON data error response")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
                print("jsonn=\(json)")
                if (json != nil)
                {
                    let Dict:NSDictionary = json! as [AnyHashable:Any] as NSDictionary
                   
                    success(Dict)
                }
                
            }
            catch
            {
                failure("JSON error response")
                
            }
        })
        task.resume()
        
    }
}
public class DeviceFeedControl: NSObject {
    public override init(){
        
    }
    
    public func feedControl(parameters:NSDictionary,success:@escaping (_ response: NSDictionary)->(),failure:@escaping (_ message: String)->()) {
      let post = "control=\(parameters.value(forKey: "control")!)&state=\(parameters.value(forKey: "state")!)&email=\(parameters.value(forKey: "email")!)&devicename=\(parameters.value(forKey: "devicename")!)"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let url = URL(string: "http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmer/feedcontrol.php")
        let postLength = "\(postData?.count)"
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData;
       
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                
                print("error=\(error)")
                failure("JSON error response")
                return
            }
            
            guard let data = data else {
               failure("JSON data error")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
                print("my total jsonn=\(json)")
                 DispatchQueue.main.async {
                if (json != nil)
                {
                    
                    let Dict:NSDictionary = json! as [AnyHashable:Any] as NSDictionary
                   
                     success(Dict)
                   
                }
                }
            }
            catch
            {
                failure("JSON serialization error")
                
            }
        })
        task.resume()
        
    }
}

