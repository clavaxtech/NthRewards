//
//  MyRequestAdapter.swift
//  SampleApp
//
//  Created by akshay on 12/23/19.
//  Copyright © 2019 akshay. All rights reserved.
//

import Foundation
import Alamofire

class MyRequestAdapter: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    
    private let lock = NSLock()
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    var accessToken:String? = nil
    var refreshToken:String? = nil
    static let shared = MyRequestAdapter()
    
    private init(){
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.adapter = self
        sessionManager.retrier = self
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Base.TOKEN_URL), !urlString.hasSuffix("/token") {
            if let token = accessToken {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        return urlRequest
    }
    
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let accessToken = accessToken {
                        strongSelf.accessToken = accessToken
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        //let urlString = "\(Base.TOKEN_URL)token/renew"
        let urlString = "\(Base.TOKEN_URL)token"
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization":"Bearer \(refreshToken!)"]).responseJSON { [weak self] response in
            guard let strongSelf = self else { return }
            if
                let json = response.result.value as? [String: Any],
                let accessToken = json["accessToken"] as? String
            {
                completion(true, accessToken)
            } else {
                completion(false, nil)
            }
            strongSelf.isRefreshing = false
        }
        
    }
}
