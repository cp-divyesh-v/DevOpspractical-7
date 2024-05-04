//
//  ContactListViewModel.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import Foundation
import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class ContactListViewModel: ObservableObject {
    let db = Firestore.firestore()
    private var contactsCollectionRef: CollectionReference {
        return db.collection("contacts")
    }
    
    @Published var contacts: [Contact] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        observeContacts()
    }
    
    func observeContacts() {
        let listener = contactsCollectionRef
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching contacts: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                let contacts = documents.compactMap { snapshot in
                    try? snapshot.data(as: Contact.self)
                }
                self.contacts = contacts
            }
        
        cancellables.insert(AnyCancellable {
            listener.remove()
        })
    }
    
    func fetchContacts() {
        let contactsCollection = db.collection("contacts")
        
        contactsCollection.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching contacts: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No contacts found")
                return
            }
            
            self.contacts = documents.compactMap { document in
                try? document.data(as: Contact.self)
            }
        }
    }
    
    func deleteContact(_ contact: Contact) {
        if let contactID = contact.id {
            let contactsCollection = db.collection("contacts")
            contactsCollection.document(contactID).delete { error in
                if let error = error {
                    print("Error deleting contact: \(error)")
                }
            }
        }
    }
}
