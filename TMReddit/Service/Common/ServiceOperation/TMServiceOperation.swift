//
//  TMServiceOperation.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//

typealias TMServiceCompletionBlock = (TMServiceDataModel) -> Void

import Foundation
class TMServiceOperation: TMBaseASyncOperation {

    private(set) var dataModel: TMServiceDataModel?
    private(set) var serviceCompletionBlock: TMServiceCompletionBlock?

    class func serviceOperation(dataModel: TMServiceDataModel,
                                serviceCompletionBlock: @escaping TMServiceCompletionBlock) -> TMServiceOperation? {
        let operation = TMServiceOperation()
        operation.dataModel = dataModel
        operation.serviceCompletionBlock = serviceCompletionBlock
        return operation
    }

    private override init() {
        super.init()
    }

    override func start() {
        super.start()
        if isCancelled {
            state = .finished
            return
        }

        invokeService()
        state = .executing
    }

    private func invokeService() {
        super.main()
        guard let dataModel = dataModel else {
            assert(true, "coding error")
            return
        }
        guard let urlRequest = constructUrlRequest(serviceRequest: dataModel.request) else {
            tLog("unable to build request - \(dataModel.request)")
            state = .finished
            return
        }

        processRequest(request: urlRequest)
    }

    private func constructUrlRequest(serviceRequest: TMServiceRequest) -> URLRequest? {

        guard let url = URL(string: serviceRequest.apiEndPoint) else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.httpMethod = serviceRequest.httpMethod.uppercased()
        urlRequest.httpShouldHandleCookies = false
        urlRequest.timeoutInterval = 10

        if let headers = serviceRequest.additionalHeaders {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        switch serviceRequest.httpMethod {
        case .post:
            guard let request = constructPostRequest(request: urlRequest, serviceRequest: serviceRequest) else {
                return nil
            }
            urlRequest = request

        case .get:
            switch serviceRequest.contentType {
            case .URLEncoded:
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            default:
                break
            }

        default:
            break
        }
        return urlRequest
    }

    private func constructPostRequest(request: URLRequest, serviceRequest: TMServiceRequest) -> URLRequest? {
        var urlRequest = request
        if let requestParams = serviceRequest.requestParams {
            switch serviceRequest.contentType {

            case .JSON:
                do {
                    let data = try JSONSerialization.data(withJSONObject: requestParams, options: [])
                    urlRequest.httpBody = data
                } catch {
                    tLog("Serialization Failure - requestParams")
                    return nil
                }

            default:
                break
            }

            if let body = urlRequest.httpBody {
                urlRequest.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
            }
        }
        return urlRequest
    }

    private func processRequest(request: URLRequest) {
        let requestInitiatedTime = Date()
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [weak self, unowned session] (data, response, error) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.performServiceCompletion(timeTaken: -(requestInitiatedTime.timeIntervalSinceNow) ,
                                                data: data,
                                                response: response,
                                                error: error)
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }

    private func performServiceCompletion(timeTaken: Double,
                                          data: Data?,
                                          response: URLResponse?,
                                          error: Error?) {

        guard let dataModel = dataModel else {
            assert(true, "programing error")
            return
        }

        dataModel.response.timeTaken = timeTaken
        if let response = response as? HTTPURLResponse {
            dataModel.response.statusCode = response.statusCode
        }

        if let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
            dataModel.response.responseData = data
        } else {
            dataModel.response.isResponseFailed = true
        }

        if let error = error {
            dataModel.response.error = error
            dataModel.response.isResponseFailed = true
        }

        serviceCompletionBlock?(dataModel)
        state = .finished
    }
}

extension TMServiceOperation: URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let trust = challenge.protectionSpace.serverTrust else {
            return
        }
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}
