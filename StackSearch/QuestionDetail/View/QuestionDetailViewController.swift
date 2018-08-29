//
//  QuestionDetailViewController.swift
//  StackSearch
//
//  Created by Rudi on 28/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController {

    var viewModel: QuestionDetailViewModel?
    var selectedQuestion: StackOverflowQuestion! // If this has no value, the app will crash, signifying a programmer error. This should never happen.
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var userReputationLabel: UILabel!
    @IBOutlet weak var askedDateLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = QuestionDetailViewModel(network: DefaultNetwork(), updateView: { [weak self] (state) in
            self?.updateState(state: state)
        })
        
        if let imageURL = selectedQuestion.owner.profileImageURL {
            viewModel?.requestImageFromURL(url: imageURL)
        }
        
        setupWebView()
        
        let viewControllerTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        viewControllerTitleLabel.text = "Question"
        viewControllerTitleLabel.font = UIFont.systemFont(ofSize: 18)
        viewControllerTitleLabel.textColor = UIColor.white
        viewControllerTitleLabel.textAlignment = .center
        self.navigationItem.titleView = viewControllerTitleLabel
        
        titleLabel.text = selectedQuestion.title
        tagsLabel.text = selectedQuestion.tags.joined(separator: ", ")
        userDisplayNameLabel.text = selectedQuestion.owner.displayName
        userReputationLabel.text = String(selectedQuestion.owner.reputation)
        
        let calendar = Calendar.current
        let date = selectedQuestion.creationDate
        let dateComponent = calendar.component(.day, from: date)
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .ordinal
        
        let day = numberFormatter.string(from: dateComponent as NSNumber)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let dateStringWithoutHours = "\(day!) \(dateFormatter.string(from: date))"
        dateFormatter.dateFormat = "HH:mm"
        let dateStringWithHoursOnly = " at " + dateFormatter.string(from: date)
        
        askedDateLabel.text = "asked " + dateStringWithoutHours + dateStringWithHoursOnly
    }
    
    func updateState(state: QuestionDetailViewModelState) {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                updateState(state: state)
            }
            return
        }
        
        guard let imageData = state.imageData else { return }
        userImageView.image = UIImage(data: imageData)
    }
    
    func setupWebView() {
        var htmlString = "<html><head><title></title></head><body style=\"background:transparent;\">"
        htmlString.append(selectedQuestion.body)
        htmlString.append("</body></html>")
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
