//
//  TMServiceRequest.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//
import Foundation

enum TMRequestMethodType: String {
    case get, post, put, delete
    func uppercased() -> String {
        return self.rawValue.uppercased()
    }
}

enum TMRequestContentType: String {
    case URLEncoded, JSON, none
}

class TMServiceRequest: NSObject {

    private(set) var apiEndPoint: String
    private(set) var httpMethod: TMRequestMethodType
    private(set) var contentType: TMRequestContentType
    private(set) var requestParams: Any?
    private(set) var additionalHeaders: [String: String]?

    init(apiEndPoint: String,
         httpMethod: TMRequestMethodType,
         contentType: TMRequestContentType,
         requestParams: Any? = nil,
         additionalHeaders: [String: String]? = nil) {
        self.apiEndPoint = apiEndPoint
        self.httpMethod = httpMethod
        self.contentType = contentType
        self.requestParams = requestParams
        self.additionalHeaders = additionalHeaders
    }
}
