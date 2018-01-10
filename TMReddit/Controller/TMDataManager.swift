//
//  TMDataManager.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//

import UIKit
import SwiftyJSON

/// TMRedditEndPoint url details for webservice
struct TMRedditEndPoints {
    static let domain = "http://www.reddit.com"
    static let path = "/.json"
    
    static var apiEndPoint: String {
        return domain + path
    }
}

class TMConstants: NSObject {
    static let dataKey = "data"
    static let afterKey = "after"
    static let childrenKey = "children"
    static let titleKey = "title"
    static let scoreKey = "score"
    static let commentsKey = "num_comments"
    static let thumbnailKey = "thumbnail"
}

typealias TMServiceResponseCompletion = (TMCards?) -> Void

/// TMDataManager is responsible for getting data from service & parsing.
class TMDataManager: NSObject {
    class func getCards(after: String?, completionBlock: @escaping TMServiceResponseCompletion) {

        guard let request = getRedditRequest(after: after) else {
            tLog("Unable to form request")
            return
        }
        let model = TMServiceDataModel(request: request)
        let serviceOperation = TMServiceOperation.serviceOperation(dataModel: model) {(serviceModel) in
            let cards = parseDataModel(dataModel: serviceModel)
            completionBlock(cards)
        }
        if let serviceOperation = serviceOperation {
            TMServiceOperationQueue.sharedOperation.addOperation(serviceOperation)
        } else {
            tLog("Unable to create service operation")
        }
    }
    
    
    /// responsible for creating request for reddit
    ///
    /// - Parameter after: link string to fetch next page data
    /// - Returns: TMServiceRequest request
    
    private class func getRedditRequest(after: String?) -> TMServiceRequest? {
        var endPoint = TMRedditEndPoints.apiEndPoint
        if let after = after {
            endPoint = endPoint + "?after=\(after)"
        }
        let request = TMServiceRequest(apiEndPoint: endPoint, httpMethod: .get, contentType: TMRequestContentType.JSON)
        return request
    }
    
    /// responsible for parsing data and return card models
    ///
    /// - Parameter dataModel: TMServiceDataModel
    /// - Returns: TMCards
    private class func parseDataModel(dataModel: TMServiceDataModel) -> TMCards? {
        let response = dataModel.response
        guard let data = response.responseData else {
            return nil
        }
        do {
            let json = try JSON(data: data)
            let afterLink = json[TMConstants.dataKey][TMConstants.afterKey]
            let childrenArray = json[TMConstants.dataKey][TMConstants.childrenKey]
            var children = [TMCard]()
            for index in 0...childrenArray.count - 1 {
                let title = json[TMConstants.dataKey][TMConstants.childrenKey][index][TMConstants.dataKey][TMConstants.titleKey].string
                let score = json[TMConstants.dataKey][TMConstants.childrenKey][index][TMConstants.dataKey][TMConstants.scoreKey].stringValue
                let commentNumber = json[TMConstants.dataKey][TMConstants.childrenKey][index][TMConstants.dataKey][TMConstants.commentsKey].stringValue
                let imageUrl = json[TMConstants.dataKey][TMConstants.childrenKey][index][TMConstants.dataKey][TMConstants.thumbnailKey].string

                let card = TMCard(title: title, commentNumber: commentNumber, score: score, imageURL: imageUrl)
                children.append(card)
            }
            let cards = TMCards(afterLink: afterLink.string, cards: children)
            return cards
        } catch {
            
        }
        return nil
    }
    
}
