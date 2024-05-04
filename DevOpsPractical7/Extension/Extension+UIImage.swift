//
//  Extension+UIImage.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI

// Extension to upload and download images from Firebase Cloud Storage
extension UIImage {
    func upload(to path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        if let data = self.jpegData(compressionQuality: 0.5) {
            let storageRef = Storage.storage().reference(withPath: path)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            storageRef.putData(data, metadata: metadata) { (_, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            completion(.failure(error))
                        } else if let url = url {
                            completion(.success(url))
                        }
                    }
                }
            }
        }
    }
}

extension URL {
    func download(completion: @escaping (Result<UIImage, Error>) -> Void) {
        SDWebImageDownloader.shared.downloadImage(with: self) { (image, _, error, _) in
            if let error = error {
                completion(.failure(error))
            } else if let image = image {
                completion(.success(image))
            }
        }
    }
}
