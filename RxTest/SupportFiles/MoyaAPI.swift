//
//  MoyaAPI.swift
//  RxTest
//
//  Created by Vitaliy Kozlov on 10/03/2019.
//  Copyright © 2019 Vitaliy Kozlov. All rights reserved.
//

import Foundation
import Moya

enum ServerApi {
    case topRated (apiKey: String, page : Int)
}

extension ServerApi : TargetType {
    var baseURL: URL {
        return URL (string: "https://api.themoviedb.org/3/")!
    }
    
    var path: String {
        switch self {
        case .topRated:
            return "movie/top_rated"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data ()
    }
    
    
    var task: Task {
        switch self {
        case .topRated (let apiKey, let page):
            return .requestParameters(
                parameters: [
                    "api_key" : apiKey,
                    "page" : page
                ],
                encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
