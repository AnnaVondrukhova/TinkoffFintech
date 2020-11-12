//
//  HelperFunctions.swift
//  TinkoffFintech
//
//  Created by Anya on 10.11.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import FirebaseFirestore

class HelperFunctions {
    static func makeDateFromTimestamp(_ timestamp: Any?) -> Date? {
        return (timestamp as? Timestamp)?.dateValue()
    }
    
    static func makeTimestampFromDate(_ date: Date) -> Timestamp {
        return Timestamp(date: date)
    }
}
