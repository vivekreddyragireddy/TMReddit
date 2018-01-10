//
//  TMHomeTableViewCell.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//

import UIKit
import SDWebImage

class TMHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        resetCellWithDefaultValues()
    }
    
    private func resetCellWithDefaultValues() {
        titleLabel.text = ""
        scoreLabel.text = ""
        commentNumber.text = ""
        cardImageView.image = nil
        cardImageView.sd_cancelCurrentImageLoad()
    }
    
    func configureCell(card: TMCard) {
        titleLabel.text = card.title
        scoreLabel.text = "Score: " + (card.score ?? "")
        commentNumber.text = "Comment Number: " + (card.commentNumber ?? "")
        if let imageUrl = card.imageURL {
            if let imageUrl = URL(string: imageUrl) {
                cardImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "CardDefaultIcon"))
            }
        }
    }

}
