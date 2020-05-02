//
//  ViewController.swift
//  Jet2TT
//
//  Created by Yuvraj  Kale on 29/04/20.
//  Copyright © 2020 Yuvraj  Kale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var articles = [Article]()
    var pagingOver : Bool!
    private let refreshControl = UIRefreshControl()
    let sharedInstance = ServiceManager.sharedInstance
    let coreDataInstance = CoredataModule.sharedInstance
    @IBOutlet weak var articleTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            articleTableview.refreshControl = refreshControl
        } else {
            articleTableview.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshArticleData(_:)), for: .valueChanged)
        getArticle(withIndex: 1)
        pagingOver = false
        // Do any additional setup after loading the view.
    }
    @objc private func refreshArticleData(_ sender: Any) {
        self.articles.removeAll()
        getArticle(withIndex: 1)
    }

    func getArticle(withIndex index:Int){
        
        if currentReachabilityStatus == .notReachable{
            self.refreshControl.endRefreshing()
                var startIndex = 0;
                if(index != 1){
                    startIndex = ((index - 1) * 10) + 1
                }
                if let articleSnap = coreDataInstance.fetchData(from: startIndex, toEndIndex: index * 10)
                {
                    self.articleTableview.startSpinner(isStart: false)
                    if((startIndex == 0) && (articleSnap.count <= 0)){
                        sharedInstance.showAlert(withError: "No Internet connetion fetching from local storage")
                    }
                    else if(articleSnap.count>0){
                        self.articles = self.articles + articleSnap
                        self.articleTableview.reloadData()
                    }
                    else{
                        pagingOver = true
                    }
                }
                else{
                    if((startIndex == 0) && (articles.count <= 0)){
                        sharedInstance.showAlert(withError: "No Internet connetion fetching from local storage")
                    }
                    self.articleTableview.startSpinner(isStart: false)
                    self.pagingOver = true
                }
            }
        else{
            sharedInstance.requetArticle(withURL: URL(string: String(format: sharedInstance.baseURL, index))!, andHTTPMethod: "GET", andParameter: nil) { (data, response, error) in
                            DispatchQueue.main.async {
                                self.refreshControl.endRefreshing()
                                self.articleTableview.startSpinner(isStart: false)
                            }
                                if (error == nil){
                                    if(data!.count > 0){
                                        self.pagingOver = false
            //                            coreDataInstance.writeData(withArticles: data!)
                                        self.articles = self.articles + data!
                                        self.coreDataInstance.writeData(withArticles: self.articles)
                                        DispatchQueue.main.async {
                                            self.articleTableview.reloadData()
                                        }
                                    }
                                else{
                                        
                                    self.pagingOver = true
                                }
                            }
                                else{
                                    self.sharedInstance.showAlert(withError: error!.localizedDescription)
                            }
                        }
      }
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleid", for: indexPath) as! ArticleTableViewCell
        if(indexPath.row<articles.count){
            cell.setArticleWithData(article: self.articles[indexPath.row])
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(!pagingOver){
            if(indexPath.row == articles.count-1 ){
                var paging : Int
                paging = articles.count/10
                paging = paging + 1
                print("pagin = \(paging) and count = \(articles.count)")
                getArticle(withIndex: paging)
            }
        }
        
    }
}
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
}

