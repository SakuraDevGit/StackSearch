//
//  QuestionDetailViewModel.swift
//  StackSearch
//
//  Created by Rudi on 29/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import Foundation

struct QuestionDetailViewModelState {
    var imageData: Data?
    var errorText: String?
}

class QuestionDetailViewModel {
    private let updateView: (QuestionDetailViewModelState) -> ()
    private let network: Network
    
    private var state = QuestionDetailViewModelState(imageData: nil, errorText: nil) {
        didSet {
            updateView(state)
        }
    }
    
    init(network: Network, updateView: @escaping (QuestionDetailViewModelState) -> ()) {
        self.updateView = updateView
        self.network = network
    }
    
    func requestImageFromURL(url: URL) {
        network.requestImageData(from: url) { [weak self] (data, error) in
            if let error = error {
                self?.state.errorText = error.localizedDescription
                return
            }
            
            guard let data = data else {
                let errorText = StackSearchError.noDataNoError.localizedDescription
                self?.state.errorText = errorText
                return
            }
            
            self?.state.imageData = data
        }
    }
}
