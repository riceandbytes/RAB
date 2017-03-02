//
//  RabTableView.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

public typealias DataRowBlock = (_ comment: String, _ info: AnyObject?) -> Void

public protocol DidSelectCell {
    func didSelectCell()
}

@objc public protocol RabTableDelegate: class {
    @objc optional func didScrollToBottom()
}

//public enum RabTableType {
//    case keyValue
//    case picWithInfoCell
//    case RabSingleCell
//    case singlePic
//    case titleWithPic
//    case titleDetailPicCell
//    case revCell
//    case unknown
//}

public typealias TableCallback = (_ dataRow: DataRow?) -> Void

public class RabTableView: UITableView {
    
    static let HeightDetailControllerTablerHeader: CGFloat = 105
    
    open weak var delegateGenericTable: RabTableDelegate?
    
    fileprivate var deleteCallback: TableCallback?         = nil
    fileprivate var selectCallback: TableCallback?         = nil
    fileprivate var hasResults: Bool                       = false
    fileprivate var headerTitle: String?                   = nil
    fileprivate var headerImage: String?                   = nil
    fileprivate var footerReadMore: String?                = nil
    fileprivate var footerAddButtonText: String?           = nil
    fileprivate var footerBlock1: DataRowBlock?            = nil
    fileprivate var footerBlock2: DataRowBlock?            = nil
    fileprivate var textFont: UIFont?                      = nil
    // bottom refresh control
    fileprivate var bottomRefreshView: BottomIndicatorView? = nil
    // this is the selection color of the cell when you select it
    //
    fileprivate var selectionColor: UIColor?               = nil
    open var headerBackgroundColor: UIColor?        = nil
    // check if table is already setup
    open var isSetupCalledAlready: Bool = false
    
    open var tableData: [RabTableDataSource]!
    
    // Text for the add cell
    open var addTitle: String? = nil
    
    // height of the separators
    open var separatorHeight: CGFloat = 40
    fileprivate let sectionHeight: CGFloat = 40
    
    // scrollview helpers
    fileprivate var checkDidMove_y: CGFloat = 0
    
    /**
     Setup table data
     
     - parameter tableData:
     Example of TableData with Sections:
     tableData1 = TableDataSource(title: "TITLE1", tableType: .TitleWithPic)
     tableData2 = TableDataSource(title: "TITLE2", tableType: .TitleWithPic)
     ex: pass this [self.tableData1, self.tableData2]
     
     - parameter hideSeparator:     table separators
     - parameter textFont:          font for title
     - parameter selectionColor:    color when you select the row
     - parameter needPullUpToLoadMore: if TRUE then add a refresh ability
     when you pull up from the bottom of the screen
     - parameter canDeleteCallback: when a user deletes the row
     - parameter canSelectCallback: when user selects the row
     */
    open func setup(_ tableData: [RabTableDataSource],
                      hideSeparator: Bool               = true,
                      textFont: UIFont?                 = nil,
                      selectionColor: UIColor?          = UIColor(hex: "#6AA2D7", alpha: 10),
                      headerBackgroundColor: UIColor?   = nil,
                      needPullUpToLoadMore: Bool        = false,
                      footerRollcallTitle: String?      = nil,
                      footerRollcallBlock: DataRowBlock? = nil,
                      canDeleteCallback: TableCallback? = nil,
                      canSelectCallback: TableCallback? = nil)
    {
        self.isSetupCalledAlready = true
        
        // setup bottom pull up refresh
        if needPullUpToLoadMore {
            initScrollToBottomRefreshControl()
        }
        
        /// This is used for automatic calculation of height
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 44.0
        
        if let color = headerBackgroundColor {
            self.headerBackgroundColor = color
        }
        
        if let tf = textFont {
            self.textFont = tf
        }
        
        if let sc = selectionColor {
            self.selectionColor = sc
        }
        
        if hideSeparator {
            self.separatorColor = UIColor.clear
        } else {
            self.separatorColor = UIColor.groupTableViewBackground
        }
        
        self.tableData = tableData
        pln("num of sections: \(tableData.count)")
        
        if self.tableData.count > 0 {
            hasResults = true
        }
        
        self.delegate = self
        self.dataSource = self
        
        if let x = canDeleteCallback {
            deleteCallback = x
        }
        if let x = canSelectCallback {
            selectCallback = x
        }
        
        var supportedTypes: Set<String> = []
        for x in tableData {
            for d in x.items {
                supportedTypes.insert(d.type)
            }
        }
        pln(supportedTypes)
        self.registerCells(Array(supportedTypes))
    }
    
    deinit {
        pln()
    }
}

// MARK: - Subclassing

extension RabTableView {
    
