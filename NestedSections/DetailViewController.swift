//
//  DetailViewController.swift
//  NestedSections
//
//  Created by arindam_ghosh on 12/10/16.
//  Copyright © 2016 arindam_ghosh. All rights reserved.
//

import UIKit
import ObjectMapper

class DetailViewController: UIViewController,UITableViewDelegate {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    //let sections = [[["p", "q"], ["r", "s"]], [["a", "b"], ["c", "d"]]]
    //let sectionHeaders = [["Section A1", "Section A2"], ["Section B1", "Section B2"]]
    var sections = [[["p", "q"], ["r", "s"]], [["a", "b"], ["c", "d"]]]
    var sectionHeaders = [["Section A1", "Section A2"], ["Section B1", "Section B2"]]
    var historyObj: HistoryModel?
    var historyMapper: HistoryMapper?
    
    var sectionsArray : [[[ActivityModel]]] = [[[ActivityModel]]]()
    var sectionsHeaderArray : [[TransactionModelDetails]] = [[TransactionModelDetails]]()
    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        } 
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    
    private func loadData(){
        
        
        
        if let path = Bundle.main.path(forResource: "Transaction_History_modified", ofType: "json")
        {
            let contents: NSString?
            do {
                contents = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
                historyMapper = Mapper<HistoryMapper>().map(JSONString: contents as! String)
            } catch _ {
                contents = nil
            }
            print(historyMapper as Any)
        }
        
        if historyMapper != nil{
            mapResponseDataWithModel()

        }
    }
    
    
    private func mapResponseDataWithModel(){
        
        //historyObj = HistoryModel()
        
        if let financialAsAtDate = historyMapper?.financialAsAtDate{
            historyObj?.financialAsAtDate = financialAsAtDate
            
        }
        if let opStatus = historyMapper?.opStatus{
            historyObj?.opStatus = opStatus
            
        }
        if let nextStartKey = historyMapper?.nextStartKey{
            historyObj?.nextStartKey = nextStartKey
            
        }
        
        for val1 in (historyMapper?.transactionsByDate)!{
            let objModel1 = TransactionModel()
            if let dateOfTransaction = val1.dateOfTransaction{
                objModel1.dateStr = dateOfTransaction
                
            }
            
            for val2 in (val1.product)!{
                
                
                let oldArray = val2.activity
                //let sorted = oldArray?.sorted { $0.activityLine2! < $1.activityLine2! }
                let groupedArray = returnGroupedArray(array: oldArray!)
                print(groupedArray)
                
                for val3 in groupedArray{
                    let objModel2 = TransactionModelDetails()
                    if let productType = val2.productType{
                        objModel2.productTypeStr = productType
                        
                    }
                    for val4 in val3{
                        let objModel3 = ActivityModel()
                        
                        if let amount = val4.amount{
                            objModel3.amount = amount
                            
                        }
                        if let descriptionLine1 = val4.descriptionLine1{
                            objModel3.descriptionLine1 = descriptionLine1
                            
                        }
                        if let descriptionLine2 = val4.descriptionLine2{
                            objModel3.descriptionLine2 = descriptionLine2
                            
                        }
                        if let typeStr = val4.activityLine2{
                            objModel2.typeStr = typeStr
                            
                        }
                        
                        objModel2.activityArray.append(objModel3)
                    }
                    objModel1.typeArray?.append(objModel2)
                    
                }
                
            }
            
            historyObj?.transactions?.append(objModel1)
            
        }
        
        
        print(historyObj as Any)

    }
    
    
    private func returnGroupedArray(array:[HistoryActivityMapper]) -> [[HistoryActivityMapper]]{
        
        var result: [[HistoryActivityMapper]] = []
        var prevInitial: Character? = nil
        for name in array {
            let initial = name.activityLine2?.characters.first
            if initial != prevInitial {  // We're starting a new letter
                result.append([])
                prevInitial = initial
            }
            result[result.endIndex - 1].append(name)
        }
        
        return result
    }
    
    
    private func serializeResponseData(){
        for  (_,tranObj) in (historyObj!.transactions?.enumerated())!{
            var arr1 : [[ActivityModel]] = []
            for (_,val1) in tranObj.typeArray!.enumerated(){
                var arr2 : [ActivityModel] = []
                for val2 in val1.activityArray{
                    arr2.append(val2)
                }
                arr1.append(arr2)
            }
            sectionsArray.append(arr1)
        }
        
        
        for  (_,tranObj) in (historyObj!.transactions?.enumerated())!{
            var arr1 : [TransactionModelDetails] = []
            for (_,val1) in tranObj.typeArray!.enumerated(){
                arr1.append(val1)
            }
            sectionsHeaderArray.append(arr1)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        table.separatorStyle = .none
        table.separatorColor = UIColor.darkGray
        table.cellLayoutMarginsFollowReadableWidth = false
        table.delegate = self
        
        
        historyObj = HistoryModel()
        historyObj?.transactions = []
        
        loadData()
        serializeResponseData()
        
        
        //        for i in 0..<2{
        //            historyObj?.transactions = []
        //            for j in 0..<2{
        //                let tran: TransactionModel = TransactionModel()
        //                tran.dateStr = "date j \(j)"
        //                for k in 0..<2{
        //
        //                    let mod: TransactionModelDetails = TransactionModelDetails()
        //                    mod.typeStr = "type k \(k)"
        //                    for l in 0..<3{
        //
        //                        if (j == 1 && k == 1 && l == 2){
        //                            break
        //                        }
        //
        //
        //                        let det: ActivityModel = ActivityModel()
        //
        //                        det.amount = "amount l \(l)"
        //                        mod.typeArray.append(det)
        //
        //                    }
        //                    tran.typeArray?.append(mod)
        //                }
        //
        //                historyObj?.transactions?.append(tran)
        //            }
        //
        //
        //        }
        
        
        
        //        var zArry = [Int](count:10, repeatedValue: 0)
        //        var yArry = [[Int]](count:20, repeatedValue: zArry)
        //        var xArry = [[[Int]]](count:30, repeatedValue: yArry)
        //
        //        var val = xArry[2][1][1]
        
        
        
        
        
        
        //        for tranobj in sectionValue!{
        //
        //
        //        }
        
        
        self.configureView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        view.backgroundColor = UIColor.lightGray
        if let val = historyObj?.transactions![section]{
            view.text = val.dateStr
        }
        return view
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        
        return (historyObj!.transactions!.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return "Section"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //let sectionItems = historyObj?.transactions![section]
        
        let sectionItems = self.sectionsArray[Int(section)]
        var numberOfRows = sectionItems.count
        // For second level section headers
        for rowItems: [ActivityModel] in sectionItems {
            numberOfRows += rowItems.count
            // For actual table rows
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        //cell.layoutMargins = .zero
        _ = self.sectionsHeaderArray[Int((indexPath as NSIndexPath).section)]
        
        let itemAndSubsectionIndex = self.computeItemAndSubsectionIndex(indexPath)
        let subsectionIndex = Int((itemAndSubsectionIndex as NSIndexPath).section)
        let itemIndex = (itemAndSubsectionIndex as NSIndexPath).row
        if itemIndex < 0{
            cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
            tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
            
        }
        else{
            print("rows \(tableView.numberOfRows(inSection: indexPath.section))")
            if ((itemIndex + 1) == sectionsArray[(indexPath as NSIndexPath).section][subsectionIndex].count) && (tableView.numberOfRows(inSection: indexPath.section) > indexPath.row + 1){
                print("ItemIndex \(itemIndex) count \(sectionsArray[(indexPath as NSIndexPath).section][subsectionIndex].count)")
                //cell.separatorInset = .zero
                cell.separatorInset = .zero
                tableView.separatorInset = .zero
                
//                if cell.viewWithTag(1001) == nil{
//                    let view = UIView()
//                    view.tag = 1001
//                    var framev = cell.frame
//                    framev.origin.y = cell.frame.size.height - 0.75
//                    framev.size.height = 0.75
//                    view.frame = framev
//                    view.backgroundColor = UIColor.lightGray
//                    cell.addSubview(view)
//                    
//                }
//                
           }
//            else{
//                //cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
//                //tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
//                cell.viewWithTag(1001)?.removeFromSuperview()
//                
//            }
        }
        
        if (indexPath.section + 1) == tableView.numberOfSections{
            
            if (itemIndex + 1) == sectionsArray[(indexPath as NSIndexPath).section][subsectionIndex].count{
                loadMore()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        //var sectionItems = self.sectionsArray[Int(indexPath.section)]
        
        var sectionHeaders = self.sectionsHeaderArray[Int((indexPath as NSIndexPath).section)]
        let itemAndSubsectionIndex = self.computeItemAndSubsectionIndex(indexPath)
        let subsectionIndex = Int((itemAndSubsectionIndex as NSIndexPath).section)
        let itemIndex = (itemAndSubsectionIndex as NSIndexPath).row
        if itemIndex < 0 {
            // Section header
            let cell = table.dequeueReusableCell(withIdentifier: "subSectionCell", for: indexPath)
            let act : TransactionModelDetails = sectionHeaders[subsectionIndex]
            cell.textLabel!.text = "\(act.typeStr)_\(act.productTypeStr)"
            cell.contentView.backgroundColor = UIColor.white
            //cell.textLabel.text = [NSString stringWithFormat:@"Header %d",itemIndex];
            return cell
        }
        else {
            // Row Item
            let cell = table.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as! CustomRowCell
            
            cell.seperatorLbl.isHidden = true
            if ((itemIndex + 1) == sectionsArray[(indexPath as NSIndexPath).section][subsectionIndex].count) && (tableView.numberOfRows(inSection: indexPath.section) > indexPath.row + 1){
                cell.seperatorLbl.isHidden = false

            }

            let textField : UITextField = cell.viewWithTag(101) as! UITextField
            textField.backgroundColor = UIColor.green
            
            let act : ActivityModel = sectionsArray[(indexPath as NSIndexPath).section][subsectionIndex][itemIndex]
            print("COUNT \(sectionsArray[(indexPath as NSIndexPath).section][subsectionIndex].count)_ROW \(itemIndex)")
            
            cell.titleCell!.text = "\(act.amount)\n \(act.descriptionLine1)\n \(act.descriptionLine2)"//"\(sectionsArray[subsectionIndex][itemIndex]) --\(Int(itemIndex))"
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            return cell
        }
    }
    
    
    
    
    //  Converted with Swiftify v1.0.6185 - https://objectivec2swift.com/
    
    func computeItemAndSubsectionIndex(_ indexPath: IndexPath) -> IndexPath {
        var sectionItems = self.sectionsArray[Int((indexPath as NSIndexPath).section)]
        var itemIndex = (indexPath as NSIndexPath).row
        var subsectionIndex = 0
        for i in 0..<sectionItems.count {
            // First row for each section item is header
            itemIndex -= 1
            // Check if the item index is within this subsection's items
            let subsectionItems = sectionItems[i]
            if itemIndex < Int(subsectionItems.count) {
                subsectionIndex = i
                break
            }
            else {
                itemIndex -= subsectionItems.count
            }
        }
        return IndexPath(row: itemIndex, section: subsectionIndex)
    }
    
    
    
    func loadMore() {
        
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.loadData()
                self.serializeResponseData()
                DispatchQueue.main.async {
                    self.table.reloadData()
                    
                }
            }
            
        }
        
    }


    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 226.0, 0.0);
        table.contentInset = contentInsets;
        table.scrollIndicatorInsets = contentInsets;

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        var aRect = table.frame;
        aRect.size.height -= 226.0;
        if (!aRect.contains(textField.bounds.origin) ) {
            let scrollPoint = CGPoint(x: 0.0, y: (textField.frame.origin.y - 226.0));
            table.setContentOffset(scrollPoint, animated: true)
        }

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField!) {





    }

    func textFieldDidEndEditing(_ textField: UITextField!) {


    }
    
    //    func sections() -> [Any] {
    //        if sections == nil {
    //            self.sections = [[["p", "q"], ["r", "s"]], [["a", "b"], ["c", "d"]]]
    //        }
    //        return sections
    //    }
    //
    //    func sectionHeaders() -> [Any] {
    //        if sectionHeaders == nil {
    //            self.sectionHeaders = [["Section A1", "Section A2"], ["Section B1", "Section B2"]]
    //        }
    //        return sectionHeaders
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}





