//
//  RequestManagerMock.swift
//  TinkoffFintechTests
//
//  Created by Anya on 01.12.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

@testable import TinkoffFintech
import Foundation

class RequestManagerMock: RequestManagerProtocol {
    var receivedUrl = ""
    var completionStub: (((Result<Data, NetworkError>) -> Void) -> Void)!
    
    func sendRequest(request: UrlRequestProtocol, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest = request.urlRequest else {
            completion(.failure(.urlError))
            return
        }
        
        receivedUrl = urlRequest.url?.absoluteString ?? ""
        completionStub(completion)
    }
}
