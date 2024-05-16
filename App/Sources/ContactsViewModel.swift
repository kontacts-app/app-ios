//
//  ContactViewModel.swift
//  Contacts
//
//  Created by Răzvan Roşu on 13/02/24.
//  Copyright © 2024 razvan.red. All rights reserved.
//

import SwiftUI
import Repository
import Combine

class ContactsViewModel : ObservableObject {
    
    private let repository: ContactsRepository
    
    @Published private(set) var sections: [ContactsSection] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ContactsRepository) {
        self.repository = repository
        
        repository.observeSections()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] sections in
                self?.sections = sections
            })
            .store(in: &cancellables)
    }
    
    func fetch() {
        repository.refreshContacts()
    }
    
    func observe(byId id: ContactId) -> AnyPublisher<Contact?, Never> {
        repository.observe(byId: id)
    }
    
    func add(new contact: NewContact) {
        repository.add(new: contact)
    }
    
    func update(contact: Contact) {
        repository.update(contact: contact)
    }
    
    func remove(id: ContactId) {
        repository.remove(id: id)
    }
}
