//
//  Network.swift
//  StackSearch
//
//  Created by Rudi on 25/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import Foundation

protocol Network {
    func queryQuestions(tag: String, completion: @escaping ([StackOverflowQuestion]?, StackSearchError?) -> ())
    func requestImageData(from url: URL, completion: @escaping (Data?, StackSearchError?) -> ())
}
