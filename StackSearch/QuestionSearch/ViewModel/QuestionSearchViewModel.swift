//
//  QuestionSearchViewModel.swift
//  StackSearch
//
//  Created by Rudi on 25/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import Foundation

struct QuestionSearchViewModelState {
    var stackQuestions = [StackOverflowQuestion]()
    var errorText: String?
}

class QuestionSearchViewModel {
    private let updateView: (QuestionSearchViewModelState) -> ()
    private let network: Network
    private var timer: Timer?
    private var searchText: String?
    
    private var state = QuestionSearchViewModelState(stackQuestions: [StackOverflowQuestion](), errorText: nil) {
        didSet {
            updateView(state)
        }
    }
    
    init(network: Network, updateView: @escaping (QuestionSearchViewModelState) -> ()) {
        self.updateView = updateView
        self.network = network
    }
    
    func updateSearchQuery(searchText: String) {
        timer?.invalidate()
        if searchText.isEmpty {
            return
        }
        
        self.searchText = searchText
        
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] timer in
                self?.doSearch()
            }
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1,
                                   target: self,
                                   selector: #selector(self.doSearch),
                                   userInfo: nil,
                                   repeats: true)
        }
    }
    
    @objc private func doSearch() {
        guard let searchText = searchText, !searchText.isEmpty else {
            return
        }
        
        network.queryQuestions(tag: searchText) { [weak self] (questions, error) in
            if let error = error {
                self?.state.errorText = error.localizedDescription
                return
            }
            
            guard let questions = questions else {
                let errorText = StackSearchError.noDataNoError.localizedDescription
                self?.state.errorText = errorText
                return
            }
            
            self?.state.stackQuestions = questions
        }
    }
}
