//
//  AddContactView.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import SwiftUI

struct AddContactView: View {
    @ObservedObject var viewModel: AddContactViewModel
    @State private var isImagePickerPresented = false
    @Environment(\.presentationMode) var presentationMode
    var contact: Contact?
    
    private var profileImage: UIImage? {
        viewModel.selectedImage ?? viewModel.originalImage
    }

    init(contact: Contact? = nil) {
        self.contact = contact
        self.viewModel = AddContactViewModel(contact: contact)
        if let contact = contact {
            self.viewModel.fetchContactData(contact)
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                Text(contact?.name == nil ? "Add Contact" : "Edit contact")
                    .font(.title3)
                    .fontWeight(.medium)

                Button {
                    isImagePickerPresented = true
                } label: {
                    if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(isImagePickerPresented: $isImagePickerPresented, selectedImage: $viewModel.selectedImage, sourceType: .photoLibrary, isProfileImageUpdated: $viewModel.isProfileImageUpdated)
                }
                
                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding(.top)
                }

                customTextField("Name", text: $viewModel.name)
                    .padding(.top)
                    .onChange(of: viewModel.name) { newValue in
                        if newValue.count < 3 {
                            viewModel.showError = true
                            viewModel.errorMessage = newValue.count < 3 ? "Name must contains at least 3 character" : ""
                        } else {
                            viewModel.showError = false
                        }
                    }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Numbers").foregroundColor(.gray)
                    customTextField("Phone Number 1", text: $viewModel.phoneNumber1)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.phoneNumber1) { newValue in
                            if newValue.count < 3 {
                                viewModel.showError = true
                                viewModel.errorMessage = newValue.count < 3 ? "Phone Number must contains at least 3 character" : ""
                            } else {
                                viewModel.showError = false
                            }
                        }
                    customTextField("Phone Number 2 (optional)", text: $viewModel.phoneNumber2)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.phoneNumber2) { newValue in
                            if newValue.count < 3 {
                                viewModel.showError = true
                                viewModel.errorMessage = newValue.count < 3 ? "Phone number must contains at least 3 character" : ""
                            } else {
                                viewModel.showError = false
                            }
                        }
                }
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)

                DatePicker("Birth Date", selection: $viewModel.birthDate, in: ...Date(), displayedComponents: .date)
                    .padding(.top)

                customTextField("Address", text: $viewModel.address)
                    .lineLimit(3)
                    .onChange(of: viewModel.address) { newValue in
                        if newValue.count < 3 {
                            viewModel.showError = true
                            viewModel.errorMessage = newValue.count < 3 ? "Address must contains at least 3 character" : ""
                        } else {
                            viewModel.showError = false
                        }
                    }

                Button {
                    if contact?.name == nil {
                        viewModel.phoneNumbers = [viewModel.phoneNumber1, viewModel.phoneNumber2]
                        viewModel.addContact { success in
                            if success {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } else {
                        viewModel.phoneNumbers = [viewModel.phoneNumber1, viewModel.phoneNumber2]
                        if viewModel.isProfileImageUpdated, let selectedImage = viewModel.selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.5) {
                            viewModel.profileImageData = imageData
                        }
                        viewModel.updateContact(contact!) { success in
                            if success {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                } label: {
                    Text(contact?.name == nil ? "Save" : "Update")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.top)
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }

    private func customTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text, axis: .vertical)
            .padding(.horizontal)
            .frame(height: 50)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView(contact: .init(name: "", phoneNumbers: []))
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isImagePickerPresented: Bool
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    @Binding var isProfileImageUpdated: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
                parent.isProfileImageUpdated = true
            }
            parent.isImagePickerPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
    }
}
