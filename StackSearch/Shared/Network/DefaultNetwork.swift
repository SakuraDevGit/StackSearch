//
//  DefaultNetwork.swift
//  StackSearch
//
//  Created by Rudi on 25/8/18.
//  Copyright © 2018 SakuraDev. All rights reserved.
//

import Foundation

class DefaultNetwork: Network {
    
    func queryQuestions(tag: String, completion: @escaping ([StackOverflowQuestion]?, StackSearchError?) -> ()) {
        guard let escapedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(nil, StackSearchError.percentEncodingFailed)
            return
        }
        let url = URL(string: "https://api.stackexchange.com/2.2/questions?pagesize=20&order=desc&sort=activity&tagged=\(escapedTag)&site=stackoverflow&filter=withbody")
        
        let task = URLSession.shared.dataTask(with: url!) { [weak self] (data, response, error) in
            if let error = error {
                completion(nil, StackSearchError.networkError(error))
                return
            }
            
            guard let data = data else {
                completion(nil, StackSearchError.noDataNoError)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                if let json = json as? [String: Any] {
                    completion(self?.getQuestions(json: json), nil)
                } else {
                    completion(nil, StackSearchError.deserializationFailed)
                }
            } catch {
                completion(nil, StackSearchError.deserializationFailed)
            }
        }
        
        task.resume()
    }
    
    private func getQuestions(json: [String: Any]) -> [StackOverflowQuestion] {
        var questionsToReturn = [StackOverflowQuestion]()
        
        for item in json["items"] as? [Any] ?? [Any]() {
            guard let item = item as? [String: Any] else { continue }
            guard let viewCount = item["view_count"] as? Int else { continue }
            guard let votes = item["score"] as? Int else { continue }
            guard let answerCount = item["answer_count"] as? Int else { continue }
            guard let isAnswered = item["is_answered"] as? Bool else { continue }
            guard let title = item["title"] as? String else { continue }
            guard let ownerJSON = item["owner"] as? [String: Any] else { continue }
            guard let owner = getOwner(ownerJSON: ownerJSON) else { continue }
            guard let tags = item["tags"] as? [String] else { continue }
            guard let body = item["body"] as? String else { continue }
            guard let dateUnixEpochTime = item["creation_date"] as? TimeInterval else { continue }
            let date = Date(timeIntervalSince1970: dateUnixEpochTime)
            
            let questionToAdd = StackOverflowQuestion(tags: tags,
                                                      owner: owner,
                                                      isAnswered: isAnswered,
                                                      viewCount: viewCount,
                                                      answerCount: answerCount,
                                                      votes: votes,
                                                      creationDate: date,
                                                      title: title,
                                                      body: body)
            questionsToReturn.append(questionToAdd)
        }
        
        return questionsToReturn
    }
    
    private func getOwner(ownerJSON: [String: Any]) -> Owner? {
        guard let reputation = ownerJSON["reputation"] as? Int else { return nil }
        guard let displayName = ownerJSON["display_name"] as? String else { return nil }
        guard let profileImageURL = ownerJSON["profile_image"] as? String else { return nil }
        
        return Owner(reputation: reputation, displayName: displayName, profileImageURL: URL(string: profileImageURL))
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func requestImageData(from url: URL, completion: @escaping (Data?, StackSearchError?) -> ()) {
        getData(from: url) { data, response, error in
            if let error = error {
                completion(nil, StackSearchError.networkError(error))
                return
            }
            
            guard let data = data else {
                completion(nil, StackSearchError.noDataNoError)
                return
            }
            
            completion(data, nil)
        }
    }
}
