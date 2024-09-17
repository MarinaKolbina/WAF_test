//
//  NetworkingProtocol.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 17/09/2024.
//

import Alamofire

protocol NetworkingProtocol {
    func request(_ convertible: URLConvertible, headers: HTTPHeaders, completion: @escaping (AFDataResponse<Data>) -> Void)
}
