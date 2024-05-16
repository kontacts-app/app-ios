//
//  Mappers.swift
//  Repository
//
//  Created by Răzvan Roşu on 16/05/24.
//

import Foundation
import Client

typealias RemoteContact = Client.Contact
typealias RemoteNewContact = Client.NewContact

extension RemoteContact {
    func toModel() -> Contact {
        Contact(id: ContactId(id), name: name)
    }
}

extension NewContact {
    func toRemote() -> RemoteNewContact {
        RemoteNewContact(name: name)
    }
}

extension Contact {
    func toRemote() -> RemoteContact {
        RemoteContact(id: id.value, name: name)
    }
}
