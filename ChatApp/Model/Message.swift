//
//  Message.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import Foundation

struct Message: Identifiable, Codable, Hashable {
    
    var id = UUID().uuidString
    
    private enum CodingKeys : String, CodingKey { case text }
    
    var text: String
    
}
