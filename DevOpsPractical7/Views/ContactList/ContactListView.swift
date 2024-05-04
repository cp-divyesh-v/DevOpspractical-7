//
//  ContactListView.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import SwiftUI

struct ContactListView: View {
    
    @ObservedObject var viewModel = ContactListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.contacts.isEmpty {
                    Text("No Contact found")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.contacts) { contact in
                                NavigationLink(destination: ContactDetailsView(contact: contact)) {
                                    HStack(spacing: 16) {
                                        if let imageData = contact.profileImageData,
                                           let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                                .foregroundColor(.gray)
                                        }
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(contact.name)
                                                .font(.title3)
                                            VStack(spacing: 2) {
                                                ForEach(contact.phoneNumbers, id: \.self) { number in
                                                    Text(number)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                        .onDelete(perform: deleteContact(at:))
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Contacts")
            .navigationBarItems(trailing:
                                    NavigationLink(destination: AddContactView(contact: nil)) {
                Image(systemName: "plus")
            })
            
        }
        .onAppear {
            viewModel.fetchContacts()
        }
    }
    
    private func deleteContact(at offsets: IndexSet) {
        offsets.forEach { index in
            let contactToDelete = viewModel.contacts[index]
            viewModel.deleteContact(contactToDelete)
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
