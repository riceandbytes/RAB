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

public enum RabTableType {
    case keyValue
    case picWithInfoCell
    case singleCell
    case singlePic
    case titleWithPic
    case titleDetailPicCell
    case revCell
    case unknown
}

public typealias TableCallback = (_ dataRow: DataRow?) -> Void

open class RabTableView: UITableView {
    
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
                      supportedTypes: [RabTableType],
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
        }
        
        self.tableData = tableData
        pln("num of sections: \(tableData.count)")
        
        if self.tableData.count > 0 {
            hasResults = true
        }
        
        if supportedTypes.count <= 0 {
            pAssert(false, "supportedTypes not set")
        }
        
        self.delegate = self
        self.dataSource = self
        
        if let x = canDeleteCallback {
            deleteCallback = x
        }
        if let x = canSelectCallback {
            selectCallback = x
        }
        
        for tableType in supportedTypes {
            if tableType == .keyValue {
                let keyValueNib = UINib(nibName: KeyValueCell.dynamicClassName, bundle: Bundle(for: KeyValueCell.self))
                self.register(keyValueNib, forCellReuseIdentifier: KeyValueCell.dynamicClassName)
            } else if tableType == .singleCell {
                let nib = UINib(nibName: SingleCell.dynamicClassName, bundle: Bundle(for: SingleCell.self))
                self.register(nib, forCellReuseIdentifier: SingleCell.dynamicClassName)
            } else if tableType == .singlePic {
                let nib = UINib(nibName: SinglePicCell.dynamicClassName, bundle: Bundle(for: SinglePicCell.self))
                self.register(nib, forCellReuseIdentifier: SinglePicCell.dynamicClassName)
            } else if tableType == .titleWithPic {
                let nib = UINib(nibName: TitleWithPicCell.dynamicClassName, bundle: Bundle(for: TitleWithPicCell.self))
                self.register(nib, forCellReuseIdentifier: TitleWithPicCell.dynamicClassName)
            } else if tableType == .titleDetailPicCell {
                let nib = UINib(nibName: TitleDetailPicCell.dynamicClassName, bundle: Bundle(for: TitleDetailPicCell.self))
                self.register(nib, forCellReuseIdentifier: TitleDetailPicCell.dynamicClassName)
            } else if tableType == .picWithInfoCell {
                let nib = UINib(nibName: PicWithInfoCell.dynamicClassName, bundle: Bundle(for: PicWithInfoCell.self))
                self.register(nib, forCellReuseIdentifier: PicWithInfoCell.dynamicClassName)
            } else if tableType == .revCell {
                let nib = UINib(nibName: RevCell.dynamicClassName, bundle: Bundle(for: RevCell.self))
                self.register(nib, forCellReuseIdentifier: RevCell.dynamicClassName)
            } else {
                pAssert(false, "Unknown table type")
            }
            
        }
    }
    
    deinit {
        pln()
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
    
    //    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        let tt = self.tableType[indexPath.section]
    //        if tt == .SinglePic {
    //            return 275
    //        } else if tt == .TitleWithPic || tt == .TitleDetailPicCell {
    //            return 72
    //        } else if tt == .UpcomingCruiseCell {
    //            return 91
    //        } else if tt == .ReviewCell {
    //            return 260
    //        } else if tt == .HorzScrollPicsCell {
    //            return 118
    //        } else if tt == .PicWithInfoCell {
    //            let td = self.tableData[indexPath.section][indexPath.row]
    //            if let s = td.get("info") as? String {
    //
    //                // Should match settings for cell
    //                let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width-30, CGFloat.max))
    //                label.numberOfLines = 40
    //                label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    //                label.font = self.textFont
    //                label.text = s
    //                label.sizeToFit()
    //                pln(label.frame.height)
    //                return label.frame.height + 120
    //            } else {
    //                return 160
    //            }
    //        } else {
    //            return 44
    //        }
    //    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        //        pln("num sections count: \(self.tableData.count)")
        return self.tableData.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.tableData[section].count
        //        pln("count: \(count)")
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell? = nil
        let td = self.tableData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let tt = td.type
        
        if tt == .keyValue {
            cell = tableView.dequeueReusableCell(withIdentifier: KeyValueCell.dynamicClassName,
                                                               for: indexPath)
            if let c = cell as? KeyValueCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == .singleCell {
            cell = tableView.dequeueReusableCell(withIdentifier: SingleCell.dynamicClassName,
                                                               for: indexPath)
            if let c = cell as? SingleCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == .singlePic {
            cell = tableView.dequeueReusableCell(withIdentifier: SinglePicCell.dynamicClassName,
                                                               for: indexPath)
            if let c = cell as? SinglePicCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == .titleWithPic {
            cell = tableView.dequeueReusableCell(withIdentifier: TitleWithPicCell.dynamicClassName,
                                                               for: indexPath)
            if let c = cell as? TitleWithPicCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == .titleDetailPicCell {
            cell = tableView.dequeueReusableCell(withIdentifier: TitleDetailPicCell.dynamicClassName,
                                                               for: indexPath)
            if let c = cell as? TitleDetailPicCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == .picWithInfoCell {
            cell = tableView.dequeueReusableCell(withIdentifier: PicWithInfoCell.dynamicClassName,
                                                               for: indexPath)
            if let c = cell as? PicWithInfoCell {
                c.configure(td)
                self.updateCell(c)
                return c
            }
        } else if tt == .revCell {
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
        return cell!
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
        // This method will get your cell identifier based on your data
        //        let cellType = reuseIdentifierForIndexPath(indexPath)
        //
        //        if cellType == kFirstCellIdentifier
        //        return kFirstCellHeight
        //        else if cellType == kSecondCellIdentifier
        //        return kSecondCellHeight
        //        else if cellType == kThirdCellIdentifier
        //        return kThirdCellHeight
        //        else
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
        self.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    }
}
