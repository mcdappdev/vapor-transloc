//
//  middleware.swift
//  App
//
//  Created by Jimmy McDermott on 8/8/18.
//

import Foundation
import Vapor

public func middleware(config: inout MiddlewareConfig) throws {
    config.use(FileMiddleware.self)
    config.use(ErrorMiddleware.self)
    config.use(SessionsMiddleware.self)
}
