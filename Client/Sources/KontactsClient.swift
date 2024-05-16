//
//  KontactsClient.swift
//  Client
//
//  Created by Răzvan Roşu on 15/05/24.
//

import Foundation

public class KontactsClient {
    public init() { }
    
    private var contacts: [String: Contact] =
        mockContacts
            .map { contact in
                (contact.id, contact)
            }
            .reduce(into: [:]) { dictionary, tuple in
                dictionary[tuple.0] = tuple.1
            }
    
    public func getAll() -> [Contact] {
        KontactsClient.network {
            Array(contacts.values)
        }
    }
    
    public func getById(_ id: String) -> Contact {
        KontactsClient.network {
            contacts[id]!
        }
    }
    
    public func deleteById(_ id: String) {
        KontactsClient.network {
            guard contacts.removeValue(forKey: id) != nil else {
                fatalError("Resource with id = \(id) not found")
            }
        }
    }
    
    public func updateById(id: String, contact: NewContact) -> Contact {
        KontactsClient.network {
            guard contacts[id] != nil else {
                fatalError("Resource with id = \(id) not found")
            }
            let created = Contact(id: id, name: contact.name)
            contacts[id] = created
            return created
        }
    }
    
    public func addNewContact(_ newContact: NewContact) -> Contact {
        KontactsClient.network {
            let created = createContact(name: newContact.name)
            contacts[created.id] = created
            return created
        }
    }
    
    private static func network<T>(_ block: () -> T) -> T {
        sleep(UInt32(Int.random(in: 1...3)))
        return block()
    }
}
