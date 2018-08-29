//
//  StackOverflowQuestion.swift
//  StackSearch
//
//  Created by Rudi on 25/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import Foundation

struct StackOverflowQuestion {
    var tags: [String]
    var owner: Owner
    var isAnswered: Bool
    var viewCount: Int
    var answerCount: Int
    var votes: Int
    var creationDate: Date
    var title: String
    var body: String
}

struct Owner {
    var reputation: Int
    var displayName: String
    var profileImageURL: URL?
}
