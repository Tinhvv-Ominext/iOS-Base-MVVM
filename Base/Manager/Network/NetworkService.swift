//
//  NetworkService.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/9/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import UIKit
import Moya
import RxSwift
import RxCocoa
import Alamofire
import ObjectMapper

protocol NetworkServiceProtocol: class {

    func connect(api: API, mappableClass: Mappable.Type) -> Observable<ResponseObject>
}

final class NetworkService: NetworkServiceProtocol {

    static let shared = NetworkService()
    static let needToShowLog: Bool = true

    lazy var groupQueue: DispatchGroup = {
        let group: DispatchGroup = DispatchGroup.init()
        return group
    }()

    private let reachabilityManager = NetworkReachabilityManager(host: userUrl?.host ?? "www.google.com")

    let networkStatus: BehaviorRelay<NetworkReachabilityManager.NetworkReachabilityStatus> = BehaviorRelay(value: .unknown)

    private init() {
        observeInternetConnection()
    }

    deinit {
        stopObserveInternetConnection()
    }

    static private func getNetworkManager() -> Alamofire.Session? {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 60.0
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }

    func connect(api: API, mappableClass: Mappable.Type) -> Observable<ResponseObject> {
        guard let networkManager = NetworkService.getNetworkManager() else {
            return Observable.error(APIError.notSecureConnection)
        }

        let subject = ReplaySubject<ResponseObject>.createUnbounded()
        let provider = MoyaProvider<API>(endpointClosure: api.endpointClosure, session: networkManager)
        Logger.log(.action, "===> Request: \(api.baseURL.absoluteString + api.path)")
        let request = provider.request(api) { event in
            switch event {
                case let .success(response):
                    do {
                        guard let jsonResponse = try response.mapJSON() as? [String: Any],
                            let code = jsonResponse["code"] as? Int else {
                                subject.onError(APIError.invalidJSONFormat)
                                return
                        }

                        Logger.log(.success, jsonResponse)

                        if code == 200 {
                            self.configureResponseSuccess(jsonResponse: jsonResponse, subject: subject, mappableClass: mappableClass)
                        } else {
                            self.configureFailed(jsonResponse: jsonResponse, subject: subject)
                        }
                    } catch {
                        Logger.log(.warning, "Invalid json format")
                        if response.statusCode == 401 {
                            self.handlerTokenExpired()
                        } else {
                            subject.onError(APIError.invalidJSONFormat)
                        }
                }
                case let .failure(error):
                    Logger.log(.error, error.localizedDescription)
                    self.configureResponseError(subject: subject, error: error)
            }
        }

        return subject.do(onDispose: {
            request.cancel()
        })
    }

    private func configureFailed(jsonResponse: [String: Any], subject: ReplaySubject<ResponseObject>) {
        guard let error = jsonResponse["code"] as? Int,
            let errorMessage = jsonResponse["message"] as? String
            else {
                return
        }
        subject.onError(APIError.connectionError(code: error, message: errorMessage))
    }

    private func configureResponseSuccess(jsonResponse: [String: Any],
                                          subject: ReplaySubject<ResponseObject>,
                                          mappableClass: Mappable.Type) {

        if let data = jsonResponse["data"] as? [String: Any] {
            let map = Map(mappingType: .fromJSON, JSON: data)
            guard let modelObject = mappableClass.init(map: map) else {
                subject.onError(APIError.invalidJSONFormat)
                return
            }
            let object = ResponseObject()
            object.data = modelObject
            subject.onNext(object)
            subject.onCompleted()
        } else if let list = jsonResponse["data"] as? [[String: Any]] {
            var results: [Mappable]?
            
            for data in list {
                let map = Map(mappingType: .fromJSON, JSON: data)
                guard let modelObject = mappableClass.init(map: map) else {
                    subject.onError(APIError.invalidJSONFormat)
                    return
                }
                results?.append(modelObject)
            }
            
            let object = ResponseObject()
            object.dataList = results
            subject.onNext(object)
            subject.onCompleted()
        } else {
            subject.onNext(ResponseObject(empty: Empty()))
            subject.onCompleted()
        }
    }

    private func handlerTokenExpired() {
        UIAlertController.showMessage("token_expired".localized) { (_) in
            Global.shared.logout()
        }
    }

    private func configureResponseError(subject: ReplaySubject<ResponseObject>, error: Error) {

        let errorCode = (error as NSError).code

        // Token has expired
        if errorCode == 401 {
            handlerTokenExpired()
            return
        }

        guard let moyaError = error as? MoyaError else {
            subject.onError(APIError.connectionError(code: errorCode, message: nil))
            return
        }

        switch moyaError {
            case .underlying(let cfNetworkError, _):
                let code = (cfNetworkError as NSError).code
                if code == CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue, !isConnectedToInternet {
                    subject.onError(APIError.noInternetConnection)
                } else {
                    subject.onError(APIError.connectionError(code: code, message: nil))
            }

            case .statusCode(let response):
                subject.onError(APIError.connectionError(code: response.statusCode, message: nil))

            default:
                subject.onError(APIError.connectionError(code: (error as NSError).code, message: nil))

        }
    }

    var isConnectedToInternet: Bool {
        guard let isReachable = reachabilityManager?.isReachable else {
            return false
        }

        return isReachable
    }

    var isConnectedToEthernetOrWifi: Bool {
        return (reachabilityManager?.isReachableOnEthernetOrWiFi ?? false)
    }

    func showAlertWhenNoInternet() -> Bool {
        return false
    }

    private func observeInternetConnection() {
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] (status) in
            self?.networkStatus.accept(status)
        })
    }

    private func stopObserveInternetConnection() {
        reachabilityManager?.stopListening()
    }
}
