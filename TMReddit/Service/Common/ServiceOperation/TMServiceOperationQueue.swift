//
//  TMServiceOperationQueue.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//
import Foundation
final class TMServiceOperationQueue: OperationQueue {

    static let sharedOperation = TMServiceOperationQueue()
    private struct Constants {
        static let kMaxConcurrentOperationCount = 10
        static let kQueueName = "GlobalOperationQueue"
    }

    private override init() {
        super.init()
        maxConcurrentOperationCount = Constants.kMaxConcurrentOperationCount
        name = Constants.kQueueName
    }
}
