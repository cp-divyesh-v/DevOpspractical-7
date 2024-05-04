//
//  AddContactViewModel.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class AddContactViewModel: ObservableObject {
    
    @Published var contacts: [Contact] = []
    
    private var db = Firestore.firestore()
    private var contactsCollectionRef: CollectionReference {
        return db.collection("contacts")
    }
    
    @Published var phoneNumbers: [String] = []
    @Published var birthDate = Date()
    @Published var profileImageData: Data?
    @Published var originalImage: UIImage?
    @Published var selectedImage: UIImage? {
        didSet {
            isProfileImageUpdated = true
        }
    }
    
    @Published var name = ""
    @Published var address = ""
    @Published var profileImage = ""
    @Published var phoneNumber1 = ""
    @Published var phoneNumber2 = ""
    @Published var errorMessage = ""
   
    @Published var isInitialProfileImageSet = false
    @Published var showError = false
    
    var isProfileImageUpdated = false
    
    
    init(contact: Contact? = nil, selectedImage: UIImage? = nil) {
        if let contact = contact {
            name = contact.name
            phoneNumbers = contact.phoneNumbers
            birthDate = contact.birthDate ?? Date()
            address = contact.address ?? ""
            profileImage = "\(String(describing: contact.profileImageData))"
            isInitialProfileImageSet = contact.profileImageData != nil
            self.selectedImage = selectedImage
            self.originalImage = selectedImage ?? UIImage(data: contact.profileImageData ?? Data()) // Set the originalImage based on selectedImage or profileImageData
            phoneNumber1 = contact.phoneNumbers.first ?? ""
            phoneNumber2 = contact.phoneNumbers.dropFirst().first ?? ""
        }
    }
    
    func setSelectedImage(_ image: UIImage?) {
           selectedImage = image
           isProfileImageUpdated = true
       }
    
    func addContact(completion: @escaping (Bool) -> Void) {
        guard !name.isEmpty, !phoneNumbers.isEmpty, !phoneNumbers[0].isEmpty else {
            showError = true
            errorMessage = "Name and phone number cannot be empty"
            completion(false)
            return
        }
        
        // Set phoneNumber2 to phoneNumber1 if there's only one number
        if phoneNumbers.count == 1 {
            phoneNumber2 = phoneNumber1
        }
        
        var newContact = Contact(name: name, phoneNumbers: phoneNumbers, profileImage: profileImage, birthDate: birthDate, address: address)
        newContact.profileImageData = profileImageData
        
        if let selectedImage = selectedImage,
           let imageData = selectedImage.jpegData(compressionQuality: 0.1) {
            newContact.profileImageData = imageData
        }
        do {
            let contactsCollection = db.collection("contacts")
            _ = try contactsCollection.addDocument(from: newContact)
            completion(true)
        } catch {
            print("Error adding contact: \(error)")
            completion(false)
        }
        
        showError = false
    }
    
    func updateContact(_ contact: Contact, completion: @escaping (Bool) -> Void) {
        guard !name.isEmpty, !phoneNumbers.isEmpty, !phoneNumbers[0].isEmpty else {
            showError = true
            errorMessage = "Name and phone number cannot be empty"
            completion(false)
            return
        }
        
        if phoneNumbers.count == 1 {
            phoneNumber2 = phoneNumber1
        }
        
        var updatedContact = Contact(name: name, phoneNumbers: phoneNumbers, profileImage: profileImage, birthDate: birthDate, address: address)
        updatedContact.profileImageData = profileImageData
        
        if isProfileImageUpdated,
           let selectedImage = selectedImage,
           let imageData = selectedImage.jpegData(compressionQuality: 0.1) {
            updatedContact.profileImageData = imageData
        } else {
            updatedContact.profileImageData = contact.profileImageData // Preserve the existing image data
        }
        
        do {
            let contactDocumentRef = contactsCollectionRef.document(contact.id!)
            try contactDocumentRef.setData(from: updatedContact)
            print(updatedContact)
            completion(true)
        } catch {
            print("Error updating contact: \(error)")
            completion(false)
        }
        
        showError = false
    }

    
    func fetchContactData(_ contact: Contact) {
        let contactDocumentRef = contactsCollectionRef.document(contact.name)
        contactDocumentRef.getDocument { document, error in
            if let document = document, document.exists {
                if let contact = try? document.data(as: Contact.self) {
                    DispatchQueue.main.async {
                        self.name = contact.name
                        self.address = contact.address ?? ""
                        self.birthDate = contact.birthDate ?? Date()
                        self.profileImage = "\(String(describing: contact.profileImageData))"
                        self.phoneNumber1 = contact.phoneNumbers.first ?? ""
                        self.phoneNumber2 = contact.phoneNumbers.dropFirst().first ?? ""
                        if let imageData = contact.profileImageData, let image = UIImage(data: imageData) {
                            self.selectedImage = image
                            self.originalImage = image
                            self.isInitialProfileImageSet = true
                        }
                    }
                }
            }
        }
    }
}

