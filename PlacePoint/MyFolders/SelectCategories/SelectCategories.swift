//
//  SelectCategories.swift
//  PlacePoint
//
//  Created by Mac on 20/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

protocol SelectedCategories: class {
    
    func category(selectedCat: [String])
}

class SelectCategories: UIViewController,SelectedSubPlan {
    
    @IBOutlet var tableShowCategories: UITableView!
    
    var isPostVc = false
    
    var expandedItemList = [Int]()
    
    var expandedItemList1 = [Int]()
    
    var popUpSubscPlan = PopUpSubScriptionPlan()
    
    weak var delegate: SelectedCategories?
    
    var isRegisterVc = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.setUpNavigation()
        
        self.setUpView()
        
    }
    
    
    func setUpView() {
        
        if isAddPost == true {
            
            arrAllCategories = arrPostCategories
            
            dictAllCategories = dictPostCategories
            
        }
        
        for i in 0..<arrAllCategories.count {
            
            expandedItemList.append(0)
            
        }
        
        expandedItemList1 = expandedItemList
        
        tableShowCategories.dataSource = self
        
        tableShowCategories.delegate = self
        
        let categoryCell = UINib(nibName: "SelectCategoriesCell", bundle: nil)
        
        tableShowCategories.register(categoryCell, forCellReuseIdentifier: "SelectCategoriesCell")
        
        tableShowCategories.tableFooterView = UIView()
        
    }
    
    //kirti
    
