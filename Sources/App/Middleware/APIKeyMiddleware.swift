//
//  APIKeyMiddleware.swift
//  App
//
//  Created by Jimmy McDermott on 8/15/18.
//

import Foundation
import Vapor

final class APIKeyMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        let expectedKey = try request.make(KeyStorage.self).restMiddlewareApiKey
        let unauthorizedError = Abort(.unauthorized, reason: "Please provide the correct API Key")
        
        guard let receivedApiKey = request.http.headers.firstValue(name: HTTPHeaderName("X-API-KEY")) else {
            throw unauthorizedError
        }
        
        guard receivedApiKey == expectedKey else {
            throw unauthorizedError
        }
        
        return try next.respond(to: request)
    }
}
