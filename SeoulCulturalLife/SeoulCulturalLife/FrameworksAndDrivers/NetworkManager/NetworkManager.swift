//
//  NetworkManager.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

import Foundation

final class NetworkManager {
    
    private let fetcher: DataFetcher = DataFetcher()
    private let dataAdapter: JSONDataAdapter
    private var currentIndex: Int = 1
    
    init(dataAdapter: JSONDataAdapter) {
        self.dataAdapter = dataAdapter
    }
    
    func loadNewData(_ category: Category?) async {
        currentIndex = 1
        await fetchData(category, isNewData: true)
    }
    
    func loadMoreData(_ category: Category?) async {
        currentIndex += 100
        await fetchData(category, isNewData: false)
    }
    
    private func fetchData(_ category: Category?, isNewData: Bool) async {
        let provider = EventAPIProvider(category: category?.rawValue,
                                        startIndex: currentIndex)
        do {
            let data = try await fetcher.fetchData(url: provider.url)
            
            if isNewData {
                dataAdapter.setDatas(data)
            } else {
                dataAdapter.addDatas(data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchData(from url: URL?) async -> Data? {
        return try? await fetcher.fetchData(url: url)
    }
}
