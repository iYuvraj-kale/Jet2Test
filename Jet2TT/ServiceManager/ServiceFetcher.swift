//
//  ServiceFetcher.swift
//  Jet2TT
//
//  Created by Yuvraj  Kale on 29/04/20.
//  Copyright © 2020 Yuvraj  Kale. All rights reserved.
//

import UIKit

class ServiceFetcher: NSObject {
    typealias JSON = [String:String]
    static let dataCache = NSCache<NSString, NSData>()
     static let responseCache = NSCache<NSString, URLResponse>()

    init(taskWith url:URL, httpmethod:String, parameters:JSON?, completionHandler: @escaping (Data?,URLResponse?,Error?)->Void) {
        super.init()
//        let errorCache = NSCache<NSString, NSError?>()
        if let cachedData = ServiceFetcher.dataCache.object(forKey: url.absoluteString as NSString),let cachedResponse = ServiceFetcher.responseCache.object(forKey: url.absoluteString as NSString) {
            completionHandler(cachedData as Data,cachedResponse,nil)
        }
        else{
            
            var body = Data()
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpmethod
            if let parameter = parameters {
                for (_,value) in parameter{
                                body.appendStringAsData("\(value)")
                            }
                urlRequest.httpBody = body
            }
            let session = URLSession.shared
            session.dataTask(with: urlRequest) { (data, response, error) in
                
                    if(error == nil){
                        if let response = response{
                        if let httpResponse = response as? HTTPURLResponse{
                            if (httpResponse.statusCode == 200){
                                ServiceFetcher.dataCache.setObject(data! as NSData, forKey: url.absoluteString as NSString)
                                ServiceFetcher.responseCache.setObject(response, forKey: url.absoluteString as NSString)
                                completionHandler(data,response,error)
                            }
                        }
                    }
                }
        }.resume()
        }
    }

}
extension Data{
    mutating func appendStringAsData(_ string:String){
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
}
//if let response1 = response{
//    print(response1)
//}
//if let data1 = data{
//    do{
//        let json = try JSONSerialization.jsonObject(with: data1, options: [])
//        print(json)
//    }
//    catch{
//        print(error)
//    }
//
//}
