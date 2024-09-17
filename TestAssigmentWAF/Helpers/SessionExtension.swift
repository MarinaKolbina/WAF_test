//
//  SessionExtension.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 17/09/2024.
//

import Alamofire

extension Session: NetworkingProtocol {
    func request(_ convertible: URLConvertible, headers: HTTPHeaders, completion: @escaping (AFDataResponse<Data>) -> Void) {
        request(convertible, headers: headers).responseData(completionHandler: completion)
    }
}
