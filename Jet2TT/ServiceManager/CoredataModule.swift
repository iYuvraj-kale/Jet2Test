//
//  CoredataModule.swift
//  Jet2TT
//
//  Created by Yuvraj  Kale on 01/05/20.
//  Copyright © 2020 Yuvraj  Kale. All rights reserved.
//

import UIKit
import CoreData

class CoredataModule: NSObject {
    static let sharedInstance = CoredataModule()
    
    private override init() {}

    func writeData(withArticles articles:[Article]) {
        DispatchQueue.main.async{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  let context = appDelegate.persistentContainer.viewContext
                  context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
                  for article in articles{
                    if(!self.isEntityAttributeExist(id: article.id, entityName: "Articles")){
                        let articleEntity = NSEntityDescription.entity(forEntityName: "Articles", in: context)
                        let newArticle = NSManagedObject(entity: articleEntity!, insertInto: context)
                          newArticle.setValue(article.id, forKey: "id")
                          newArticle.setValue(article.createdAt, forKey: "createdAt")
                          newArticle.setValue(article.content, forKey: "content")
                          newArticle.setValue(article.comments as NSNumber, forKey: "comments")
                          newArticle.setValue(article.likes as NSNumber, forKey: "likes")
                          if(article.media.count>0){
                              let mediaEntity = NSEntityDescription.entity(forEntityName: "Media", in: context)
                              let newMedia = NSManagedObject(entity: mediaEntity!, insertInto: context)
                              newMedia.setValue(article.media[0].id, forKey: "id")
                              newMedia.setValue(article.media[0].blogId, forKey: "blogId")
                              newMedia.setValue(article.media[0].createdAt, forKey: "createdAt")
                              newMedia.setValue(article.media[0].image, forKey: "image")
                              newMedia.setValue(article.media[0].title, forKey: "title")
                              newMedia.setValue(article.media[0].url, forKey: "url")
                        

                          }
                          if(article.user.count>0){
                              let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context)
                              let newUser = NSManagedObject(entity: userEntity!, insertInto: context)
                              newUser.setValue(article.user[0].id, forKey: "id")
                              newUser.setValue(article.user[0].blogId, forKey: "blogId")
                              newUser.setValue(article.user[0].createdAt, forKey: "createdAt")
                              newUser.setValue(article.user[0].name, forKey: "name")
                              newUser.setValue(article.user[0].avatar, forKey: "avatar")
                              newUser.setValue(article.user[0].lastname, forKey: "lastname")
                              newUser.setValue(article.user[0].city, forKey: "city")
                              newUser.setValue(article.user[0].designation, forKey: "designation")
                              newUser.setValue(article.user[0].about, forKey: "about")
                            
                        }

                    }
                    
                      
                  }
            do {
               try context.save()
              } catch {
               print("Failed saving")
            }
            
        }

    }
    func isEntityAttributeExist(id: String, entityName: String) -> Bool {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       let managedContext = appDelegate.persistentContainer.viewContext
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
       fetchRequest.predicate = NSPredicate(format: "id == %@", id)

       let res = try! managedContext.fetch(fetchRequest)
       return res.count > 0 ? true : false
     }

    func fetchData(from startIndex:Int, toEndIndex endIndex:Int)->[Article]?{
        var articles = [Article]()
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let articleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Articles")
        articleRequest.fetchOffset = startIndex;
        articleRequest.fetchLimit = endIndex;

        articleRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(articleRequest)
            
            for data in result as! [NSManagedObject] {
                var tempArticle = Article()
                tempArticle.id = data.value(forKey: "id") as! String
                tempArticle.createdAt = data.value(forKey: "createdAt") as! String
                tempArticle.content = data.value(forKey: "content") as! String
                tempArticle.comments = data.value(forKey: "comments") as! Int
                tempArticle.likes = data.value(forKey: "likes") as! Int
                
                let mediaRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Media")
                mediaRequest.predicate = NSPredicate(format: "id == %@", "\(tempArticle.id)")
                let mediaResult = try context.fetch(mediaRequest)
                for mediaData in mediaResult as! [NSManagedObject]{
                    var tempMedia = Article.Media()
                    if let id = mediaData.value(forKey: "id") as? String{
                        tempMedia.id = id
                    }
                    if let blogid = mediaData.value(forKey: "blogId") as? String{
                        tempMedia.blogId = blogid
                    }
                    if let createAt = mediaData.value(forKey: "createdAt") as? String
                    {
                        tempMedia.createdAt = createAt
                    }
                    if let img = mediaData.value(forKey: "image") as? String{
                        tempMedia.image = img
                    }
                    if let titl = mediaData.value(forKey: "title") as? String{
                        tempMedia.title = titl
                    }
                    if let url = mediaData.value(forKey: "url") as? String{
                        tempMedia.url = url
                    }
                    tempArticle.media.append(tempMedia)
                }
                let userRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                userRequest.predicate = NSPredicate(format: "id == %@", "\(tempArticle.id)")
                let userResult = try context.fetch(userRequest)
                for userData in userResult as! [NSManagedObject]{
                    var tempUser = Article.UserModel()
                    if let id = userData.value(forKey: "id") as? String{
                        tempUser.id = id
                    }
                    if let blogid = userData.value(forKey: "blogId") as? String{
                        tempUser.blogId = blogid
                    }
                    if let createdat = userData.value(forKey: "createdAt") as? String{
                        tempUser.createdAt = createdat
                    }
                    if let name = userData.value(forKey: "name") as? String{
                        tempUser.name = name
                    }
                    if let city = userData.value(forKey: "city") as? String{
                        tempUser.city = city
                    }
                    if let lastname = userData.value(forKey: "lastname") as? String{
                        tempUser.lastname = lastname
                    }
                    if let avatar = userData.value(forKey: "avatar") as? String{
                        tempUser.avatar = avatar
                    }
                    if let about = userData.value(forKey: "about") as? String{
                        tempUser.about = about
                    }
                    if let designation = userData.value(forKey: "designation") as? String{
                        tempUser.designation = designation
                    }
                    tempArticle.user.append(tempUser)
                }

                articles.append(tempArticle)
                
                
          }
            
            
        } catch {
            
            print("Failed")
        }
        return articles
    }
    
    
}