    func registerCells(_ supportedTypes: [String]) {
        for tableType in supportedTypes {
            if tableType == KeyValueCell.type() {
                let keyValueNib = UINib(nibName: KeyValueCell.dynamicClassName, bundle: Bundle(for: KeyValueCell.self))
                self.register(keyValueNib, forCellReuseIdentifier: KeyValueCell.dynamicClassName)
            } else if tableType == RabSingleCell.type() {
                let nib = UINib(nibName: RabSingleCell.dynamicClassName, bundle: Bundle(for: RabSingleCell.self))
                self.register(nib, forCellReuseIdentifier: RabSingleCell.dynamicClassName)
            } else if tableType == SinglePicCell.type() {
                let nib = UINib(nibName: SinglePicCell.dynamicClassName, bundle: Bundle(for: SinglePicCell.self))
                self.register(nib, forCellReuseIdentifier: SinglePicCell.dynamicClassName)
            } else if tableType == TitleWithPicCell.type() {
                let nib = UINib(nibName: TitleWithPicCell.dynamicClassName, bundle: Bundle(for: TitleWithPicCell.self))
                self.register(nib, forCellReuseIdentifier: TitleWithPicCell.dynamicClassName)
            } else if tableType == TitleDetailPicCell.type() {
                let nib = UINib(nibName: TitleDetailPicCell.dynamicClassName, bundle: Bundle(for: TitleDetailPicCell.self))
                self.register(nib, forCellReuseIdentifier: TitleDetailPicCell.dynamicClassName)
            } else if tableType == PicWithInfoCell.type() {
                let nib = UINib(nibName: PicWithInfoCell.dynamicClassName, bundle: Bundle(for: PicWithInfoCell.self))
                self.register(nib, forCellReuseIdentifier: PicWithInfoCell.dynamicClassName)
            } else if tableType == RevCell.type() {
                let nib = UINib(nibName: RevCell.dynamicClassName, bundle: Bundle(for: RevCell.self))
                self.register(nib, forCellReuseIdentifier: RevCell.dynamicClassName)
            } else {
                pAssert(false, "Unknown table type")
            }
        }
    }
    
