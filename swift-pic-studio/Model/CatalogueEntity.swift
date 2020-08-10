//
//  CatalogueEntity.swift
//  swift-pic-studio
//
//  Created by boss on 2020/7/30.
//  Copyright © 2020 cnnl. All rights reserved.
//

import Cocoa

class CatalogueEntity: NSObject {
    
    weak var perent: CatalogueEntity?
    
    // 层级
    var level: Int = 0
    
    // 层级中的序号
    var indexInLevel: Int = 0

    // 内部名称
    var name: String
    
    // 标题
    var title: String
    
    // 图标
    var icon: String?
    
    // 图片数量
    var numbers: Int = 0
    
    // 是否虚拟的
    var isVirtual = false
    
    // 是否展开
    var isExpanding = false
    
    // 是否标题
    var isTitled = false
    
    // 是否智能文件夹
    var isSmart = false
    
    var indentifier: String {
        get {
            String(format: "%d-%d", level, indexInLevel)
        }
    }
    
    var _children: [CatalogueEntity] = []
    var children: [CatalogueEntity] {
        get {
            return _children
        }
    }
    
    static var _indentifier2entity = Dictionary<String, CatalogueEntity>()
    
    static func entity(from indentifier: String) -> CatalogueEntity? {
        return _indentifier2entity[indentifier]
    }
    
    init(name: String, title: String) {
        self.name = name
        self.title = title
        super.init()
    }
    
    func insert(_ child:CatalogueEntity, at i: Int) {
        child.perent = self
        child.level = self.level + 1
        child.indexInLevel = _children.count
        _children.insert(child, at: i)
        CatalogueEntity._indentifier2entity[indentifier] = child
    }
    
    func remove(_ child:CatalogueEntity) -> Bool {
        CatalogueEntity._indentifier2entity[child.indentifier] = nil
        guard let index = _children.firstIndex(of: child) else {
            return false
        }
        
        _children.remove(at: index)
        return true
    }
    
    static func BuildBySummary() -> [CatalogueEntity] {
        let forAll = CatalogueEntity(name: "all", title: "全部")
        let forUncatalog = CatalogueEntity(name: "uncatalog", title: "未分类")
        let forUntaged = CatalogueEntity(name: "untaged", title: "未标签")
        let forRandom = CatalogueEntity(name: "random", title: "惊喜组合")
        let forTags = CatalogueEntity(name: "tags", title: "标签管理")
        
        forAll.isVirtual = true
        forUncatalog.isVirtual = true
        forUntaged.isVirtual = true
        forRandom.isVirtual = true
        forTags.isVirtual = true
        
        let forSmart = CatalogueEntity(name: "smart", title: "智能文件夹")
        forSmart.isVirtual = true
        forSmart.isTitled = true
        
        let forFolders = CatalogueEntity(name: "folders", title: "文件夹")
        forFolders.isVirtual = false
        forFolders.isTitled = true
        
        return [forAll, forUncatalog, forUntaged, forRandom, forTags, forSmart, forFolders]
    }
}
