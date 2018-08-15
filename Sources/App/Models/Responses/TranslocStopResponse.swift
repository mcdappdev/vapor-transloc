//
//  TranslocStopResponse.swift
//  App
//
//  Created by Jimmy McDermott on 8/15/18.
//

import Foundation
import Vapor

struct TranslocStopResponse: Content {
    
    let data: [Data]
    
    struct Data: Content {
        let stop_id: String
        let name: String
    }
}
