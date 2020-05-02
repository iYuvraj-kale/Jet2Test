//
//  ArticleExtension.swift
//  Jet2TT
//
//  Created by Yuvraj  Kale on 01/05/20.
//  Copyright © 2020 Yuvraj  Kale. All rights reserved.
//

import UIKit

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }
}
extension UIImageView {
   static let imageCache = NSCache<NSString, UIImage>()

    func downloadFrom(path link:String?, contentMode mode: UIView.ContentMode) {
        contentMode = mode
        if let mypath = link{
            if let cachedImage = UIImageView.imageCache.object(forKey: mypath as NSString) {
                    self.image = cachedImage
                }
            else{
                        self.startSpinner(isStart: true)
                        image = UIImage(named: "person.fill")
                            if link != nil, let url = URL(string: mypath) {
                                URLSession.shared.dataTask(with: url as URL) { data, response, error in
                                    DispatchQueue.main.async {
                                            self.startSpinner(isStart: false)
                                    }
                                    
                                    guard let data = data, error == nil else {
                                        print("\nerror on download \(error!.localizedDescription)")
                                        return
                                    }
                                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                                        print("statusCode != 200; \(httpResponse.statusCode)")
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        print("\ndownload completed \(url.lastPathComponent)")
                                        
                                        self.image = UIImage(data: data)
                                        if let img = self.image{
                                            UIImageView.imageCache.setObject(img, forKey: mypath as NSString)
                                        }

                                    }
                                    }.resume()
                            } else {
                                self.image = UIImage(named: "person.fill")
                            }
            }

        }
    }
    func startSpinner(isStart indicator:Bool){
        if let foundView = self.viewWithTag(2221) as? UIActivityIndicatorView{
            if(!indicator){
                foundView.stopAnimating()
            }
            else{
                foundView.startAnimating()
            }


        }
        else{
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.tag = 2221
            spinner.startAnimating()
            spinner.tintColor = UIColor.blue
            spinner.frame = CGRect(x: (self.frame.width/2)-22, y: (self.frame.height/2)-22, width: 44, height: CGFloat(44))
            self.addSubview(spinner)
        }

    }
}
extension String{
    func getTimesAgo()->String{
        let isoDate = self

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from:isoDate)!
        return date.timeAgoSinceDate()
    }
    

}
extension Int{
    func suffixNumber() -> String {
        var num = Double(self)
//        var num:Double = number.doubleValue
        let sign = ((num < 0) ? "-" : "" )
        num = fabs(num)
        if (num < 1000.0) {
            return "\(sign)\(num)"
        }

        let exp: Int = Int(log10(num) / 3.0)
        let units: [String] = ["K","M","G","T","P","E"]
        let roundedNum: Double = round(10 * num / pow(1000.0,Double(exp))) / 10

        return "\(sign)\(roundedNum)\(units[exp-1])";
    }
}
extension UITableView{
    func startSpinner(isStart indicator:Bool){
        if let foundView = self.viewWithTag(2222) as? UIActivityIndicatorView{
            if(!indicator){
                foundView.stopAnimating()
                self.tableFooterView?.isHidden = true
            }
            else{
                foundView.startAnimating()
                self.tableFooterView = foundView
                self.tableFooterView?.isHidden = false

            }
            
            
        }
        else{
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.tag = 2222
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))

            self.tableFooterView = spinner
            self.tableFooterView?.isHidden = false

        }

    }

}

