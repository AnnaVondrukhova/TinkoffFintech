//
//  ImageCellModel.swift
//  TinkoffFintech
//
//  Created by Anya on 16.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

protocol ImageCellModelProtocol {
    func loadPhoto(urlString: String, completion: @escaping (UIImage?) -> Void)
}

class ImageCellModel: ImageCellModelProtocol {
    private let photoService: PhotoServiceProtocol
    
    init(photoService: PhotoServiceProtocol) {
        self.photoService = photoService
    }
    
    func loadPhoto(urlString: String, completion: @escaping (UIImage?) -> Void) {
        photoService.getPhoto(urlString: urlString) { (image, error) in
            if let error = error {
                
                switch error {
                case .urlError:
                    print("Failed to get URL from previewURL")
                case .requestError:
                    print("Got photo request error")
                case .dataError:
                    print("Can't get photo data")
                case .parseError:
                    print("Can't parse photo data")
                }
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
}
