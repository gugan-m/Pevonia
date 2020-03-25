//
//  WebServiceWrapper.swift
//  WebServiceWrapperDemo
//
//  Created by SwaaS on 30/09/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class WebServiceWrapper: NSObject
{
    static let sharedInstance = WebServiceWrapper()
    let queue = OperationQueue()
    func getApi (urlString: String, screenName: ScreenName, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        if (checkInternetConnectivity())
        {
            let urlValue = urlString.replacingOccurrences(of: " ", with: "")
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let request = NSMutableURLRequest(url: NSURL(string: urlValue)! as URL)
            var task = URLSessionDataTask()
            
            request.httpMethod = wsGET
            request.timeoutInterval = wsTimeOutInterval
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                // Background thread
                task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        // UI Updates
                        if data != nil
                        {
                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                            {
                                if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                                {
                                    if let jsonDict = json as? NSDictionary
                                    {
                                        completion(ApiResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
                                    }
                                    else
                                    {
                                        completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                    }
                                }
                                else
                                {
                                    completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                }
                            }
                            else if let response = response as? HTTPURLResponse
                            {
                                if (response.statusCode == NSURLErrorCancelled || response.statusCode == NSURLErrorTimedOut || response.statusCode == NSURLErrorCannotConnectToHost || response.statusCode == NSURLErrorNetworkConnectionLost || response.statusCode == NSURLErrorNotConnectedToInternet || response.statusCode == NSURLErrorInternationalRoamingOff || response.statusCode == NSURLErrorCallIsActive || response.statusCode == NSURLErrorDataNotAllowed)
                                {
                                    completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                                }
                            }
                            else
                            {
//                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                            }
                        }
                        else
                        {
                            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                        }
                    })
                    
                    //ApiSharedInstance.sharedInstance.removeRequestInList(screenName, requestObj: task!)
                }
                
                task.resume()
                
                //ApiSharedInstance.sharedInstance.addRequestInList(screenName, request: task!)
            }
        }
        else
        {
            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
        }
    }
    
    /*
        Some API might send dictionary as post data and some API might send string as post data. 
     
        --Parameter: dataDictionary - Send value for this parameter if the API expects post data in a dictionary format and send nil value for stringData parameter
        --Parameter: stringData - Send value for this parameter if the API expects post data in a string format and send nil value for dataDictionary parameter
    */
    
    func postApi (urlString: String, dataDictionary: [String: Any]?, stringData: String?, screenName: ScreenName, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        if (checkInternetConnectivity())
        {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
            
            request.httpMethod = wsPOST
            request.timeoutInterval = wsTimeOutInterval
            
            if (dataDictionary != nil)
            {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                do
                {
                    request.httpBody = try JSONSerialization.data(withJSONObject: dataDictionary!, options: .prettyPrinted)
                }
                catch
                {
                    completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                }
            }
            else
            {
                request.httpBody = stringData?.data(using: String.Encoding.utf8)
            }
            
            var task = URLSessionDataTask()
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                
                task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if data != nil
                        {
                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                            {
                                if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                                {
                                    if let jsonDict = json as? NSDictionary
                                    {
                                        completion(ApiResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
                                    }
                                    else
                                    {
                                        completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                    }
                                }
                                else
                                {
                                    completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                }
                            }
                            else if let response = response as? HTTPURLResponse
                            {
                                if (response.statusCode == NSURLErrorCancelled || response.statusCode == NSURLErrorTimedOut || response.statusCode == NSURLErrorCannotConnectToHost || response.statusCode == NSURLErrorNetworkConnectionLost || response.statusCode == NSURLErrorNotConnectedToInternet || response.statusCode == NSURLErrorInternationalRoamingOff || response.statusCode == NSURLErrorCallIsActive || response.statusCode == NSURLErrorDataNotAllowed)
                                {
                                    completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                                }
                            }
                            else
                            {
//                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                            }
                        }
                        else
                        {
                            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                        }
                        
                        //ApiSharedInstance.sharedInstance.removeRequestInList(screenName, requestObj: task!)
                    })
                }
                
                task.resume()
                
                //ApiSharedInstance.sharedInstance.addRequestInList(screenName, request: task!)
            }
        }
        else
        {
            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
        }
    }
    
    func postApiWithAnyObject(urlString: String, dataDictionary: Any, stringData: String?, screenName: ScreenName, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        if (checkInternetConnectivity())
        {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
            
            request.httpMethod = wsPOST
            request.timeoutInterval = wsTimeOutInterval
            print(dataDictionary)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do
            {
                request.httpBody = try JSONSerialization.data(withJSONObject: dataDictionary, options: .prettyPrinted)
            }
            catch
            {
                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
            }
            
            var task = URLSessionDataTask()
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                
                task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if data != nil
                        {
                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                            {
                                if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                                {
                                    if let jsonDict = json as? NSDictionary
                                    {
                                        completion(ApiResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
                                        print(jsonDict)
                                    }
                                    else
                                    {
                                        completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                    }
                                }
                                else
                                {
//                                    completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                    completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                                }
                            }
                            else if let response = response as? HTTPURLResponse
                            {
                                if (response.statusCode == NSURLErrorCancelled || response.statusCode == NSURLErrorTimedOut || response.statusCode == NSURLErrorCannotConnectToHost || response.statusCode == NSURLErrorNetworkConnectionLost || response.statusCode == NSURLErrorNotConnectedToInternet || response.statusCode == NSURLErrorInternationalRoamingOff || response.statusCode == NSURLErrorCallIsActive || response.statusCode == NSURLErrorDataNotAllowed)
                                {
                                    completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                                }
                                else
                                {
                                    completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                }
                            }
                            else
                            {
//                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                            }
                        }
                        else
                        {
                            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                        }
                        
                        //ApiSharedInstance.sharedInstance.removeRequestInList(screenName, requestObj: task!)
                    })
                }
                
                task.resume()
                
                //ApiSharedInstance.sharedInstance.addRequestInList(screenName, request: task!)
            }
        }
        else
        {
            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
        }
    }
    
    func postApiWithJSON (urlString: String, jsonString: String?, screenName: ScreenName, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        if (checkInternetConnectivity())
        {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
            
            request.httpMethod = wsPOST
            request.timeoutInterval = wsTimeOutInterval
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonString?.data(using: String.Encoding.utf8)
            
            var task = URLSessionDataTask()
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                
                task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if data != nil
                        {
                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                            {
                                if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                                {
                                    if let jsonDict = json as? NSDictionary
                                    {
                                        completion(ApiResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
                                    }
                                    else
                                    {
                                        completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                    }
                                }
                                else
                                {
//                                    completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                    completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                                }
                            }
                            else if let response = response as? HTTPURLResponse
                            {
                                if (response.statusCode == NSURLErrorCancelled || response.statusCode == NSURLErrorTimedOut || response.statusCode == NSURLErrorCannotConnectToHost || response.statusCode == NSURLErrorNetworkConnectionLost || response.statusCode == NSURLErrorNotConnectedToInternet || response.statusCode == NSURLErrorInternationalRoamingOff || response.statusCode == NSURLErrorCallIsActive || response.statusCode == NSURLErrorDataNotAllowed)
                                {
                                    completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                                }
                            }
                            else
                            {
//                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                                completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                            }
                        }
                        else
                        {
                            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                        }
                        
                        //ApiSharedInstance.sharedInstance.removeRequestInList(screenName, requestObj: task!)
                    })
                }
                
                task.resume()
                
                //ApiSharedInstance.sharedInstance.addRequestInList(screenName, request: task!)
            }
        }
        else
        {
            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?) -> Void)
    {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                DispatchQueue.main.async(execute: {
                    if data != nil
                    {
                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                        {
                            completion(data)
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                    else
                    {
                        completion(nil)
                    }
                })
            }.resume()
        }
    }
    
