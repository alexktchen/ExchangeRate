//
//  BaseRequest.swift
//  ExchangeRate
//
//  Created by Alex Chen on 2015/9/28.
//  Copyright © 2015年 Alex Chen. All rights reserved.
//

import Foundation

class BaseRequest: NSObject {

    func request(url: String, completionHandler: (NSData?, NSError?) -> Void){

        if let enc = url.URLEncodedString() {
            
            let request = NSMutableURLRequest(URL: NSURL(string: enc)!)
            
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard data != nil else {
                    print("no data found: \(error)")
                    return
                }
                completionHandler(data!, error)
            }
            task.resume()
        }
        
    }
}