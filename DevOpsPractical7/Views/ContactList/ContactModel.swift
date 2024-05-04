//
//  ContactModel.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Contact: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var phoneNumbers: [String]
    var profileImage: String?
    var birthDate: Date?
    var address: String?
    var profileImageData: Data?
}
