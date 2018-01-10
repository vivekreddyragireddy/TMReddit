//
//  TMServiceDataModel.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//
import Foundation

class TMServiceDataModel: NSObject {
    private(set) var request: TMServiceRequest
    var response: TMServiceResponse

    init(request: TMServiceRequest, response: TMServiceResponse? = nil) {
        self.request = request
        if let response = response {
            self.response = response
        } else {
            self.response = TMServiceResponse()
        }
    }
}
