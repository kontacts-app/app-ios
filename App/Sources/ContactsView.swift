//
//  ContentView.swift
//  Contacts
//
//  Created by Răzvan Roşu on 13/02/24.
//  Copyright © 2024 razvan.red. All rights reserved.
//

import SwiftUI
import Repository
import Client

struct ContactsView : View {
    
    // The designed behavior for the New Contact dialog is to disable the "Create"
    //  button until the user enters a value that is not blank.
    //  Due to https://forums.developer.apple.com/forums/thread/737964 this implementation
    //  is not possible.
    //
    // Hopefully iOS 25.1 will bring us a working SwiftUI implementation.
    
    @StateObject
    var viewModel: ContactsViewModel = ContactsViewModel(repository: ContactsRepository(client: KontactsClient()))
    
    @State
    private var isAddContactAlertPresented: Bool = false
    
    @State
    private var contactNameFieldValue: String = ""
    
    private var contactNameFieldValueResult: String {
        contactNameFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var isAddContactAlertCreateButtonDisabled: Bool {
        contactNameFieldValue.isEmpty
    }
    
    var body : some View {
        NavigationView {
            List {
                ForEach (viewModel.sections, id: \.initial) { section in
                    Section(header: InitialHeader(letter: section.initial)) {
                        ForEach(section.contacts) { contact in
                            NavigationLink {
                                ContactDetailView(viewModel: viewModel, contact: contact)
                            } label: {
                                ContactRow(contact: contact)
                            }
                        }
                        .onDelete(perform: { offsets in
                            offsets.forEach { i in
                                viewModel.remove(id: section.contacts[i].id)
                            }
                        })
                    }
                }
            }
            .navigationTitle(Bundle.main.displayName!)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            contactNameFieldValue = ""
                            isAddContactAlertPresented = true
                        },
                        label: {
                            Image(systemName: "plus")
                        }
                    )
                    .alert(
                        String(localized: "Create new contact dialog title"),
                        isPresented: $isAddContactAlertPresented,
                        actions: {
                            TextField(String(localized: "Contact name field name"), text: $contactNameFieldValue)
                            
                            Button(action: {
                                //viewModel.add(new: NewContact(name: contactNameFieldValueResult))
                                viewModel.add(new: NewContact(name: contactNameFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)))
                                isAddContactAlertPresented = false
                            }, label: { Text(String(localized: "Create dialog button")) })
                            //.disabled(isAddContactAlertCreateButtonDisabled)
                            
                            Button(role: .cancel, action: {
                                isAddContactAlertPresented = false
                            }, label: { Text(String(localized: "Cancel dialog button")) })
                        }
                    )
                }
            }
        }
        .task {
            viewModel.fetch()
        }
    }
}

fileprivate struct InitialHeader : View {
    let letter: Character
    
    var body: some View {
        Text(String(letter))
    }
}

fileprivate struct ContactRow : View {
    let contact: Repository.Contact
    
    var body: some View {
        Text(contact.name)
    }
}

fileprivate extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
