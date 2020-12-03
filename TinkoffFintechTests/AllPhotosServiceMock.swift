//
//  AllPhotosServiceMock.swift
//  TinkoffFintechTests
//
//  Created by Anya on 01.12.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

@testable import TinkoffFintech
import Foundation

class AllPhotosServiceMock: AllPhotosServiceProtocol {
    var receivedData = Data()
    let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getAllPhotos(searchText: String, completion: @escaping ([PhotoItem]?, NetworkError?) -> Void) {
        let request = AllPhotosRequest(searchText: searchText)

        requestManager.sendRequest(request: request) { (result) in
            
            switch result {
            case .success(let data):
                self.receivedData = data
                completion(nil, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