//    func postKennectApi (urlString: String, dataDictionary: [String: Any]?, completion: @escaping (_ apiResponseObject: KennectResponseModel) -> ())
//    {
////        let headers = [
////            "Authorization": "",
////            "Content-Type": "application/json",
////            "cache-control": "no-cache",
////            "Postman-Token": "a70031f8-0186-4bcb-8e46-d5ecc6130500"
////        ]
////        let parameters = ["tenantGID": "362"] as [String : Any]
////
////        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
////
////        let request = NSMutableURLRequest(url: NSURL(string: "https://api.betkennect.xyz/tenant/v0.1/user/get-auth")! as URL,
////                                          cachePolicy: .useProtocolCachePolicy,
////                                          timeoutInterval: 10.0)
////        request.httpMethod = "POST"
////        request.allHTTPHeaderFields = headers
////        request.httpBody = postData as! Data
////
////        let session = URLSession.shared
////        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
////            if (error != nil) {
////                print(error)
////            } else {
////                let httpResponse = response as? HTTPURLResponse
////                print(httpResponse)
////                if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
////                {
////                    if let jsonDict = json as? NSDictionary
////                    {
////                        completion(KennectResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
////                    }
////                    else
////                    {
////                        completion(KennectResponseModel.sharedInstance.getFailureApiModel())                                    }
////                }
////            }
////        })
////
////        dataTask.resume()
//
//
//
//
//
//
//
//        if (checkInternetConnectivity())
//        {
////            let session = URLSession(configuration: URLSessionConfiguration.default)
////            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
////
////            request.httpMethod = wsPOST
////            request.timeoutInterval = wsTimeOutInterval
//
//            let headers = [
//                "Authorization": authorizationKey,
//                "Content-Type": "application/json",
//                "cache-control": "no-cache",
//                "Postman-Token": "a70031f8-0186-4bcb-8e46-d5ecc6130500"
//            ]
//            let parameters = ["tenantGID": "362"] as [String : Any]
//
//            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
//
//            let request = NSMutableURLRequest(url: NSURL(string: "https://api.betkennect.xyz/tenant/v0.1/user/get-auth")! as URL,
//                                              cachePolicy: .useProtocolCachePolicy,
//                                              timeoutInterval: 10.0)
//            request.httpMethod = "POST"
//            request.allHTTPHeaderFields = headers
//            request.httpBody = postData as! Data
//
//            let session = URLSession.shared
//
//
//            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//                if (error != nil) {
//                    print(error)
//                } else {
//
//                    let httpResponse = response as? HTTPURLResponse
//                    print(httpResponse)
////                    if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
////                    {
////                        if let jsonDict = json as? NSDictionary
////                        {
////                            completion(KennectResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
////                        }
////                        else
////                        {
////                            completion(KennectResponseModel.sharedInstance.getFailureApiModel())                                    }
////                    }
////
//
//
//
//
//
//                    if data != nil
//                    {
//                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
//                        {
//                            if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
//                            {
//                                if let jsonDict = json as? NSDictionary
//                                {
//                                    completion(KennectResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
//                                }
//                                else
//                                {
//                                    completion(KennectResponseModel.sharedInstance.getFailureApiModel())                                    }
//                            }
//                            else
//                            {
//                                completion(KennectResponseModel.sharedInstance.getFailureApiModel())
//                            }
//                        }
//                        else if let response = response as? HTTPURLResponse
//                        {
//                            if (response.statusCode == NSURLErrorCancelled || response.statusCode == NSURLErrorTimedOut || response.statusCode == NSURLErrorCannotConnectToHost || response.statusCode == NSURLErrorNetworkConnectionLost || response.statusCode == NSURLErrorNotConnectedToInternet || response.statusCode == NSURLErrorInternationalRoamingOff || response.statusCode == NSURLErrorCallIsActive || response.statusCode == NSURLErrorDataNotAllowed)
//                            {
//                                completion(KennectResponseModel.sharedInstance.getFailureApiModel())                                }
//                        }
//                        else
//                        {
//                            //                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
//                            completion(KennectResponseModel.sharedInstance.getFailureApiModel())
//                        }
//                    }
//                    else
//                    {
//                        completion(KennectResponseModel.sharedInstance.getFailureApiModel())
//                    }
//
//
//
//
//
//
//
//
//
//
//
//                }
//            })
//
//            dataTask.resume()
//
//
//
//
////            if (dataDictionary != nil)
////            {
////                request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")
////                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
////
////                do
////                {
////                    request.httpBody = try JSONSerialization.data(withJSONObject: dataDictionary!, options: .prettyPrinted)
////                }
////                catch
////                {
////                    completion(KennectResponseModel.sharedInstance.getFailureApiModel())
////                }
////            }
//
//            var task = URLSessionDataTask()
//
////            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
////
////                task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
////
////                    DispatchQueue.main.async(execute: {
////
////                        if data != nil
////                        {
////                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
////                            {
////                                if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
////                                {
////                                    if let jsonDict = json as? NSDictionary
////                                    {
////                                        completion(KennectResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
////                                    }
////                                    else
////                                    {
////                                        completion(KennectResponseModel.sharedInstance.getFailureApiModel())                                    }
////                                }
////                                else
////                                {
////                                    completion(KennectResponseModel.sharedInstance.getFailureApiModel())
////                                }
////                            }
////                            else if let response = response as? HTTPURLResponse
////                            {
////                                if (response.statusCode == NSURLErrorCancelled || response.statusCode == NSURLErrorTimedOut || response.statusCode == NSURLErrorCannotConnectToHost || response.statusCode == NSURLErrorNetworkConnectionLost || response.statusCode == NSURLErrorNotConnectedToInternet || response.statusCode == NSURLErrorInternationalRoamingOff || response.statusCode == NSURLErrorCallIsActive || response.statusCode == NSURLErrorDataNotAllowed)
////                                {
////                                    completion(KennectResponseModel.sharedInstance.getFailureApiModel())                                }
////                            }
////                            else
////                            {
////                                //                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
////                                completion(KennectResponseModel.sharedInstance.getFailureApiModel())
////                            }
////                        }
////                        else
////                        {
////                            completion(KennectResponseModel.sharedInstance.getFailureApiModel())
////                        }
////
////                        //ApiSharedInstance.sharedInstance.removeRequestInList(screenName, requestObj: task!)
////                    })
////                }
////
////                task.resume()
////
////                //ApiSharedInstance.sharedInstance.addRequestInList(screenName, request: task!)
////            }
//        }
//        else
//        {
//            completion(KennectResponseModel.sharedInstance.getNoInternetApiModel())
//        }
//    }

    func postKennectApi (urlString: String, dataDictionary: [String: Any]?, completion: @escaping (_ apiResponseObject: [String:Any]) -> ())
    {
        if (checkInternetConnectivity())
        {
            
            let headers = [
                "Authorization": PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.MONEY_TREE_KEY),
                "Content-Type": "application/json"
            ]
            let parameters = ["tenantGID": ""] as [String : Any]
            
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.betkennect.xyz/tenant/v0.1/user/get-auth")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as! Data
            
            let session = URLSession.shared
 
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message: "Invalid Token")
//                    self.navigationController?.popViewController(animated: false)
                } else {
                    
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    
                    if let response = response as? HTTPURLResponse , 401 ~= response.statusCode
                    {
                        removeCustomActivityView()
                        AlertView.showAlertView(title: errorTitle, message: "Invalid Token")
                    }
                    
                    
                    if data != nil
                    {
                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                        {
                            if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                            {
                                if let jsonDict = json as? NSDictionary
                                {
                                    completion(jsonDict as! [String : Any])
                                }
                                else
                                {
                                    completion(["Status":SERVER_ERROR_CODE])                                    }
                            }
                            else
                            {
                                completion(["Status":SERVER_ERROR_CODE])
                            }
                        }
                        else if let response = response as? HTTPURLResponse
                        {
                            if (response.statusCode == NSURLErrorCancelled || response.statusCode == NSURLErrorTimedOut || response.statusCode == NSURLErrorCannotConnectToHost || response.statusCode == NSURLErrorNetworkConnectionLost || response.statusCode == NSURLErrorNotConnectedToInternet || response.statusCode == NSURLErrorInternationalRoamingOff || response.statusCode == NSURLErrorCallIsActive || response.statusCode == NSURLErrorDataNotAllowed)
                            {
                                completion(["Status":NO_INTERNET_ERROR_CODE])                               }
                        }
                        else
                        {
                            //                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                            completion(["Status":NO_INTERNET_ERROR_CODE])
                        }
                    }
                    else
                    {
                        completion(["Status":NO_INTERNET_ERROR_CODE])
                    }
                    
                }
            })
            
            dataTask.resume()
            
        }
        else
        {
            completion(["Status":NO_INTERNET_ERROR_CODE])
        }
    }
    
    
    func postKennectApi2 (urlString: String, dataDictionary: [String: Any]?, completion: @escaping (_ apiResponseObject: [String:Any]) -> ())
    {
        let empDetails = UserDefaults.standard.value(forKey: kennectUserDetails) as! [String:Any]
        
        if (checkInternetConnectivity())
        {
            let headers = [
                "authorization": PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.MONEY_TREE_KEY),
                "content-type": "application/json",
                "cache-control": "no-cache",
                "postman-token": "a81e6e6d-bdc3-efed-90a4-b8794f082374"
            ]
            let parameters = [
                "data": [
                    "divisionName": empDetails["Division_Name"],
                    "email": empDetails["Email_Id"],
                    "employerGID": empDetails["Employee_Number"],
                    "name": BL_InitialSetup.sharedInstance.userName,
                    "role": BL_InitialSetup.sharedInstance.userTypeName
                ],
                "mode": "update",
                "modelname": "employee_info",
                "tenantGID": BL_InitialSetup.sharedInstance.userId
                ] as [String : Any]
            
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.betkennect.xyz/twsa/v0.1/invoke/omkar_dusane-t12-wlc/datastorage")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as! Data
            
            let session = URLSession.shared
            
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    
                    if data != nil
                    {
                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                        {
                            if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                            {
                                if let jsonDict = json as? NSDictionary
                                {
                                    completion(jsonDict as! [String : Any])
                                }
                                else
                                {
                                    completion(["Status":SERVER_ERROR_CODE])                                    }
                            }
                            else
                            {
                                completion(["Status":SERVER_ERROR_CODE])
                            }
                        }
                        else if let response = response as? HTTPURLResponse
                        {
                            if (response.statusCode == NSURLErrorCancelled || response.statusCode == NSURLErrorTimedOut || response.statusCode == NSURLErrorCannotConnectToHost || response.statusCode == NSURLErrorNetworkConnectionLost || response.statusCode == NSURLErrorNotConnectedToInternet || response.statusCode == NSURLErrorInternationalRoamingOff || response.statusCode == NSURLErrorCallIsActive || response.statusCode == NSURLErrorDataNotAllowed)
                            {
                                completion(["Status":NO_INTERNET_ERROR_CODE])                               }
                        }
                        else
                        {
                            //                                completion(ApiResponseModel.sharedInstance.getFailureApiModel())
                            completion(["Status":NO_INTERNET_ERROR_CODE])
                        }
                    }
                    else
                    {
                        completion(["Status":NO_INTERNET_ERROR_CODE])
                    }
                    
                }
            })
            
            dataTask.resume()
            
        }
        else
        {
            completion(["Status":NO_INTERNET_ERROR_CODE])
        }
    }
    
    func multipartpostApi(url: String,data: [String:Any], key: String, screenName: ScreenName, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        if (checkInternetConnectivity())
        {
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
            request.httpMethod = "POST"
            request.timeoutInterval = wsTimeOutInterval
            
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let attachmentArr: NSMutableArray = NSMutableArray()
            attachmentArr.add(data)
            var attachmentJson : String = ""
            if let json = try? JSONSerialization.data(withJSONObject: attachmentArr, options: []) {
                if let content = String(data: json, encoding: String.Encoding.utf8) {
                    // here `content` is the JSON dictionary containing the String
                    print(content)
                    attachmentJson = content
                }
            }
            var str = attachmentJson
            //var str2 = str.replacingOccurrences(of: "\\/", with: "\\", options: NSString.CompareOptions.literal, range: nil)
            //var str3 = str2.replacingOccurrences(of: "$", with: "'", options: NSString.CompareOptions.literal, range: nil)
            str.removeFirst()
            str.removeLast()
            var str4 = str
            
            
            let params = [key: str4]
            print("Params \(params)")
            
            var body = Data()
            
            for (key, value) in params {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
            body.append("--\(boundary)--\r\n")
            request.httpBody = body
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            var task = URLSessionDataTask()
            
            let blockOperation = BlockOperation(block: {
                
                task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    OperationQueue.main.addOperation({
                        
                        if error != nil
                        {
                            let getError = error as NSError?
                            print("Service error \(String(describing: getError?.code))")
                            if getError?.code == -1009
                            {
                                // completion(self.getNoInternetModel())
                            }
                            else
                            {
                                //completion(self.getServerErrorModel())
                            }
                        }
                        else
                        {
                            if data != nil
                            {
                                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                                {
                                    print(response)
                                    if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                    {
                                        print(json)
                                        if let jsonDict = json as? NSDictionary
                                        {
                                            let status = jsonDict.value(forKey: "Status") as? Int
                                            
                                            if (status == SERVER_SUCCESS_CODE)
                                            {
                                                //let a  = jsonDict.value(forKey: "list")
                                                completion(ApiResponseModel.sharedInstance.getSuccessApiModel(dict: jsonDict))
                                            }
                                            else
                                            {
                                                completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            else
                            {
                                completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
                            }
                        }
                    })
                }
                
                task.resume()
            })
            queue.addOperation(blockOperation)
        }
        else
        {
            completion(ApiResponseModel.sharedInstance.getNoInternetApiModel())
        }
    }
}



class DownloadManager
{
    static let sharedInstance = DownloadManager()
    let cache = NSCache<NSString, NSData>()
    let downLoadingOperation : PendingOperations = PendingOperations()
    var downLoadedImage : [String : UIImage] = [String : UIImage]()
    
    func cancelAllPendingOperations()
    {
        self.downLoadingOperation.downloadQueue.cancelAllOperations()
    }
    
    func downLoadImageForUrl(urlString : String , additionalDetail : AnyObject , completionHandler : @escaping (UIImage? , String) -> ())
    {
        
        if let imageData = cache.object(forKey: urlString as NSString)
        {
            if let image = UIImage(data: imageData as Data)
            {
                completionHandler(image , urlString)
            }
            else
            {
                completionHandler(nil , urlString)
            }
        }
        else
        {
            if checkInternetConnectivity()
            {
                if downLoadingOperation.downloadsInProgress[urlString] == nil
                {
                    //2
                    let downloader = ImageDownloaderOperation(photoRecord: PhotoRecord.init(url: urlString))
                    
                    //3
                    downloader.completionBlock =
                    {
                        DispatchQueue.main.async(execute: {
                            self.downLoadingOperation.downloadsInProgress.removeValue(forKey: urlString)
                            
                            if let image = downloader.photoRecord.image
                            {
                                completionHandler(downloader.photoRecord.image , urlString)
                                
                                self.downLoadedImage[urlString] = image
                                
                                if let imageData = UIImagePNGRepresentation(image)
                                {
                                    self.cache.setObject(imageData as NSData, forKey: urlString as NSString)
                                }
                            }
                        })
                    }
                    
                    //4
                    downLoadingOperation.downloadQueue.maxConcurrentOperationCount = 3
                    downLoadingOperation.downloadsInProgress[urlString] = downloader
                    
                    //5
                    downLoadingOperation.downloadQueue.addOperation(downloader)
                }
            }
            else
            {
                completionHandler(nil , urlString)
            }
        }
    }
}

// This enum contains all the possible states a photo record can be in
enum PhotoRecordState
{
    case New, Downloaded, Filtered, Failed
}

class PhotoRecord
{
    var url : String = ""
    var state = PhotoRecordState.New
    var image : UIImage?
    
    init(url:String)
    {
        self.url = url
    }
}

class PendingOperations
{
    lazy var downloadsInProgress = [String:Operation]()
    
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
}

class ImageDownloaderOperation: Operation
{
    //1
    let photoRecord: PhotoRecord
    
    //2
    init(photoRecord: PhotoRecord)
    {
        self.photoRecord = photoRecord
    }
    
    //3
    override func main()
    {
        //4
        if self.isCancelled
        {
            return
        }
        //5
        
        if let encodeUrl = photoRecord.url.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        {
            if let photoUrl = NSURL(string:encodeUrl)
            {
                if let imageData = NSData.init(contentsOf: photoUrl as URL)
                {
                    //6
                    if self.isCancelled
                    {
                        return
                    }
                    
                    //7
                    if let image  = UIImage(data:imageData as Data)
                    {
                        self.photoRecord.image = image
                        self.photoRecord.state = .Downloaded
                    }
                    else
                    {
                        self.photoRecord.state = .Failed
                    }
                }
                else
                {
                    self.photoRecord.state = .Failed
                }
            }
            else
            {
                self.photoRecord.state = .Failed
            }
        }
        else
        {
            self.photoRecord.state = .Failed
        }
    }
}

class ImageLoadingWithCache
{
    let cache = NSCache<NSString, NSData>()
    static let sharedInstance = ImageLoadingWithCache()
    
    func getImage(url: String, imageView: UIImageView, textLabel: UILabel?)
    {
        if let imageData = cache.object(forKey: url as NSString)
        {
            imageView.image = Bl_Attachment.sharedInstance.imageResize(imageObj: UIImage(data: imageData as Data)!)
            
            if (textLabel != nil)
            {
                textLabel!.text = EMPTY
            }
        }
        else
        {
            let request: URLRequest = URLRequest(url: URL(string: url)!)
            let mainQueue = OperationQueue.main
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil
                {
                    let image = UIImage(data: data!)
                    if(image != nil)
                    {
                    DispatchQueue.main.async(execute: {
                        imageView.image = Bl_Attachment.sharedInstance.imageResize(imageObj: image!)
                        
                        if (textLabel != nil)
                        {
                            textLabel!.text = EMPTY
                        }
                        
                        self.cache.setObject(data! as NSData, forKey: url as NSString)
                    })
                }
                }
            })
        }
    }
}

class DownloadOperation : AsynchronousOperation
{
    var task: URLSessionTask!
    
    init(session: URLSession, url: URL)
    {
        super.init()
        
        task = session.downloadTask(with: url) { temporaryURL, response, error in
            defer { self.completeOperation() }
            
            guard error == nil && temporaryURL != nil else {
                print("\(error)")
                return
            }
            
            do
            {
                let manager = FileManager.default
                let destinationURL = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(url.lastPathComponent)
                
                _ = try? manager.removeItem(at: destinationURL)                    // remove the old one, if any
                
                try manager.moveItem(at: temporaryURL!, to: destinationURL)    // move new one there
            }
            catch let moveError
            {
                print("\(moveError)")
            }
        }
    }
    
    override func cancel()
    {
        task.cancel()
        super.cancel()
    }
    
    override func main()
    {
        task.resume()
    }
}

/// Asynchronous operation base class
///
/// This is abstract to class performs all of the necessary KVN of `isFinished` and
/// `isExecuting` for a concurrent `Operation` subclass. You can subclass this and
/// implement asynchronous operations. All you must do is:
///
/// - override `main()` with the tasks that initiate the asynchronous task;
///
/// - call `completeOperation()` function when the asynchronous task is done;
///
/// - optionally, periodically check `self.cancelled` status, performing any clean-up
///   necessary and then ensuring that `completeOperation()` is called; or
///   override `cancel` method, calling `super.cancel()` and then cleaning-up
///   and ensuring `completeOperation()` is called.

public class AsynchronousOperation : Operation
{
    override public var isAsynchronous: Bool { return true }
    
    private let stateLock = NSLock()
    
    private var _executing: Bool = false
    
    override private(set) public var isExecuting: Bool
    {
        get
        {
            return stateLock.withCriticalScope { _executing }
        }
        set
        {
            willChangeValue(forKey: "isExecuting")
            stateLock.withCriticalScope { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished: Bool = false
    
    override private(set) public var isFinished: Bool
    {
        get
        {
            return stateLock.withCriticalScope { _finished }
        }
        set
        {
            willChangeValue(forKey: "isFinished")
            stateLock.withCriticalScope { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    /// Complete the operation
    ///
    /// This will result in the appropriate KVN of isFinished and isExecuting
    
    public func completeOperation()
    {
        if isExecuting
        {
            isExecuting = false
        }
        
        if !isFinished
        {
            isFinished = true
        }
    }
    
    override public func start()
    {
        if isCancelled
        {
            isFinished = true
            return
        }
        
        isExecuting = true
        
        main()
    }
}

/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 An extension to `NSLock` to simplify executing critical code.
 
 From Advanced NSOperations sample code in WWDC 2015 https://developer.apple.com/videos/play/wwdc2015/226/
 From https://developer.apple.com/sample-code/wwdc/2015/downloads/Advanced-NSOperations.zip
 */

extension NSLock
{
    
    /// Perform closure within lock.
    ///
    /// An extension to `NSLock` to simplify executing critical code.
    ///
    /// - parameter block: The closure to be performed.
    
    func withCriticalScope<T>(block: () -> T) -> T
    {
        lock()
        let value = block()
        unlock()
        return value
    }
}
