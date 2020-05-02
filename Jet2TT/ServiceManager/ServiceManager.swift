//
//  ServiceManager.swift
//  Jet2TT
//
//  Created by Yuvraj  Kale on 29/04/20.
//  Copyright © 2020 Yuvraj  Kale. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    static let sharedInstance = ServiceManager()
    let baseURL = "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=%d&limit=10"
    private override init() {
        
    }
    func requetArticle(withURL URL:URL,andHTTPMethod method:String,andParameter parameter:[String:String]?, withCompletionhandler completion:@escaping ([Article]?,URLResponse?,Error?)->Void){
        _ = ServiceFetcher(taskWith: URL, httpmethod: method, parameters: parameter) { (data, response, error) in
            if(error == nil){
                if let response = response{
                    if let httpResponse = response as? HTTPURLResponse{
                        if (httpResponse.statusCode == 200){
                            if let data = data{
                                do{
                                    let article = try JSONDecoder().decode([Article].self, from: data)
//                                    print(article)
                                    completion(article,response,nil)
                                }
                                catch{
                                    self.showAlert(withError: error.localizedDescription)
                                    completion(nil,response,error)
                                    print(error.localizedDescription)
                                }
                                
                               
                            }
                        }
                        else{
                            self.showAlert(withError: error!.localizedDescription)
                            completion(nil,response,error)
                        }
                    }
                    else{
                        self.showAlert(withError: error!.localizedDescription)
                        completion(nil,response,error)
                    }

                }
                else{
                    self.showAlert(withError: error!.localizedDescription)
                    completion(nil,nil,error)
                }

            }
            
        }
    }
    func showAlert(withError error:String){
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        //...
        var rootViewController = UIApplication.shared.windows[0].rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        //...
        rootViewController?.present(alertController, animated: true, completion: nil)

    }
}

