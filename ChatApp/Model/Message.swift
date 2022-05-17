//
//  Message.swift
//  ChatApp
//
//  Created by s b on 13.05.2022.
//

import Foundation

struct Message: Identifiable, Hashable {
    
    var id = UUID().uuidString
    
    var loaded = true
    
    var text: String?
    
}
