//
//  QuestionSearchTableViewCell.swift
//  StackSearch
//
//  Created by Rudi on 25/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import UIKit

class QuestionSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var answeredImageWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = Consts.Color.questionCellTitle
        votesLabel.textColor = Consts.Color.secondaryInfo
        answersLabel.textColor = Consts.Color.secondaryInfo
        viewsLabel.textColor = Consts.Color.secondaryInfo
        ownerNameLabel.textColor = Consts.Color.secondaryInfo
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(stackQuestion: StackOverflowQuestion) {
        titleLabel.text = stackQuestion.title
        ownerNameLabel.text = stackQuestion.owner.displayName
        
        if stackQuestion.votes == 1 {
            votesLabel.text = "\(String(stackQuestion.votes)) Vote"
        } else {
            votesLabel.text = "\(String(stackQuestion.votes)) Votes"
        }
        
        if stackQuestion.answerCount == 1 {
            answersLabel.text = "\(String(stackQuestion.answerCount)) answer"
        } else {
            answersLabel.text = "\(String(stackQuestion.answerCount)) answers"
        }
        
        if stackQuestion.viewCount == 1 {
            viewsLabel.text = "\(String(stackQuestion.viewCount)) view"
        } else {
            viewsLabel.text = "\(String(stackQuestion.viewCount)) views"
        }
        
        if !stackQuestion.isAnswered {
            answeredImageWidthConstraint.constant = 0
        }
    }

}
