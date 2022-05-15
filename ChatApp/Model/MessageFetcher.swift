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
    
    func fetchMessages(offset: Int, completion: @escaping (Result<[Message], Error>) -> Void) {
        
        AF.request("https://numero-logy-app.org.in/getMessages?offset=\(offset)").responseJSON { response in
            
            switch response.result {
            
            case .success(let value):
                
                let jsonedValue = JSON(value)
                
                var tempArr = [Message]()
                let decodedResults = jsonedValue["result"]
                for i in offset...offset + 20 {
                    tempArr.append(Message(id: String(i), text: decodedResults[i].stringValue))
                    //["result"].arrayValue.map { Message(text: $0.stringValue)}))
                    
                    
                }
                let decodedResultsMapped = zip(offset...offset + 20, jsonedValue["result"]).map { Message(id: String($0.0), text: $0.1.1.stringValue) }
                //zip([offset...offset+20], jsonedValue["result"]).map { Message(id: String($0), text: $1.0) }
//                if decodedResults != [] {
                
                completion(.success(decodedResultsMapped))
//                }
//                else if response.error != nil{
//
//                    completion(.success([Message(text: "error loading from server, press to retry")]))
//                }
//                else if decodedResults.isEmpty {
//
//               completion(.success([Message(text: "nothing to load")]))
//
//                }
            
            case .failure(let error):
                var tempArr = [Message]()
                for i in offset...offset + 20 {
                    tempArr.append(Message(id: String(i), text: "Error loading from server, press to retry"))
                }
                completion(.success(tempArr))
                completion(.failure(error))
            }
            
        }
    }
}

