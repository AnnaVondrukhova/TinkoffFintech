//
//  PhotoService.swift
//  TinkoffFintech
//
//  Created by Anya on 16.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoServiceProtocol {
    func getPhoto(urlString: String, completion: @escaping (UIImage?, NetworkError?) -> Void)
}

class PhotoService: PhotoServiceProtocol {
    let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getPhoto(urlString: String, completion: @escaping (UIImage?, NetworkError?) -> Void) {
        let request = PhotoRequest(urlString: urlString)
        
        requestManager.sendRequest(request: request) { (result) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image, nil)
                } else {
                    completion(nil, .parseError)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
