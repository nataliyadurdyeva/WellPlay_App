//
//  PhotoUploader.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage


struct PhotoUploader {
    static func uploadPhoto(image: UIImage, completion: @escaping(String) -> Void) {
        guard let pictureData = image.jpegData(compressionQuality: 0.5) else { return }

        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(pictureData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
                        
            ref.downloadURL { url, _ in
                guard let pictureUrl = url?.absoluteString else { return }
                completion(pictureUrl)
            }
        }
    }
}
