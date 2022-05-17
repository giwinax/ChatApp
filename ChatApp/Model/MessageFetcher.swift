//
//  MessageFetcher.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//
import Alamofire
import SwiftyJSON
import Foundation

class MessageFetcher {
    
    func fetchMessages(offset: Int, completion: @escaping (Result<[Message], errorEmun>) -> Void) {
        
        AF.request("https://numero-logy-app.org.in/getMessages?offset=\(offset)").responseJSON { response in
            
            switch response.result {
            
            case .success(let value):
                
                let jsonedValue = JSON(value)
                
                if !jsonedValue["result"].isEmpty {
                    
                let decodedResultsMapped = zip(offset...offset + 20, jsonedValue["result"]).map { Message(id: String($0.0), loaded: true, text: $0.1.1.stringValue) }
                completion(.success(decodedResultsMapped))

                } else {
                    completion(.failure(.endOfDataError))
                }
            case .failure(_):
                let decodedResultsMapped = zip(offset...offset + 20, "Error loading from server, press to retry").map { Message(id: String($0.0), loaded: false, text: "Error loading from server, press to retry") }
                completion(.success(decodedResultsMapped))
                completion(.failure(.serverError))
            }
            
        }
    }
}
