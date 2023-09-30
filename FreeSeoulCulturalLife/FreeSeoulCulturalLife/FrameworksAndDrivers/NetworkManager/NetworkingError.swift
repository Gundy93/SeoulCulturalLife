//
//  NetworkingError.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//


import Foundation

enum NetworkingError: LocalizedError {
    
    case invalidURL
    case responseError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .responseError:
            return "서버 응답이 없습니다."
        }
    }
}
