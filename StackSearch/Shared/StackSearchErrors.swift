//
//  StackSearchErrors.swift
//  StackSearch
//
//  Created by Rudi on 25/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import Foundation

enum StackSearchError: Error {
    case noDataNoError
    case percentEncodingFailed
    case deserializationFailed
    case networkError(Error)
}
