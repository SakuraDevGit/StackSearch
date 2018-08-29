//
//  QuestionSearchViewController.swift
//  StackSearch
//
//  Created by Rudi on 23/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import UIKit

class QuestionSearchViewController: UIViewController {

    @IBOutlet weak var questionSearchTableView: UITableView!
    
    var searchController: UISearchController?
    var viewModel: QuestionSearchViewModel?
    var network = DefaultNetwork()
    var stackQuestions = [StackOverflowQuestion]()
    var selectedQuestion: StackOverflowQuestion?
    var hasNavigated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        
        navigationController?.navigationBar.barTintColor = Consts.Color.navBarBlue
        navigationController?.navigationBar.isTranslucent = false
        
        viewModel = QuestionSearchViewModel(network: network, updateView: updateState)
        questionSearchTableView.isHidden = true
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController?.obscuresBackgroundDuringPresentation = false
        }
        searchController?.searchBar.placeholder = "Search"
        if #available(iOS 11.0, *) {
            navigationItem.title = "Stack Search"
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationItem.searchController = searchController
            self.extendedLayoutIncludesOpaqueBars = true
            navigationItem.searchController?.searchBar.tintColor = .white
            navigationItem.searchController?.searchBar.barTintColor = .white
            
            if let textfield = navigationItem.searchController?.searchBar.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.blue
                if let backgroundview = textfield.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            
        } else {
            navigationItem.titleView = searchController?.searchBar
        }
        searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateState(state: QuestionSearchViewModelState) {
        if !Thread.isMainThread {
            DispatchQueue.main.sync {
                updateState(state: state)
            }
            return
        }
        
        stackQuestions = state.stackQuestions
        questionSearchTableView.reloadData()
        
        if stackQuestions.count > 0 {
            questionSearchTableView.isHidden = false
        } else {
            questionSearchTableView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showQuestion" { return }
        guard let detailViewController = segue.destination as? QuestionDetailViewController else { return }
        guard let selectedQuestion = selectedQuestion else { return }
        detailViewController.selectedQuestion = selectedQuestion
    }

}

extension QuestionSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel?.updateSearchQuery(searchText: searchText)
    }
}

extension QuestionSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuestion = stackQuestions[indexPath.row]
        performSegue(withIdentifier: "showQuestion", sender: self)
        hasNavigated = true
    }
}

extension QuestionSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stackQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = stackQuestions[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionSearchCell", for: indexPath) as? QuestionSearchTableViewCell {
            cell.configure(stackQuestion: question)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