//    //MARK: - Array into Json
//    func setJsonString()  {
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: arrAllCategories, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//
//                let str = JSONString
//
//            }
//        }
//        catch _ {
//
//            print ("UH OOO")
//        }
//    }
//
    
    //MARK: - SetUp Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Choose a category")
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    // backButton Tapped
    @objc func saveButtonTapped() {
        
        selectedcategories.removeAll()
        
        let valuesOrders = Array(dictAllCategories.values)
        
        let arrChild = valuesOrders.compactMap { ($0 as! [String:Any])["child"]}
        
        for i in 0..<arrChild.count {
            
            let arrChildDict = arrChild[i] as! [[String:Any]]
            
            for a in 0..<arrChildDict.count {
                
                let dict = arrChildDict[a] as? [String: Any]
                
                if dict != nil {
                    
                    let status = dict!["status"] as? String
                    
                    if status == "1" {
                        
                        let cat = dict!["subCat"] as? String
                        
                        let arr = selectedcategories
                        
                        if selectedcategories.contains(cat!) {
                            
                            print("yes")
                            
                        } else {
                            
                            selectedcategories.append(cat!)
                        }
                        
                    }
                    
                }
            }
        }
        
        delegate?.category(selectedCat: selectedcategories)
        
        if isPostVc == false && isRegisterVc == false {
            
            self.navigationController?.popViewController(animated: true)
        }
        else {
            
            if isAddPost == true {
                
                self.dismiss(animated: true, completion: nil)
                
                
            }
            else {
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        if isPostVc == false && isRegisterVc == false {
            
            self.navigationController?.popViewController(animated: true)
        }
        else {
            
            if isAddPost == true {
                
                self.dismiss(animated: true, completion: nil)
                
            }
            else {
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        
        let section = sender.view?.tag
        
        let selectedStr = arrAllCategories[section!] as? String
        
        let sectionCat = dictAllCategories[selectedStr!] as? [String:Any]
        
        if sectionCat != nil {
            
            let catChild = sectionCat!["child"] as? [AnyObject]
            
            if catChild != nil {
                
                let expandValue = expandedItemList[section!]
                
                if expandValue == 1 {
                    
                    expandedItemList[section!] = 0
                }
                else {
                    
                    expandedItemList[section!] = 1
                    
                }
                self.tableShowCategories.reloadData()
            }
        }
        else {
            
            let alert = UIAlertController(title: "",message: "Please Select SubCategory",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    func setSubPlan(name: String) {
        
        popUpSubscPlan.removeFromSuperview()
        
        switch name {
            
        case "3":
            
            popUpSubscPlan.imgFree.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            popUpSubscPlan.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            selectedPlan = "3"
            
            UserDefaults.standard.setBusinessUserType(userType: "Free")
            
        case "1":
            
            popUpSubscPlan.imgPrem.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            popUpSubscPlan.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            selectedPlan = "1"
            
            UserDefaults.standard.setBusinessUserType(userType: "Premium")
            
            tableShowCategories.reloadData()
            
        case "2":
            
            popUpSubscPlan.imgStd.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            popUpSubscPlan.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgAdmin.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            selectedPlan = "2"
            
            UserDefaults.standard.setBusinessUserType(userType: "Standard")
            
            tableShowCategories.reloadData()
            
        case "4":
            
            popUpSubscPlan.imgAdmin.image = #imageLiteral(resourceName: "Radiobtn_on")
            
            popUpSubscPlan.imgPrem.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgFree.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            popUpSubscPlan.imgStd.image = #imageLiteral(resourceName: "RadiBtn_off")
            
            selectedPlan = "4"
            
            UserDefaults.standard.setBusinessUserType(userType: "Admin")
            
            tableShowCategories.reloadData()
            
        default:
            break
        }
    }
    
}


//MARK: - TableView DataSource and Delegate
extension SelectCategories: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrAllCategories.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        let sectionTitle = arrAllCategories[section] as? String
        
        let dict = dictAllCategories[sectionTitle!] as? [String: Any]
        
        var image = UIImageView()
        
        if(expandedItemList[section] == 1)
        {
            image = UIImageView(image: #imageLiteral(resourceName: "drop-arrow"))
            
            image.frame = CGRect(x: DeviceInfo.TheCurrentDeviceWidth - 50, y: 10, width: 15, height: 15)
            
        }
        else
        {
            image = UIImageView(image: #imageLiteral(resourceName: "right-arrow"))
            
            image.frame = CGRect(x: DeviceInfo.TheCurrentDeviceWidth - 50, y: 10, width: 15, height: 15)
        }
        
        view.addSubview(image)
        
        let label = UILabel()
        
        label.text = sectionTitle
        
        label.frame = CGRect(x: 30.0, y: 10, width: 250, height: 30)
        
        if dict != nil {
            
            if dict!["status"] as? String == "1" {
                
                label.textColor = UIColor(red: 77.0/255.0, green: 183.0/255.0, blue: 254.0/255.0, alpha: 1.0)
                
            }
            
        }
        view.addSubview(label)
        
        view.tag = section
        
        let headerTapGesture = UITapGestureRecognizer()
        
        headerTapGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
        
        view.addGestureRecognizer(headerTapGesture)
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionTitle = arrAllCategories[section] as? String
        
        let sectionCat = dictAllCategories[sectionTitle!] as? [String: Any]
        
        let childCat = sectionCat!["child"] as? [Any]
        
        if(expandedItemList[section] == 0)
        {
            return 0
        }
        
        return (childCat?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoriesCell", for: indexPath) as? SelectCategoriesCell else {
            fatalError()
        }
        
        cell.selectionStyle = .none
        
        let sectionTitle = arrAllCategories[indexPath.section] as? String
        
        let sectionCat = dictAllCategories[sectionTitle!] as? [String: Any]
        
        let subCategory = sectionCat!["child"] as? [AnyObject]
        
        let category = subCategory?[indexPath.row]["subCat"] as? String
        
        let status = subCategory?[indexPath.row]["status"] as? String
        
        if status == "1" {
            
            cell.imgSelectedCategory.image = #imageLiteral(resourceName: "checkBoxBlue")
            
        }
        else {
            
            cell.imgSelectedCategory.image = #imageLiteral(resourceName: "UncheckBoxBlue")
            
        }
        
        let strImg = subCategory?[indexPath.row]["img_url"] as? String
        
        cell.lblChildCat.text = category
        
        if strImg != "" {
            
            let url = URL(string: strImg as! String)!
            
            cell.imgChildCat.kf.indicatorType = .activity
            
            (cell.imgChildCat.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            cell.imgChildCat.kf.setImage(with: url ,
                                         placeholder: #imageLiteral(resourceName: "placeholder"),
                                         options: [.transition(ImageTransition.fade(1))],
                                         progressBlock: { receivedSize, totalSize in
            },
                                         completionHandler: { image, error, cacheType, imageURL in
            })
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionTitle = arrAllCategories[indexPath.section] as? String
        
        var sectionCat = dictAllCategories[sectionTitle!] as? [String: Any]
        
        var subCategory = sectionCat!["child"] as? [AnyObject]
        
        let cell = tableView.cellForRow(at: indexPath) as! SelectCategoriesCell
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free" && selectedcategories.count > 0 && cell.imgSelectedCategory.image != #imageLiteral(resourceName: "checkBoxBlue"){
            
            let alert = UIAlertController(title: "Alert",message: "You are a free user and can only choose one category. Please upgrade your plan to choose more categories.",preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                
                return
                
            }))
            
            alert.addAction(UIAlertAction(title: "upgrade", style: .default, handler: { (action) in
                
                self.popUpSubscPlan = Bundle.main.loadNibNamed("PopUpSubScriptionPlan", owner: nil, options: nil)?[0] as! PopUpSubScriptionPlan
                
                self.popUpSubscPlan.frame = self.tableShowCategories.frame
                
                self.popUpSubscPlan.delegate = self
                
                self.view.addSubview(self.popUpSubscPlan)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            
            if cell.imgSelectedCategory.image == #imageLiteral(resourceName: "UncheckBoxBlue") {
                
                cell.imgSelectedCategory.image = #imageLiteral(resourceName: "checkBoxBlue")
                
                let category = subCategory?[indexPath.row].value(forKey: "subCat") as? String
                
                var dictSub = subCategory?[indexPath.row] as! [String:Any]
                
                dictSub["status"] = "1"
                
                subCategory![indexPath.row] = dictSub as AnyObject
                
                sectionCat!["child"] = subCategory
                
                sectionCat!["status"] = "1"
                
                dictAllCategories[sectionTitle!]  = sectionCat
                
                selectedcategories.append(category!)
                
            }
            else {
                
                cell.imgSelectedCategory.image = #imageLiteral(resourceName: "UncheckBoxBlue")
                
                let category = subCategory?[indexPath.row].value(forKey: "subCat") as? String
                
                var dictSub = subCategory?[indexPath.row] as! [String:Any]
                
                dictSub["status"] = "0"
                
                subCategory![indexPath.row] = dictSub as AnyObject
                
                sectionCat!["child"] = subCategory
                
                let valuesOrders = Array(subCategory!)
                
                let arrStatus = valuesOrders.compactMap { ($0 as! [String:Any])["status"]}
                
                let statusCount = (arrStatus as! [String]).map { Int($0)! }.reduce(0, +)
                
                if selectedcategories.contains(category!) {
                    
                    let index = selectedcategories.index(of: category!)
                    
                    selectedcategories.remove(at: index!)
                    
                }
                
                if statusCount == 0 {
                    
                    sectionCat!["status"] = "0"
                    
                }
                else {
                    
                    sectionCat!["status"] = "1"
                }
                
                dictAllCategories[sectionTitle!]  = sectionCat
                
            }
            
        }
        
        tableShowCategories.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
}

