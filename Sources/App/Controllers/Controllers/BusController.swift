import Vapor
import Foundation

final class BusController: RouteCollection {
    func boot(router: Router) throws {
        router.grouped(APIKeyMiddleware()).group("/api/v1") { builder in
            builder.get("next-arrival", String.parameter, use: getBusData)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        df.timeZone = TimeZone(abbreviation: "EST")
        return df
    }
    
    func getBusData(req: Request) throws -> Future<DataResponse> {
        let transloc = try req.make(TranslocService.self)
        let stopId = try req.parameters.next(String.self)
        
        return try transloc.time(for: stopId).map { translocData in
            guard let nextArrival = translocData.data.data.first?.arrivals.first?.arrival_at else {
                return DataResponse(fullDate: nil, time: nil, sentence: "No date available")
            }
            
            let sentenceModifier: String
            if let name = translocData.name {
                sentenceModifier = "for \(name)"
            } else {
                sentenceModifier = ""
            }
            
            let time = self.dateFormatter.string(from: nextArrival)
            let sentence = "The next bus \(sentenceModifier) arrives at \(time)"
            
            return DataResponse(fullDate: nextArrival, time: time, sentence: sentence)
        }.catchMap { _ in
            return DataResponse(fullDate: nil, time: nil, sentence: "Could not get Transloc data")
        }
    }
}
