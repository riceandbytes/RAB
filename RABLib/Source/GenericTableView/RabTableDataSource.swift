//
//  DropDownData.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

public enum RabTableKey: String {
    case subTitle
    case someId
    case Unknown
}

open class RabTableDataSource {
    var tableTitle: String?
    
    var items: [DataRow] = []
    var count: Int {
        return items.count
    }
    
    public init(title: String?) {
        self.tableTitle = title
    }
    
    open func addSingleCell(_ title: String, subTitle: String) {
        self.add(DataRow(title: title,
            type: .singleCell,
            custom: [RabTableKey.subTitle.rawValue: subTitle]))
    }
    
    open func addKeyValue(_ key: String, value: String) {
        let custom = [KeyValueCell.kValue: value]
        self.add(DataRow(title: key, type: .keyValue, custom: custom))
    }
    
    open func addSinglePic(_ url: String, useReferer: String? = nil,
                             useForceRefresh: Bool = false, showIndicatorWhenLoading: Bool = false, noSideBorder: Bool = false) {
        
        if let referer = useReferer {
            self.add(.singlePic, custom: ["url": url, "referer": referer, "useForceRefresh": useForceRefresh,
                "showIndicatorWhenLoading": showIndicatorWhenLoading, "noSideBorder": noSideBorder])
        } else {
            self.add(.singlePic, custom: ["url": url, "useForceRefresh": useForceRefresh,
                "showIndicatorWhenLoading": showIndicatorWhenLoading, "noSideBorder": noSideBorder])
        }
    }
        
    open func addTitleDetailPicCell(_ title: String, url: String, slug: String = ""
        , detail: String = "") {
        self.add(DataRow(title: title,
            type: .titleDetailPicCell,
            custom: ["url": url, "slug": slug,
                "detail": detail]))
    }
    
    open func addPicWithInfoCell(_ userInfo: String, url: String, info: String) {
        self.add(DataRow(title: "",
            type: .picWithInfoCell,
            custom: ["url": url, "userInfo": userInfo,
                "info": info]))
    }
    
    open func add(_ type: RabTableType, custom: [String: Any]) {
        self.add(DataRow(title: "", type: type, custom: custom))
    }
    
    open func add(_ any: DataRow) {
        items.append(any)
    }
    
    open subscript (index: Int) -> DataRow {
        return items[index]
    }
    
    open func objectAtIndex(_ index: Int) -> DataRow {
        return items[index]
    }
    
    open func remove(_ index: Int) {
        items.remove(at: index)
    }
    
    open func removeLastItem() {
        items.removeLast()
    }
    
    open func clearAllData() {
        items.removeAll()
    }
}

// MARK: - Use ID Handling

extension RabTableDataSource {
    /**
     *  Row must use RabTableKey.someId for this to work
     *
     *  @param Int id of item
     *
     */
    public func removeItemById(_ id: Int) {
        for (index, dataRow) in self.items.enumerated() {
            if let someId = dataRow[RabTableKey.someId.rawValue] as? Int {
                if someId == id {
                    self.remove(index)
                }
            }
        }
    }
    
    public func findById(_ id: Int) -> DataRow? {
        for dataRow in self.items {
            if let someId = dataRow[RabTableKey.someId.rawValue] as? Int {
                if someId == id {
                    return dataRow
                }
            }
        }
        return nil
    }
}

open class DataRow: AnyObject {
    
    open var title = ""
    open var type: RabTableType = .unknown
    fileprivate var custom: [String: Any] = [:]
    open var editStyle: UITableViewCellEditingStyle = .none
    open var block1: DataRowBlock? = nil
    open var block2: DataRowBlock? = nil
    open var block3: DataRowBlock? = nil
    open var block4: DataRowBlock? = nil
    open var userProfileBlock: DataRowBlock? = nil
    
    /**
     Add a single block1
     */
    public convenience init(title: String,
                            type: RabTableType,
                            custom: [String: Any]? = nil,
                            block1: @escaping DataRowBlock)
    {
        self.init(title: title, type: type, custom: custom)
        self.block1 = block1
    }
    
    public convenience init(title: String,
                            type: RabTableType,
                            custom: [String: Any]? = nil,
                            block1: @escaping DataRowBlock,
                            block2: @escaping DataRowBlock,
                            chatBlock: @escaping DataRowBlock,
                            trashBlock: @escaping DataRowBlock,
                            userProfileBlock: @escaping DataRowBlock)
    {
        self.init(title: title, type: type, custom: custom)
        self.block1 = block1
        self.block2 = block2
        self.block3 = chatBlock
        self.block4 = trashBlock
        self.userProfileBlock = userProfileBlock
    }
    
    public convenience init(title: String,
                            type: RabTableType,
                            custom: [String: Any]? = nil,
                            block1: @escaping DataRowBlock,
                            block2: @escaping DataRowBlock,
                            block3: @escaping DataRowBlock,
                            block4: @escaping DataRowBlock,
                            userProfileBlock: @escaping DataRowBlock)
    {
        self.init(title: title, type: type, custom: custom)
        self.block1 = block1
        self.block2 = block2
        self.block3 = block3
        self.block4 = block4
        self.userProfileBlock = userProfileBlock
    }
    
    public init(title: String,
                type: RabTableType,
                custom: [String: Any]? = nil,
                editStyle: UITableViewCellEditingStyle = .none)
    {
        self.title = title
        self.editStyle = editStyle
        self.type = type
        
        if let c = custom {
            self.custom = c
        }
    }
    
    public init(title: String,
                type: RabTableType,
                editStyle: UITableViewCellEditingStyle = .none)
    {
        self.title = title
        self.editStyle = editStyle
        self.type = type
    }
    
    open func add(_ key: String, value: Any) {
        custom[key] = value
    }
    
    open func get(_ key: String) -> Any? {
        return custom[key]
    }
    
    open subscript (key: String) -> Any? {
        get {
            return custom[key]
        }
        set(newValue) {
            custom[key] = newValue
        }
    }
}
