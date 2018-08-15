//
//  DataResponse.swift
//  App
//
//  Created by Jimmy McDermott on 8/15/18.
//

import Foundation
import Vapor

struct DataResponse: Content {
    let fullDate: Date?
    let time: String?
    let sentence: String
}
