//
//  APIHelper.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Keys

typealias CompletionBlock = (_ result: JSON) -> Void

struct APIHelper {
    
    //MARK: - API Config -
    static let baseURL  = ConfigHelper.getApiBaseUrl()
    static let key      = AHNewsFeedKeys().guardianaApiKey
    
    //MARK: - Public Methods -
    
    static func isConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func request( _ method: HTTPMethod,
                         _ url: String,
                         _ parameters: [String: Any]? = nil,
                         _ showProgress: Bool = true,
                         completionBlock: @escaping CompletionBlock)
    {
        if showProgress { UIHelper.showProgressHUD() }
        
        let URL = baseURL + url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let headers = ["api-key" : key]
        let manager = Alamofire.SessionManager.default

        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request( URL,
                         method: method,
                         parameters: parameters,
                         encoding: URLEncoding.default,
                         headers: headers )
            .responseJSON { response in
                let parameters  = parameters == nil ? "": "\nParams: " + "\(parameters!)"
                let result  = "\nRequest: " + method.rawValue + " " + URL + parameters
                print(result)
                
                switch response.result {
                case .success(let data):
                    let json = handleResponse(data)
                    if let json = json {
                        completionBlock(json)
                    }
                    
                case .failure(let error):
                    UIHelper.showHUD(error.localizedDescription)
                }
                
                if showProgress { UIHelper.hideProgressHUD() }
        }
    }
    
    //MARK: - Private Methods -
    private static func handleResponse(_ response: Any) -> JSON? {
        let data = JSON(response)
        let status  = data["response"]["status"].stringValue
        let message = data["response"]["message"].stringValue

        switch status {
        case "error":
            if !message.isEmpty { UIHelper.showHUD(message) }
            return nil
            
        default:
            if !message.isEmpty { UIHelper.showHUD(message) }
            print("Response:")
            print(data)
            return data
        }
    }
}
