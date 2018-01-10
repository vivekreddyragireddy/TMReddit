//
//  TMOSITLogger.swift
//  sit-test
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//
import Foundation
func tLog<T>( _ object: @autoclosure() -> T,
              _ file: String = #file,
              _ function: String = #function,
              _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let stringRepresentation: String

        if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        } else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        } else {
            let msg = "tLog works for values that conform to CustomDebugStringConvertible or CustomStringConvertible"
            fatalError(msg)
        }

        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        let gFormatter = DateFormatter()
        gFormatter.dateFormat = "HH:mm:ss:SSS"
        let timestamp = gFormatter.string(from: Date())

        print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: " + stringRepresentation + "\n")
    #endif
}
