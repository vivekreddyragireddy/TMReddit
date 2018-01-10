//
//  TMBaseASyncOperation.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//
import  Foundation
class TMBaseASyncOperation: Operation {
    enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }

    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension TMBaseASyncOperation {

    override var isReady: Bool {
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override var isAsynchronous: Bool {
        return true
    }

    override func start() {
        if isCancelled {
            state = .finished
            return
        }

        main()
        state = .executing
    }

    override func cancel() {
        state = .finished
    }
}
