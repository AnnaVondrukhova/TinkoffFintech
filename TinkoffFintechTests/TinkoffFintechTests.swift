//
//  TinkoffFintechTests.swift
//  TinkoffFintechTests
//
//  Created by Anya on 30.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

@testable import TinkoffFintech
import XCTest

class TinkoffFintechTests: XCTestCase {

    func testGCDFileServiceCallsSaveToFileManager() {
        //given
        let testName = "test name"
        let testPhoto = UIImage(named: "icon_send")
        let saveToFileManagerMock = SaveToFileManagerMock()
        let savePhotoExpectation = expectation(description: "Save photo expectation")

        //when
        let gcdFileServiceMock = GCDFileService(saveToFileManager: saveToFileManagerMock)
        gcdFileServiceMock.saveData(name: testName, description: nil, photo: testPhoto) { (_, _) in
            savePhotoExpectation.fulfill()
        }
        
        //then
        waitForExpectations(timeout: 5) { _ in
            XCTAssertEqual("test name", testName)
            XCTAssertEqual(saveToFileManagerMock.savedData, testPhoto?.pngData())
        }
    }
    
    func testRequestManagerGetsValidURL() {
        //given
        let urlString = "https://pixabay.com/api/?key=19099745-2e27ab96f19dd46a70f143587&q=funny+cat&image_type=photo&per_page=100"
        let requestManagerMock = RequestManagerMock()
        requestManagerMock.completionStub = { completion in
            completion(.success(Data()))
        }
        
        //when
        let allPhotosService = AllPhotosService(requestManager: requestManagerMock)
        allPhotosService.getAllPhotos(searchText: Constants.searchText) { (_, _) in
            
        }
        
        //then
        XCTAssertEqual(urlString, requestManagerMock.receivedUrl)
    }

    func testDataIsCashed() {
        //given
        let searchText = Constants.searchText
        let urlRequest = AllPhotosRequest(searchText: searchText).urlRequest!
        let requestManager = RequestManager(urlSession: URLSession.shared)
        let cacheDataExpectation = expectation(description: "Data was cached expectation")
        var receivedData: Data?
        
        //when
        let allPhotosService = AllPhotosServiceMock(requestManager: requestManager)
        allPhotosService.getAllPhotos(searchText: searchText) { (_, _) in
            receivedData = allPhotosService.receivedData
            cacheDataExpectation.fulfill()
        }
        
        //then
        waitForExpectations(timeout: 5) { _ in
            let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest)
            XCTAssertNotNil(cachedResponse)
            XCTAssertEqual(cachedResponse?.data, receivedData)
        }
    }
}
