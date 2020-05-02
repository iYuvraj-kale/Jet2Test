//
//  ArticleTableViewCell.swift
//  Jet2TT
//
//  Created by Yuvraj  Kale on 30/04/20.
//  Copyright © 2020 Yuvraj  Kale. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImageHeight: NSLayoutConstraint!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleContentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userDesignationLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userAvatarImageView.layer.cornerRadius = 30
        self.userAvatarImageView.layer.borderColor = UIColor.gray.cgColor
        self.userAvatarImageView.layer.borderWidth = 1
        // Initialization code
    }
    func setArticleWithData(article:Article){
        self.articleContentLabel.text = article.content
        self.timeLabel.text = article.createdAt.getTimesAgo()
        self.likeButton.setTitle("\(article.likes.suffixNumber()) Likes", for: .normal)
        self.commentButton.setTitle("\(article.comments.suffixNumber()) Comments", for: .normal)
        
        if(article.user.count>0){
            self.userAvatarImageView.isHidden = false
            self.userAvatarImageView.downloadFrom(path: article.user[0].avatar, contentMode: .scaleAspectFit)
            self.userNameLable.text = article.user[0].name + article.user[0].lastname
            self.userDesignationLabel.text = article.user[0].designation
        }
        else{
            self.userAvatarImageView.isHidden = true
        }
        if(article.media.count>0){
            self.contentImageHeight.constant = 150
            self.contentImageView.isHidden = false
            self.contentImageView.downloadFrom(path: article.media[0].image, contentMode: .scaleToFill)
            self.articleTitleLabel.text = article.media[0].title
            self.urlButton.setTitle(article.media[0].url, for: .normal)
        }
        else{
            self.contentImageHeight.constant = 0
            self.contentImageView.isHidden = true
        }
        self.layoutIfNeeded()
    }
    
    @IBAction func onClickOpenURL(_ sender: Any) {
        if let button = sender as? UIButton{
            guard let urlString = button.titleLabel?.text else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: urlString)!)
            }

        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
