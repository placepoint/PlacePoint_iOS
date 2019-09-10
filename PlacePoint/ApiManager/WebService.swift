//
//  WebService.swift
//  Raj
//
//  Created by Raj on 01/06/16.
//  Copyright © 2016 Raj. All rights reserved.
//

import UIKit

var baseURL = "https://www.placepoint.ie/webservices/data_v1/"

//Live new----- "https://www.placepoint.ie/webservices/data_v1/"

// live ---"http://34.254.213.227/webservices/data_v1/"

//var baseURL = "http://cloudart.com.au/projects/Placepoint/index.php/webservices/data_v1/"

var appCode = "kidsfirst"

class WebService: NSObject {
    
    static let sharedInstance: WebService = {
        let instance = WebService()
        return instance
    }()
    
    //////////////////////////////////////////////////
    //************** GET API Section **************//
    //////////////////////////////////////////////////
    
    // MARK: -
    func getMethedWithoutParams(_ strServiceType: String, completionHandler:@escaping (_ dict: NSDictionary) -> Void, failure: @escaping (_ error: String) -> Void) {
        
        let strURL = "\(baseURL)\(strServiceType)"
        
        let request: NSURLRequest = self.createGetRequest(url: strURL)
        
        self.callAPI(request: request, completionHandler: { (responseDict) in
            
            completionHandler(responseDict)
            
        }, failure: { (error) in
            
            failure(error)
        })
    }
    
    
    func getMethodWithParams(_ strServiceType: String, dict: NSDictionary, completionHandler:@escaping (_ dict: NSDictionary) -> Void, failure:@escaping (_ error: String) -> Void) {
        
        var strUrl = String()
        
        strUrl = strUrl.createUrlForGetMethodWithParams(dict: dict)
        
        strUrl = "\(baseURL)\(strServiceType)\(strUrl)"
    
        let request: NSURLRequest = self.createGetRequest(url: strUrl)
        
        self.callAPI(request: request, completionHandler: { (responseDict) in
            
            completionHandler(responseDict)
            
        }, failure: { (error) in
            
            return
        })
    }
    
    
    private func createGetRequest(url: String) -> NSURLRequest {
        
        let urlPath = NSURL(string: url)
        
        let request = NSMutableURLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "GET"
        
        return request
    }
    
    //////////////////////////////////////////////////
    //************** POST API Section **************//
    //////////////////////////////////////////////////
    
    // MARK: - Post API Methods
    
    
    func postMethodWithParams(strURL: String, dict: NSDictionary, completionHandler:@escaping (_ dict: NSDictionary) -> Void, failure:@escaping (_ errorMsg: String) -> Void) {
        
        let request = self.postWithParamAndImage(strURL: strURL, dictParam: dict, file: nil, fileKey: nil, fileName: nil)
        
        self.callAPI(request: request, completionHandler: { (responseDict) in
            completionHandler(responseDict)
            
        }, failure: { (error) in
            print(error)
            failure(error)
        })
    }
    
    
    func postMethodWithParamsAndImage(strURL: String, dictParams: NSDictionary, image: UIImage?, imagesKey: String, imageName: String, completionHandler: @escaping (_ dict: NSDictionary) -> Void, failue:@escaping (_ error: String) -> Void) {
        
        let request = self.postWithParamAndImage(strURL: strURL, dictParam: dictParams, file: image, fileKey: imagesKey, fileName: imageName)
        
        self.callAPI(request: request, completionHandler: { (responseDict) in
            completionHandler(responseDict)
        }, failure: { (error) in
            print(error)
            failue(error)
        })
    }
    
    
    private func postWithParamAndImage(strURL: String, dictParam: NSDictionary, file: UIImage?, fileKey: String?, fileName: String?) -> NSURLRequest {
        
        let myUrl = NSURL(string: "\(baseURL)\(strURL)")
        
        let request = NSMutableURLRequest(url: myUrl! as URL)
        
        request.httpMethod = "POST"
        
        //      request.timeoutInterval = 60
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if file != nil {
            
            let imageData = UIImageJPEGRepresentation((file)!, 1)
            
            request.httpBody = createBodyWithParametersAndImage(parameters: dictParam, filePathKey: fileKey, fileName: fileName!, imageDataKey: imageData! as NSData, boundary: boundary) as Data
            
        } else {
            
            request.httpBody = createBodyWithParameters(parameters: dictParam, boundary: boundary) as Data
        }
        
        return request
    }
    
    
    func requestPostWithJsonData(method: String) -> NSMutableURLRequest {
        
        let myUrl = URL(string: "\(baseURL)") // Replace with base url
        
        let request = NSMutableURLRequest(url: myUrl!)
        
        request.httpMethod = method.capitalized
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
        
    }
    
    
    private func createBodyWithParametersAndImage(parameters: NSDictionary, filePathKey: String?, fileName: String?, imageDataKey: NSData, boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            
            body.appendString(string: "--\(boundary)\r\n")
            
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            
            body.appendString(string: "\(value)\r\n")
        }
        
        let filename = "\(fileName!).jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        
        body.append(imageDataKey as Data)
        
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    private func createBodyWithParameters(parameters: NSDictionary, boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            
            body.appendString(string: "--\(boundary)\r\n")
            
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    private func generateBoundaryString() -> String {
        
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    // MARK: - Common For Both (GET & POST)
    private func callAPI(request: NSURLRequest, completionHandler:@escaping (_ responseDict: NSDictionary) -> Void, failure:@escaping (_ error: String) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil && data != nil else {
                //check for fundamental networking error
                
                print(error as Any)
                
                failure(error!.localizedDescription)
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                //check for http errors
                
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                
                print(response as Any)
                
                do {
                    
                    if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
                        
                        print(JSONString)
                    }
                    
                    if let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                        
                        completionHandler(result as NSDictionary)
                    }
                    
                    if let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: AnyObject]] {
                        
                        print(result)
                        
                        completionHandler(["result": result])
                    }
                    
                } catch let error as NSError {
                    
                    print("json error: \(error.localizedDescription)")
                    
                    failure("json error: \(error.localizedDescription)")
                }
            } else {
                
                let httpStatus = response as? HTTPURLResponse
                
                failure("API Response status code : \(String(describing: httpStatus?.statusCode))")
            }
        }
        task.resume()
    }
}


extension NSMutableData {
    
    func appendString(string: String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        append(data!)
    }
}


extension String {
    
    func createUrlForGetMethodWithParams(dict: NSDictionary) -> String {
        
        var stringUrl1: String!
        
        var firstTime1 = "yes"
        
        for (key, value) in dict {
            
            let stringVal = value as? String
            
            if let percentEscapedString = stringVal?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                
                if firstTime1 == "yes" {
                    
                    stringUrl1 = "?\(key)=\(percentEscapedString)"
                    
                    firstTime1 = "no"
                } else {
                    stringUrl1 = "\(stringUrl1!)&\(key)=\(percentEscapedString)"
                }
            }
        }
        return stringUrl1
    }
}
