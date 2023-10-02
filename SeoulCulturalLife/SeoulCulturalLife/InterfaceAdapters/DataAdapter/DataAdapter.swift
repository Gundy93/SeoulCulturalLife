//
//  DataAdapter.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

protocol DataAdapter {
    
    associatedtype DataType
    
    var useCase: UseCase { get }
    
    func convertToDomain(_ data: DataType) -> [Event]
    func setDatas(_ datas: DataType)
    func addDatas(_ datas: DataType)
}

extension DataAdapter {
    
    func setDatas(_ datas: DataType) {
        let domainDatas = convertToDomain(datas)
        
        useCase.setContainer(domainDatas)
    }
    
    func addDatas(_ datas: DataType) {
        
        let domainDatas = convertToDomain(datas)
        
        useCase.appendEvents(domainDatas)
    }
}
