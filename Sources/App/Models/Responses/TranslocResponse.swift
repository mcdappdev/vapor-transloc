//
//  TranslocResponse.swift
//  App
//
//  Created by Jimmy McDermott on 8/15/18.
//

import Foundation
import Vapor

struct TranslocResponse: Content {
    let data: [Data]
    
    struct Data: Content {
        let stop_id: String
        let arrivals: [Arrival]
    }
    
    struct Arrival: Content {
        let arrival_at: Date
    }
}
