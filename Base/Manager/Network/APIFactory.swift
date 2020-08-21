//
//  APIFactory.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/9/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import Moya

let userUrl = URL(string: "https://knafeh-authentication.azurewebsites.net/")

enum HeaderType {
    case none
    case token
}

enum API {
    case login(String, String) // email + pass
}

extension API {
    static let paginationSize = 10
}

typealias EndpointClosure = (API) -> Endpoint

extension API {
    var endpointClosure: EndpointClosure {
        return { (target: API) -> Endpoint in
            return MoyaProvider<API>.defaultEndpointMapping(for: target).adding(newHTTPHeaderFields: (self.headers ?? [String: String]()))
        }
    }

    static func httpHeaders(_ type: HeaderType = .token) -> [String: String] {

        if type == .none {
            return ["Content-Type": "application/json"]
        }

        let token = Global.shared.token ?? ""

        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
}

extension API: TargetType {

    var headers: [String : String]? {
        switch self {
            case .login:
                return API.httpHeaders(.none)
            default:
            return API.httpHeaders()
        }
    }

    var baseURL: URL {
        return userUrl!
    }

    var path: String {
        switch self {
            case .login:
                return "v1/authentication/jwt/login"
        default:
            return ""
            
        }
    }

    var method: Moya.Method {
        switch self {
        case .login:
                return .post
            default:
                return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
            case .login(let email, let password):
                return .requestParameters(parameters: ["username": email,
                                                       "password": password], encoding: JSONEncoding.default)
            default:
                return .requestPlain
        }
    }
}
