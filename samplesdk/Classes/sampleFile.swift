//
//  sampleFile.swift
//  paasmerSDK
//
//  Created by MOBODEX INC on 4/20/17.
//  Copyright © 2017 mobodexter. All rights reserved.
//

import Foundation

public class Paasmer: NSObject {
   
      public override init(){
        
      }
      public func Login(parameters:NSDictionary,success:@escaping (_ message: String)->(),failure:@escaping (_ message: String)->()) {
       
        if (parameters.value(forKey: "email")!) as? String == "" || (parameters.value(forKey: "password")!) as? String == "" {
             failure("Username and Password are necessary")
            }
           
         else{
        let post = "email=\(parameters.value(forKey: "email")!)&password=\(parameters.value(forKey: "password")!)"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let url = URL(string: "http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmer/loginvalidation.php")!
        let postLength = "\(postData?.count)"
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData;
           
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error ==
                nil else {
                
                print("error=\(error)")
                //let message:String = (error as? String)!
                failure("errorrrrrr")
                return
            }
            
            guard let data = data else {
                 failure("Data Error")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
                print("jsonn=\(json)")
                if (json != nil)
                {
                    
                    let loginDict:NSDictionary = json! as [AnyHashable:Any] as NSDictionary
                    let status:Int = (loginDict.value(forKey: "success") as? Int)!
                    let message:String = loginDict.value(forKey: "message") as! String
                     DispatchQueue.main.async {
                    if status == 1 {
                        
                         success(message)
                    }
                    else{
                        failure(message)
                        }
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
    public func Signup(parameters:NSDictionary,success:@escaping (_ message: String)->(),failure:@escaping (_ message: String)->()) {
        if (parameters.value(forKey: "username")!) as? String == "" || (parameters.value(forKey: "mobile")!) as? String == "" || (parameters.value(forKey: "pass")!) as? String == "" || (parameters.value(forKey: "email")!) as? String == ""{
            failure("Username,MobileNumber and Password are necessary")
           
        }
        if (parameters.value(forKey: "pass")! as? String) != (parameters.value(forKey: "cpass")! as? String){
           
            failure("Password and ConformPassword must be same")
            
        }
        if ((parameters.value(forKey: "mobile") as? String)?.characters.count)! < 10 || ((parameters.value(forKey: "mobile") as? String)?.characters.count)! > 10{
            failure("Please give the correct mobile number of 10 digits")
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailStatus = emailTest.evaluate(with: (parameters.value(forKey: "email")) as? String)

        if emailStatus == false {
            failure("Email format was wrong please enter correct Email")
        }
        else{
        let post = "username=\(parameters.value(forKey: "username")!)&pass=\(parameters.value(forKey: "pass")!)&email=\(parameters.value(forKey: "email")!)&mobile=\(parameters.value(forKey: "mobile")!)&cpass=\(parameters.value(forKey: "cpass")!)&country=\(parameters.value(forKey: "country")!)&state=\(parameters.value(forKey: "state")!)&purpose=\(parameters.value(forKey: "purpose")!)"
        print(post)
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        
        let url = URL(string: "http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmer/userregistration.php")
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
                   
                  failure("Data error")
                  
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    
                    print("jsonn=\(json)")
                    if (json != nil)
                    {
                        let loginDict:NSDictionary = json! as [AnyHashable:Any] as NSDictionary
                        let status:String = (loginDict.value(forKey: "success") as! String)
                        let message:String = (loginDict.value(forKey: "message") as! String)
                        DispatchQueue.main.async {
                        if status == "1" {
                            
                                success(message)
                        }
                        else{
                               failure(message)                        }
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
public func SignupConfirm(parameters:NSDictionary,success:@escaping (_ dict: NSDictionary)->(),failure:@escaping (_ message: String)->()) {
    let post = "email=\(parameters.value(forKey: "email")!)&code=\(parameters.value(forKey: "code")!)"
    var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
    let url = URL(string: "http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmer/emailverifyforsdk.php")!
    let postLength = "\(postData?.count)"
    let request = NSMutableURLRequest(url: url as URL)
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
            
           failure("Data Error")
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
         failure("JSON serialization error")
            
        }
    })
    task.resume()
    }
  public func forgotPassword(parameters:NSDictionary,success:@escaping (_ message: String)->(),failure:@escaping (_ message: String)->()) {
    if (parameters.value(forKey: "email")!) as? String == ""{
        failure("Email was empty so please give the mail")
    }
    let post = "email=\(parameters.value(forKey: "email")!)"
    var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
    let url = URL(string: "http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmer/resetpassword.php")!
    let postLength = "\(postData?.count)"
    let request = NSMutableURLRequest(url: url as URL)
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
            
            failure("Data Error")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
            
            print("jsonn=\(json)")
            if (json != nil)
            {
                
                let Dict:NSDictionary = json! as [AnyHashable:Any] as NSDictionary
                
                let status:String = (Dict.value(forKey: "success") as! String)
                let message:String = (Dict.value(forKey: "message") as! String)
                DispatchQueue.main.async {
                    if status == "1" {
                        
                        success(message)
                    }
                    else{
                        failure(message)                        }
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
    
public func ResetPassword
    (parameters:NSDictionary,success:@escaping (_ message: String)->(),failure:@escaping (_ message: String)->()) {
    let post = "email=\(parameters.value(forKey: "email")!)&password=\(parameters.value(forKey: "password")!)&code=\(parameters.value(forKey: "code")!)"
    var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
    let url = URL(string: "http://ec2-52-41-46-86.us-west-2.compute.amazonaws.com/paasmer/verifyuserforgotpassword.php")!
    let postLength = "\(postData?.count)"
    let request = NSMutableURLRequest(url: url as URL)
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
            
            failure("Data Error")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
            
            print("jsonn=\(json)")
            if (json != nil)
            {
                
                let Dict:NSDictionary = json! as [AnyHashable:Any] as NSDictionary
                let status:Int = (Dict.value(forKey: "success") as! Int)
                let message:String = (Dict.value(forKey: "message") as! String)
                DispatchQueue.main.async {
                    if status == 1 {
                        
                        success(message)
                    }
                    else{
                        failure(message)                        }
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




