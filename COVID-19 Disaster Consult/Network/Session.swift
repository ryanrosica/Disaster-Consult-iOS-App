//
//  Session.swift
//  COVID-19 Disaster Consult
//
//  Created by Aaron Kovacs on 4/9/20.
//  Copyright © 2020 Disaster Consult. All rights reserved.
//

import Foundation

class Session: NSObject {
    
    static let shared: Session = Session()
    
//    static let baseURL: String = "http://covid19disasterconsult-env.eba-3a2xstkc.us-east-2.elasticbeanstalk.com"
    static let baseURL: String = "http://www.disasterconsult.org"
    
    var site: Site? = nil
    var slug: String {
        get {
            return self.site?.slug ?? ""
        }
    }
    
}

extension Session {

    static func makeUrlRequest(endpoint: String, parameters: [String: String]? = nil, body: Data? = nil, method: HTTPMethod, pretend: Bool = true) -> URLRequest? {
                
        var parameterStr: String = ""
        
        if let para: [String: String] = parameters {
            for key in Array(para.keys) {
                if parameterStr != "" {
                    parameterStr += "&"
                }
                
                parameterStr += "\(key)=\(para[key]?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
            }
        }
        
        if parameterStr != "" {
            parameterStr = "?\(parameterStr)"
        }

        guard let url: URL = URL.init(string: Session.baseURL + endpoint + parameterStr) else { return nil }
        print(url.absoluteString)
        var rq = URLRequest(url: url)
        rq.timeoutInterval = 30
        rq.httpMethod = method.value()
        rq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        rq.addValue("application/json", forHTTPHeaderField: "Accept")
        rq.cachePolicy = .reloadIgnoringLocalCacheData

        rq.httpBody = body
            
        return rq
    }
    
    func json(_ parameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters, options: [])
    }

}
