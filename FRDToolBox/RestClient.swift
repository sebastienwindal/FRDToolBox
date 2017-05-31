//
//  RestClient.swift
//  FRDToolBox
//
//  Created by Sebastien Windal on 5/31/17.
//  Copyright © 2017 Sebastien Windal. All rights reserved.
//

import Foundation
import ObjectMapper

public enum RestClientError: Error {
    case InvalidArgumentError
    case InvalidResponseError
    case HTTPResponseError(errCode: Int)
    case NoData
    case JSONParsingError
}


public class RestClient {
    fileprivate var rootURL = ""
    
    public static var sharedInstance = RestClient()
    
    public func setup(with rootURL:String) {
        self.rootURL = rootURL
    }
    
    public func index<T:BaseModel>(_ objtype:T.Type, completion: @escaping (Result<[T]>) -> Void) {
        
        let urlStr: String = "\(rootURL)\(T.indexRoute())"
        
        guard let url = URL(string:urlStr) else {
            print("invalid URL")
            completion(Result.Failure(RestClientError.InvalidArgumentError))
            return
        }
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            //
            // build a result object initialized with either an error or the json payload.
            //
            completion(Result {
                guard
                    let httpResponse = urlResponse as? HTTPURLResponse
                    else { throw RestClientError.InvalidResponseError }
                
                switch (httpResponse.statusCode) {
                case 200:
                    guard let data = data, let response = String(data: data, encoding: .utf8) else { throw RestClientError.NoData }
                    guard let arr = Mapper<T>().mapArray(JSONString: response)  else { throw RestClientError.JSONParsingError }
                    
                    return arr
                default:
                    throw RestClientError.HTTPResponseError(errCode: httpResponse.statusCode)
                }
            })
        }
        
        task.resume()
    }
}

