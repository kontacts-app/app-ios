//
//  ContactsRepository.swift
//  Contacts
//
//  Created by Răzvan Roşu on 13/02/24.
//  Copyright © 2024 razvan.red. All rights reserved.
//

import Combine

public final class ContactsRepository {
    
    private let contacts = CurrentValueSubject<[ContactId: Contact], Never>(
        mockContacts
            .map { contact in
                (contact.id, contact)
            }
            .reduce(into: [:]) { dictionary, tuple in
                dictionary[tuple.0] = tuple.1
            }
    )
    
    public init() { }
    
    public func add(new contact: NewContact) {
        var contacts = contacts.value
        let id = ContactId()
        contacts[id] = Contact(id: id, name: contact.name)
        self.contacts.send(contacts)
    }
    
    public func update(contact: Contact) {
        var contacts = contacts.value
        contacts[contact.id] = contact
        self.contacts.send(contacts)
    }
    
    public func remove(id: ContactId) {
        var contacts = contacts.value
        contacts.removeValue(forKey: id)
        self.contacts.send(contacts)
    }
    
    public func observe(byId id: ContactId) -> AnyPublisher<Contact?, Never> {
        contacts
            .map { contacts in contacts[id] }
            .eraseToAnyPublisher()
    }
    
    public func observeSections() -> AnyPublisher<[ContactsSection], Never> {
        contacts
            .map { sections in
                Dictionary(
                    grouping: sections.values.sorted(by: { $0.name < $1.name }),
                    by: { $0.name.first! }
                )
                    .map { initial, contacts in
                        ContactsSection(initial: initial, contacts: contacts)
                    }
                    .sorted(by: { $0.initial < $1.initial })
            }
            .eraseToAnyPublisher()
    }
}
