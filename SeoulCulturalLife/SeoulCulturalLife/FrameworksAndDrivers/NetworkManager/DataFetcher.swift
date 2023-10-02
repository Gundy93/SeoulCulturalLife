//
//  DataFetcher.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

import Foundation

struct DataFetcher {
    
    func fetchData(url: URL?) async throws -> Data {
        guard let url else { throw NetworkingError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkingError.responseError }
        
        return data
    }
}
