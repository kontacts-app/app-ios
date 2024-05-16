//
//  ContactsRepository.swift
//  Contacts
//
//  Created by Răzvan Roşu on 13/02/24.
//  Copyright © 2024 razvan.red. All rights reserved.
//

import Combine
import Client

public final class ContactsRepository {
    
    private let client: KontactsClient
    
    private let contacts = CurrentValueSubject<[ContactId: Contact], Never>(
        [:]
    )
    
    public init(client: KontactsClient) {
        self.client = client
    }
    
    public func refreshContacts() {
        let remote = client.getAll()
        self.contacts.send(
            remote
                .map { contact in contact.toModel() }
                .map { contact in
                    (contact.id, contact)
                }
                .reduce(into: [:]) { dictionary, tuple in
                    dictionary[tuple.0] = tuple.1
                }
        )
    }
    
    public func add(new contact: NewContact) {
        let remoteCreated = client.addNewContact(contact.toRemote())
        let created = remoteCreated.toModel()
        var contacts = contacts.value
        contacts[created.id] = created
        self.contacts.send(contacts)
    }
    
    public func update(contact: Contact) {
        let remoteUpdated = client.updateById(
            id: contact.id.value,
            contact: RemoteNewContact(name: contact.name)
        )
        var contacts = contacts.value
        contacts[contact.id] = remoteUpdated.toModel()
        self.contacts.send(contacts)
    }
    
    public func remove(id: ContactId) {
        client.deleteById(id.value)
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
