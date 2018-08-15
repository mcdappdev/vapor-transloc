import Vapor

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // MARK: -  Register routes to the router
    services.register(Router.self) { _ -> EngineRouter in
        let router = EngineRouter.default()
        try routes(router)
        return router
    }

    // MARK: -  Register middleware
    services.register { _ -> MiddlewareConfig in
        var middlewares = MiddlewareConfig()
        try middleware(config: &middlewares)
        return middlewares
    }
    
    //MARK: - Transloc
    services.register { container -> TranslocService in
        guard let apiKey = Environment.get(Constants.translocApiEnvKey) else {
            throw Abort(.internalServerError)
        }
        
        return TranslocService(apiKey: apiKey, client: try container.make())
    }
   
    // MARK: -  Register KeyStorage
    services.register { container -> KeyStorage in
        guard let apiKey = Environment.get(Constants.restMiddlewareEnvKey) else {
            throw Abort(.internalServerError)
        }
        
        return KeyStorage(restMiddlewareApiKey: apiKey)
    }
}
