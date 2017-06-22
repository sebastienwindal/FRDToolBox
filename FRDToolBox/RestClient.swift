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
    fileprivate var rootURL:URL!
    fileprivate var dispatchSemaphore:DispatchSemaphore!
    fileprivate var numberConcurentRestCalls = 10
    fileprivate var maxThrottleDelay = 10.0
    
    
    public static var sharedInstance = RestClient()
    
    public func setup(with rootURL:String) throws {
        
        guard let url = URL(string:rootURL) else {
            throw RestClientError.InvalidArgumentError
        }
        self.rootURL = url
        dispatchSemaphore = DispatchSemaphore(value: numberConcurentRestCalls)
    }
    
    
    public func index<T:BaseModel>(_ objtype:T.Type, completion: @escaping (Result<[T]>) -> Void) {
        var url:URL = self.rootURL
        url.appendPathComponent(T.indexRoute())
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        send(request: request) { (result) in
            completion(Result {
                switch(result) {
                case .Success(let data):
                    guard let response = String(data: data, encoding: .utf8) else { throw RestClientError.NoData }
                    guard let arr = Mapper<T>().mapArray(JSONString: response)  else { throw RestClientError.JSONParsingError }
                    return arr
                case .Failure(let error):
                    throw error
                }
            })
        }
    }
    
    
    public func get<T:BaseModel>(_ objType:T.Type, id:String? = nil, completion: @escaping (Result<T>) -> Void) {
        var url:URL = self.rootURL
        url.appendPathComponent(T.getRoute())
        if let id = id {
            url.appendPathComponent(id)
        }
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        send(request: request) { (result) in
            completion(Result {
                switch(result) {
                case .Success(let data):
                    guard let response = String(data: data, encoding: .utf8) else { throw RestClientError.NoData }
                    guard let obj = Mapper<T>().map(JSONString: response) else { throw RestClientError.JSONParsingError }
                    return obj
                case .Failure(let error):
                    throw error
                }
            })
        }
    }
    
    public func post<T:BaseModel>(_ objType:T.Type, model:T, completion: @escaping (Result<T>) -> Void) {
        var url:URL = self.rootURL
        url.appendPathComponent(T.postRoute())
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let json = model.toJSONString()
        request.httpBody = json?.data(using: .utf8)
        
        
        send(request: request) { (result) in
            completion(Result {
                switch(result) {
                case .Success(let data):
                    guard let response = String(data: data, encoding: .utf8) else { throw RestClientError.NoData }
                    guard let obj = Mapper<T>().map(JSONString: response) else { throw RestClientError.JSONParsingError }
                    return obj
                case .Failure(let error):
                    throw error
                }
            })
        }
    }
    
    public func update<T:BaseModel>(_ objType:T.Type, id:String, model:T, completion: @escaping (Result<T>) -> Void) {
        var url:URL = self.rootURL
        url.appendPathComponent(T.updateRoute())
        url.appendPathComponent(id)
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "UPDATE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let json = model.toJSONString()
        request.httpBody = json?.data(using: .utf8)
        
        send(request: request) { (result) in
            completion(Result {
                switch(result) {
                case .Success(let data):
                    guard let response = String(data: data, encoding: .utf8) else { throw RestClientError.NoData }
                    guard let obj = Mapper<T>().map(JSONString: response) else { throw RestClientError.JSONParsingError }
                    return obj
                case .Failure(let error):
                    throw error
                }
            })
        }
    }
    
    public func delete<T:BaseModel>(_ objType:T.Type, id:String, completion: @escaping (Result<T?>) -> Void) {
        var url:URL = self.rootURL
        url.appendPathComponent(T.deleteRoute())
        url.appendPathComponent(id)
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        send(request: request) { (result) in
            completion(Result {
                switch(result) {
                case .Success(_):
                    return nil
                case .Failure(let error):
                    throw error
                }
            })
        }
    }
   
    public func send(request:URLRequest, completion: @escaping (Result<Data>) -> Void) {

        DispatchQueue.global().async {
            
            let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                self.dispatchSemaphore.signal()
                
                completion(Result {
                    guard let httpResponse = urlResponse as? HTTPURLResponse
                        else { throw RestClientError.InvalidResponseError }
                    switch (httpResponse.statusCode) {
                    case 200:
                        guard let data = data else { throw RestClientError.NoData }
                        return data
                    default:
                        throw RestClientError.HTTPResponseError(errCode: httpResponse.statusCode)
                    }
                })
            }
            
            print("waiting")
            _ = self.dispatchSemaphore.wait(timeout: .now() + self.maxThrottleDelay)
            print("strop waiting")
            
            print(request)
            
            task.resume()
    
        }
     }

    
}

