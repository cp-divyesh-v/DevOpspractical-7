//
//  ContactDetailsView.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import SwiftUI

struct ContactDetailsView: View {
    @ObservedObject var viewModel = ContactListViewModel()
    var contact: Contact
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    Spacer()
                    Text("Contact Details")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        
                    } label: {
                        NavigationLink(destination: AddContactView(contact: contact).environmentObject(viewModel)) {
                            Text("Edit")
                        }
                    }

                }
                
                if let profileImageData = contact.profileImageData, let profileImage = UIImage(data: profileImageData) {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }

                Text(contact.name)
                    .font(.title)
                    .fontWeight(.semibold)
                
                if !contact.phoneNumbers.isEmpty {
                    HStack {
                        Text("Phone Number :")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        VStack {
                            ForEach(contact.phoneNumbers, id: \.self) { phoneNumber in
                                Text(phoneNumber)
                                    .font(.body)
                            }
                        }
                    }
                }

                if let birthDate = contact.birthDate {
                    HStack {
                        Text("Birthdate :").foregroundColor(.gray)
                        Text(formattedDate(birthDate))
                            .font(.body)
                    }
                }


                if let address = contact.address {
                    HStack {
                        Text("Address :").foregroundColor(.gray)
                        Text(address)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer()

                Button(action: {
                    viewModel.deleteContact(contact)
                }) {
                    Text("Delete Contact")
                        .foregroundColor(.red)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .bottom)
            }
            .onAppear {
                viewModel.fetchContacts()
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
}

struct ContactDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailsView(viewModel: .init(), contact: .init(name: "", phoneNumbers: []))
    }
}
