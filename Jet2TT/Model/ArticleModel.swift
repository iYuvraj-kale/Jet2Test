//
//  ArticleModel.swift
//  Jet2TT
//
//  Created by Yuvraj  Kale on 29/04/20.
//  Copyright © 2020 Yuvraj  Kale. All rights reserved.
//

import Foundation
struct Article:Codable {
    var id :String = ""
    var createdAt :String = ""
    var content :String = ""
    var comments :Int = 0
    var likes :Int = 0
    struct Media:Codable {
        var id :String = ""
        var blogId :String = ""
        var createdAt :String = ""
        var image :String = ""
        var title :String = ""
        var url :String = ""
    }
    struct UserModel:Codable {
        var id :String = ""
        var blogId :String = ""
        var createdAt :String = ""
        var name:String = ""
        var avatar :String = ""
        var lastname :String = ""
        var city :String = ""
        var designation :String = ""
        var about :String = ""
    }
    var media = [Media]()
    var user = [UserModel]()
}