    func dequeueCell(_ tt: String, td: DataRow, indexPath: IndexPath, tableView: UITableView) -> UITableViewCell? {
        var cell: UITableViewCell? = nil

        if tt == KeyValueCell.type() {
            cell = tableView.dequeueReusableCell(withIdentifier: KeyValueCell.dynamicClassName,
                                                 for: indexPath)
            if let c = cell as? KeyValueCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == RabSingleCell.type() {
            cell = tableView.dequeueReusableCell(withIdentifier: RabSingleCell.dynamicClassName,
                                                 for: indexPath)
            if let c = cell as? RabSingleCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == SinglePicCell.type() {
            cell = tableView.dequeueReusableCell(withIdentifier: SinglePicCell.dynamicClassName,
                                                 for: indexPath)
            if let c = cell as? SinglePicCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == TitleWithPicCell.type() {
            cell = tableView.dequeueReusableCell(withIdentifier: TitleWithPicCell.dynamicClassName,
                                                 for: indexPath)
            if let c = cell as? TitleWithPicCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == TitleDetailPicCell.type() {
            cell = tableView.dequeueReusableCell(withIdentifier: TitleDetailPicCell.dynamicClassName,
                                                 for: indexPath)
            if let c = cell as? TitleDetailPicCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == PicWithInfoCell.type() {
            cell = tableView.dequeueReusableCell(withIdentifier: PicWithInfoCell.dynamicClassName,
                                                 for: indexPath)
            if let c = cell as? PicWithInfoCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == RevCell.type() {
            cell = tableView.dequeueReusableCell(withIdentifier: RevCell.dynamicClassName,
                                                 for: indexPath)
            if let c = cell as? RevCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else {
            pAssert(false, "Not supported type")
        }
        
        return cell
    }
}

// MARK: - Helper

extension RabTableView {
    
    /**
     Returns a cell at this row and section
     */
    func getCellAt(_ row: Int, section: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: section)
        return self.cellForRow(at: indexPath)
    }
    
    func updateCell_IgnoreSection(_ row: Int, style: UITableViewRowAnimation = .automatic){
        let indexPath = IndexPath(row: row, section: 0)
        
        doOnMain {
            self.beginUpdates()
            self.reloadRows(at: [indexPath], with: style)
            self.endUpdates()
            
            self.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: false)
            
        }
    }
    
    
    //    func removeCellById(someId: Int, section: Int = 0) {
    //        if let td = self.tableData[safe: section] {
    //            doOnMain {
    //                self.beginUpdates()
    //                td.removeItemById(someId)
    //                self.endUpdates()
    //            }
    //        }
    //    }
    
    
    /**
     Removes cell by index
     
     - parameter row:   Row Index
     - parameter style: Style
     */
    func removeCellFromTableAtRow(_ row: Int, style: UITableViewRowAnimation = .automatic) {
        let indexPath = IndexPath(row: row, section: 0)
        
        doOnMain {
            self.beginUpdates()
            self.deleteRows(at: [indexPath], with: style)
            self.endUpdates()
        }
    }
    
    /**
     Use this to insert a table row with out needing to call reload entire table
     *Must add new data into tabledata source before calling this.
     
     - parameter indexPaths: array of indexpaths
     */
    func insertRowUsingUpdatedTableData() {
        
        var indexesPath = [IndexPath]()
        for (i, _) in tableData.enumerated() {
            let index = IndexPath(row: i, section: 0)
            indexesPath.append(index)
        }
        
        //        self.beginUpdates()
        self.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
        //        self.endUpdates()
        
    }
}

// MARK: - Delegate

extension RabTableView: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableData.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let td = self.tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let tt = td.type ?? ""
        return self.dequeueCell(tt, td: td, indexPath: indexPath, tableView: tableView)!
    }
    
    fileprivate func updateCell(_ cell: UITableViewCell) {
        if let sc = self.selectionColor {
            cell.selectionStyle = .default
            let bgColorView = UIView()
            bgColorView.backgroundColor = sc
            cell.selectedBackgroundView = bgColorView
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // used to clear the selection color of the cell, once a user has
        // selected it, if this was not here you will see the gray selection
        // color when you go back to the tableView
        //
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cb = selectCallback {
            let td = self.tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            cb(td)
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let td = self.tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            let item = td
            if let delete = deleteCallback {
                delete(item)
            }
            self.tableData[(indexPath as NSIndexPath).section].remove((indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        pln()
        return self.tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].editStyle
    }
    
    //TODO: implement this to improve smooth scrolling
    // http://stackoverflow.com/questions/27996438/jerky-scrolling-after-updating-uitableviewcell-in-place-with-uitableviewautomati
    //
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // MARK: Headers & Footer
    
//    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let sectionTitle = self.tableData[section].tableTitle {
//            let nib = UINib(nibName: "SectionHeaderCell", bundle: NSBundle.mainBundle())
//            let view = nib.instantiateWithOwner(self, options: nil)[0] as! SectionHeaderCell
//            view.configure(sectionTitle)
//            
//            if let bkgColor = self.headerBackgroundColor {
//                view.backgroundColor = bkgColor
//            }
//            
//            return view
////        } else if headerTitle != nil && headerImage != nil {
////            guard let title = headerTitle, let img = headerImage else {
////                return nil
////            }
////            let nib = UINib(nibName: "HeaderView", bundle: NSBundle.mainBundle())
////            let view = nib.instantiateWithOwner(self, options: nil)[0] as! HeaderView
////            view.configure(title, image: img)
////            return view
//        } else {
//            return nil
//        }
//    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableData[section].tableTitle != nil && self.tableData[section].tableTitle?.isEmpty == false {
            return sectionHeight
        } else if headerTitle != nil && headerImage != nil {
            return RabTableView.HeightDetailControllerTablerHeader
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if footerReadMore != nil {
            return 84
        } else {
            return 0
        }
    }
    
    // Using custom headers so we dont need this any more
    
    //    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //        if let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
    //            header.textLabel?.textColor = UIColor(hex: "#949EAE")
    //            header.textLabel?.font = self.headerFont
    //            header.textLabel?.frame = header.frame
    //            header.textLabel?.textAlignment = .Left
    //        }
    //    }
    
    //    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return self.tableData[section].tableTitle
    //    }
}


// MARK: - Scroll To Bottom

extension RabTableView {
    
    /**
     Check to see if all the rows of the table are visible on the screen
     */
    fileprivate func isEntireTableVisible() -> Bool {
        if let indices = self.indexPathsForVisibleRows {
            // check last row of last section
            let lastSection = tableData.count - 1
            let numRows = tableData[lastSection].count
            if numRows <= indices.count {
                return true
            }
        }
        return false
    }
    fileprivate func initScrollToBottomRefreshControl() {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 60)
        bottomRefreshView = BottomIndicatorView(frame: frame)
        bottomRefreshView?.isHidden = true
        self.tableFooterView = bottomRefreshView
        bottomRefreshView?.showInfoLabel(false)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        
        let reload_distance: CGFloat = 15 // 50
        if y > (h + reload_distance) && !isEntireTableVisible() {
            pln("loading more rows")
            delegateGenericTable?.didScrollToBottom?()
        }
    }
}

// MARK: - Helper Bottom Refresh

extension RabTableView {
    
    public func startAnimatingBottomRefresh() {
        pln()
        bottomRefreshView?.isHidden = false
        bottomRefreshView?.startAnimating()
    }
    
    public func stopAnimatingBottomRefresh() {
        pln()
        bottomRefreshView?.isHidden = true
        bottomRefreshView?.stopAnimating()
    }
    
    public func isBottomRefreshLoading() -> Bool {
        return bottomRefreshView?.indicatorFooter?.isAnimating ?? false
    }
}

// MARK: - Fixes

extension RabTableView {
    
    // http://stackoverflow.com/questions/18880341/why-is-there-extra-padding-at-the-top-of-my-uitableview-with-style-uitableviewst
    public func addFixToRemoveGapAboveTableView() {
        let inset = self.contentInset
        self.contentInset = UIEdgeInsetsMake(inset.top - 36.0, inset.left, inset.bottom, inset.right)
    }
}
