import Vapor
import HTTP

struct TranslocService: Service {
    private let apiKey: String
    private let client: Client
    
    init(apiKey: String, client: Client) {
        self.apiKey = apiKey
        self.client = client
    }
    
    /// Fetches the next arrival estimate for the given stop
    ///
    /// - Parameter stop: The desired `stop_id`
    /// - Parameter route: The desired `route_id`
    /// - Returns: `TranslocData` which also contains the `name` of the stop, if available
    /// - Throws: Decoding errors
    func time(for stop: String, agency: String = "32", route: String) throws -> Future<TranslocData> {
        
        ///Add another pararmeter here--
        let url = baseUrl(for: .estimates, agency: agency) + "&stops=" + stop + "&routes=" + route
        
        print(url)

        let nameFuture = try name(for: stop)
        let estimateFuture = client.get(url, headers: headers())
        
        return flatMap(to: (TranslocResponse, String?).self, nameFuture, estimateFuture) { name, response in
            return try response.content.decode(TranslocResponse.self).and(result: name)
        }.map { content, name in
            return TranslocData(name: name, data: content)
        }
    }
    
    private func name(for stop: String, agency: String = "32") throws -> Future<String?> {
        let url = baseUrl(for: .stops, agency: agency)
        
        return client.get(url, headers: headers()).flatMap { response in
            return try response.content.decode(TranslocStopResponse.self)
        }.map { content in
            return content.data.filter { $0.stop_id == stop }.first?.name
        }
    }
    
    private func headers() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "X-Mashape-Key": apiKey,
            "Accept": "application/json"
        ]
        
        return headers
    }
    
    
    //This is where the url is made going to modfiy functions above and then its incorperated into url call
    private func baseUrl(for endpoint: Endpoint, agency: String) -> String {
        return "https://transloc-api-1-2.p.mashape.com/\(endpoint.rawValue).json?agencies=\(agency)&callback=call"
    }
    
    private enum Endpoint: String {
        case estimates = "arrival-estimates"
        case stops
    }
}
