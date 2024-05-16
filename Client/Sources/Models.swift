//
//  Models.swift
//  Client
//
//  Created by Răzvan Roşu on 15/05/24.
//

import Foundation

public struct Contact {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

func createContact(name: String) -> Contact {
    Contact(id: UUID().uuidString, name: name)
}

public struct NewContact {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
