//
//  MessageFetcher.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//
import Alamofire
import SwiftyJSON

class MessageFetcher {
    
    func fetchMessages(offset: Int, completion: @escaping (Result<[Message], Error>) -> Void) {
        
        AF.request("https://numero-logy-app.org.in/getMessages?offset=\(offset)").responseJSON { response in
            
            switch response.result {
            
            case .success(let value):
            
                completion(.success(JSON(value)["result"].arrayValue.map { Message(text: $0.stringValue)}))
            
            case .failure(let error):
            
                completion(.failure(error))
            }
            
        }
    }
    
}

