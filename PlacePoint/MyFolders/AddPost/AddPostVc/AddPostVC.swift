//
//  AddPostVC.swift
//  PlacePoint
//
//  Created by Mac on 04/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MMDrawerController
import SVProgressHUD
import PhotoCropEditor
import Kingfisher

class AddPostVC: UIViewController {
    
    @IBOutlet weak var vwFlashPostPopUP: UIView!
    @IBOutlet weak var tblViewAddPost: UITableView!
    
    @IBOutlet weak var pickerSchedule: UIPickerView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet var viewForAllPicker: UIView!
    
    var isScheduleSelected = false
    
    var chooseCat = false
    
    var imagePicker = UIImagePickerController()
    
    var isfirstYoutubeSelected: Bool = false
    
    var isImageSend: Bool = false
    
     var isVideoSend: Bool = false
    
    var postVideoUrl: URL?
    
    var croppedImage = UIImage()
    
    var selectedImage = UIImage()
    
    var imageHeight = CGFloat()
    
    var headerView = AddPostHeader()
    
    var arrSelectedCategory = [String]()
    
    var footerView = AddPostFooter()
    
    var imageStatus = String()
    
    var heightOfImageToLoad = CGFloat()
    
    var selectedItem = String()
    
    var selectedType = String()
    
    var selectedDay = String()
    
    var arrPicker = [String]()
    
    var selectedTime = String()
    
    var catId = String()
    
    
    
    var arrSchedulePicker = ["Schedule post every week","Schedule post on a specific day each month","Schedule post for a specific day"]
    
    var arrDayPicker = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var arrMonthPicker = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    
    
    var arrOffersPicker = ["20","40","60","80","100","120","140","160","180","200"]
    
    var arrPersonsPicker = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]

    var isTime = false
    
    var strDay = String()
    
    var isDatePicker = false
    
    var pickerSelectedIndex = Int()
    
    var pickedDate = Date()
    
    var nowStatus = String()
    
    var editDict = [String: Any]()
    
    var imgURl = String()
    
    var postId = String()
    
    var strMaxOffers = ""
    
    var strMaxPersons = ""

    var strExpiryTime = ""

    var strExpiryDate = ""

    var boolDateFlashPostPicker = false
    
    var strSwitchStatus = ""
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
        datePicker.minimumDate = Date()
        
//        if UIScreen.main.bounds.size.height == 812 {
//             self.tblViewAddPost.frame.origin.y = 45
//            self.tblViewAddPost.frame.size.height = self.tblViewAddPost.frame.height - 50
//        }
//        else {
//             self.tblViewAddPost.frame.origin.y = 45
//
//            self.tblViewAddPost.frame.size.height = 500
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setEditData(_:)), name: NSNotification.Name(rawValue: "editPostInfo"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setView), name: Notification.Name("afterUpgarde"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearAllData), name: Notification.Name("clearData"), object: nil)
        
        if isEditPost != true {
            
            self.setUpView()
        }
        
        selectedImage = #imageLiteral(resourceName: "placeholder")
        
        tblViewAddPost.dataSource = self
        
        tblViewAddPost.delegate = self
        
        self.registerTableView()
        
        self.getPreFilledCategories()
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free" || selectedBusinessType == "Standard" {
            
            let nib = Bundle.main.loadNibNamed("PopUpPremium", owner: nil, options: nil)?[0] as! PopUpPremium
            
            nib.frame = self.tblViewAddPost.frame
            
            self.tblViewAddPost.isHidden = true
            
            nib.delegate = self
            
            self.view.addSubview(nib)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
//        if UIScreen.main.bounds.size.height == 812 {
//             self.tblViewAddPost.frame.origin.y = 45
//
//            self.tblViewAddPost.frame.size.height = self.tblViewAddPost.frame.height - 50
//        }
//        else {
//
//            self.tblViewAddPost.frame.origin.y = 45
//
//            self.tblViewAddPost.frame.size.height = 500
//        }
        
        
//        tblViewAddPost.frame.origin.y = 300
        
//        tblViewAddPost.frame.size.height = 300
        
        
        self.view.isUserInteractionEnabled = true
        
        if imgURl == "" {
            
            self.imageHeight = 0.0
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            let cell = tblViewAddPost.cellForRow(at: indexPath) as? AddPostViewCell
            
            cell?.imgThumnail.isHidden = true
            
            cell?.imgThumnail.image = UIImage(named: "")
        }
        
        tblViewAddPost.dataSource = self
        
        tblViewAddPost.delegate = self
        
        self.tblViewAddPost.isUserInteractionEnabled = true
        
        if arrSelectedCategory.count != 0 {
            
            let strSelectedCategory = (arrSelectedCategory.map{String($0)}).joined(separator: ",")
            
            headerView.lblChooseCategory.text = strSelectedCategory
        }
        else {
            
            headerView.lblChooseCategory.text = "Choose a category"
        }
    }
    
    
    func registerTableView() {
        
        tblViewAddPost.register(UINib(nibName: "FlashPostTVcell", bundle: nil), forCellReuseIdentifier: "flashPostTVcell")
        
        let postNib = UINib(nibName: "AddPostViewCell", bundle: nil)
        
        tblViewAddPost.register(postNib, forCellReuseIdentifier: "AddPostViewCell")
        
        headerView = (Bundle.main.loadNibNamed("AddPostHeader", owner: nil, options: nil)?[0] as? AddPostHeader)!
        
        let ScheduleNib = UINib(nibName: "SchedulePostSectionCell", bundle: nil)
        
        tblViewAddPost.register(ScheduleNib, forCellReuseIdentifier: "SchedulePostSectionCell")
        
        let SectionCellNib = UINib(nibName: "SectionCellChoosecCat", bundle: nil)
        
        tblViewAddPost.register(SectionCellNib, forCellReuseIdentifier: "SectionCellChoosecCat")
        
        let cellPost = UINib(nibName: "ScheduleAddPostCell", bundle: nil)
        
        tblViewAddPost.register(cellPost, forCellReuseIdentifier: "ScheduleAddPostCell")
        
        footerView = (Bundle.main.loadNibNamed("AddPostFooter", owner: nil, options: nil)?[0] as? AddPostFooter)!
        
        footerView.delegate = self
        
        self.tblViewAddPost.tableFooterView = footerView
        
        headerView.delegate = self
        
        headerView.txtView.delegate = self
        
        headerView.txtFieldUrl.delegate = self
        
        self.tblViewAddPost.tableHeaderView = headerView
        
        headerView.vwTextViewBd.layer.borderColor = UIColor.lightGray.cgColor
        
        headerView.vwTextViewBd.layer.borderWidth = 1
        
        headerView.vwTextViewBd.clipsToBounds = true
        
        headerView.vwChooseCategory.layer.borderColor = UIColor.lightGray.cgColor
        
        headerView.vwChooseCategory.layer.borderWidth = 1
        
        headerView.vwtextUrl.layer.borderWidth = 0.5
        
        headerView.vwtextUrl.layer.borderColor = UIColor.black.cgColor
        
        headerView.vwtextUrl.layer.cornerRadius = 5
        
        tblViewAddPost.estimatedRowHeight = 150
        
        tblViewAddPost.rowHeight = UITableViewAutomaticDimension
        
        viewForAllPicker.isHidden = true
        
        pickerSchedule.isHidden = true
        
        datePicker.isHidden = true
        
        toolBar.isHidden = true
        
    }
    
    
    func getPreFilledCategories() -> Void {
        
        if !(dictPostCategories.isEmpty){
            
            var arrSubCatName = [String]()
            
            let array = arrPostCategories as? [AnyObject]
            
            for i in 0..<(array?.count)! {
                
                let catName = array![i] as? String
                
                let dict = dictPostCategories[catName!] as? [String: Any]
                
                let arrChild = dict!["child"] as? [AnyObject]
                
                for a in 0..<(arrChild?.count)! {
                    
                    let dictSubCat = arrChild![a] as? [String: Any]
                    
                    let status = dictSubCat!["status"] as? String
                    
                    if status == "1" {
                        
                        let subCatName = dictSubCat!["subCat"] as? String
                        
                        arrSubCatName.append(subCatName!)
                    }
                }
                
                arrSelectedCategory = arrSubCatName
            }
        }
    }
    
    
    @objc func setView() {
        
        tblViewAddPost.isHidden = false
        
        tblViewAddPost.dataSource = self
        
        tblViewAddPost.delegate = self
        
        tblViewAddPost.reloadData()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        
        if touch?.view == self.viewForAllPicker {
            
            self.viewForAllPicker.isHidden = true
            
            self.pickerSchedule.isHidden = true
            
            self.toolBar.isHidden = true
            
            self.datePicker.isHidden = true
            
        }
    }
    
    
    @objc func clearAllData() {
        
        self.editDict.removeAll()
        
        let indexPath = IndexPath(row: 0, section: 1)
        
        let cell = tblViewAddPost.cellForRow(at: indexPath) as?AddPostViewCell
        
        cell?.imgThumnail.image = UIImage(named: "")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editPostInfo"), object: nil, userInfo: self.editDict)
        
    }
    
    
    @objc func setEditData(_ notification: NSNotification) {
        
        if let dict = notification.userInfo as NSDictionary? {
            
            self.editDict = dict as! [String : Any]
            
            if !(editDict.isEmpty) {
                
                headerView.setData(dict: self.editDict)
                
                footerView.btnPost.setTitle("Done", for: .normal)
                
                if let image = editDict["image_url"] as? String  {
                    
                    let strHeight = editDict["height"] as? String
                    
                    if let numHeight = NumberFormatter().number(from: strHeight!) {
                        
                        let height = CGFloat(numHeight)
                        
                        self.imageHeight = height
                        
                    }
                    if image != "" {
                        
                        self.imgURl = (editDict["image_url"] as? String)!
                    }
                }
                
                if let cat = editDict["category_id"] as? String {
                    
                    self.catId = cat
                }
                
                if let post_Id = editDict["id"] as? String {
                    
                    self.postId = post_Id
                }
                
                isScheduleSelected = true
                
                var type = String()
                
                var day = String()
                
                var time = String()
                
                if let Scheduletype = dict["type"] as? String {
                    
                    type = Scheduletype
                    
                }
                
                if let Scheduleday = dict["day"] as? String {
                    
                    day = Scheduleday
                }
                
                if type == "1" {
                    
                    self.selectedItem = "Schedule post every week"
                    
                    self.selectedType = "1"
                    
                    let strSelectedDay = DayClass.sharedInstance.getDay(index: "\(day)")
                    
                    self.strDay = strSelectedDay
                    
                }
                else if type == "2" {
                    
                    self.selectedItem = "Schedule post on a specific day each month"
                    
                    self.selectedType = "2"
                    
                }
                else {
                    
                    self.selectedItem = "Schedule post for a specific day"
                    
                    self.selectedType = "3"
                }
                
                self.selectedDay = day
                
                if let Scheduletime = dict["time"] as? String {
                    
                    time = Scheduletime
                }
                
                self.selectedTime = time
                
                self.setUpView()
                
                tblViewAddPost.reloadData()
                
            }
            else {
                
                self.imageHeight = 0.0
                
                let indexPath = IndexPath(row: 0, section: 1)
                
                let cell = tblViewAddPost.cellForRow(at: indexPath) as?AddPostViewCell
                
                cell?.imgThumnail.image = UIImage(named: "")
                
                headerView.setData(dict: self.editDict)
                
                headerView.lblUserName.text = UserDefaults.standard.getBusinessName()
                
                headerView.lblPlaceholder.isHidden = false
                
                footerView.btnPost.setTitle("Post", for: .normal)
                
                self.imgURl = ""
                
                self.catId = ""
                
                self.postId = ""
                
                self.selectedItem = ""
                
                self.selectedType = ""
                
                self.strDay = ""
                
                self.selectedDay = ""
                
                self.selectedTime = ""
                
                isScheduleSelected = false
                
                tblViewAddPost.reloadData()
            }
        }
    }
    
    
    // MARK: - Set Navigation
    func setUpNavigation() {
        
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.barTintColor = UIColor.themeColor()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.navTitle(title: "Add New Post")
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    
    
    @objc func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnToolbarCancel(_ sender: Any) {
        
        viewForAllPicker.isHidden = true
        
        self.pickerSchedule.isHidden = true
        
        self.toolBar.isHidden = true
        
        self.datePicker.isHidden = true
    }
    
    
    @IBAction func btnOKClick(_ sender: Any) {
        
        
          self.vwFlashPostPopUP.isHidden = true
        
        if self.isScheduleSelected == false {
            
            isAddPost = true
            
            isScheduleVc = false
            
            isEditPost = false
            
            let imageDataDict:[String: UIImage] = ["image": #imageLiteral(resourceName: "placeholder")]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTabBarIndex"), object: nil, userInfo:imageDataDict)
            
            if self.strSwitchStatus == "1" {
                
                boolJumpToFlashPost = true
                
            }
                
            else {
                
                boolJumpToFlashPost = false
            }
            self.editDict.removeAll()
        }
        else {
            
            isAddPost = true
            
            isScheduleVc = true
            
            isEditPost = false
            
            let imageDataDict:[String: UIImage] = ["image": #imageLiteral(resourceName: "placeholder")]
            
            if self.strSwitchStatus == "1" {
                
                isScheduleVc = false
                
                boolJumpToFlashPost = true
            }
            else {
                
                boolJumpToFlashPost = false
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeTabBarIndex"), object: nil, userInfo:imageDataDict)
            
            
            self.editDict.removeAll()
        }
        
    }
    
    @IBAction func btnUrlFbClick(_ sender: Any) {
        
        guard let url = URL(string: "https://www.facebook.com/placepoint.ireland/") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    @IBAction func btnToolBarDone(_ sender: Any) {
        
        viewForAllPicker.isHidden = true
        
        self.pickerSchedule.isHidden = true
        
        self.toolBar.isHidden = true
        
        self.datePicker.isHidden = true
        
        if arrPicker == arrDayPicker {
            
            let selectDay = arrPicker[pickerSelectedIndex]
            
            let dayIndex = DayClass.sharedInstance.getDayIndex(day: selectDay)
            
            self.selectedDay = "\(dayIndex)"
        }
        else if arrPicker == arrMonthPicker {
            
            self.selectedDay = "\(arrPicker[pickerSelectedIndex])"
        }
        else if arrPicker == arrSchedulePicker {
            
            self.selectedItem = arrPicker[pickerSelectedIndex]
            
            if isDatePicker == false {
                
                self.selectedDay = ""
                
                self.selectedTime = ""
            }
        }
        
        if arrPicker == arrOffersPicker {
            
            let selectDay = arrOffersPicker[pickerSelectedIndex]
   
            strMaxOffers = selectDay
        }
        
        if arrPicker == arrPersonsPicker {
            
            let selectDay = arrPersonsPicker[pickerSelectedIndex]
            
            strMaxPersons = selectDay
        }
        
        if isDatePicker == true {
            
            if isTime == true {
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "h:mm a"
                
                if boolDateFlashPostPicker {
                
                    self.strExpiryTime = formatter.string(from: pickedDate)
                    
                    boolDateFlashPostPicker = false
                }
                else {
                
                    self.selectedTime = formatter.string(from: pickedDate)
                }
            }
            else {
                
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyyy-MM-dd"
                
                let result = formatter.string(from: pickedDate)
                
                if boolDateFlashPostPicker {
                    
                    self.strExpiryDate = result
                    
                    boolDateFlashPostPicker = false
                }
                else {
                    
                    self.selectedDay = result
                }
            }           
        }
        
        tblViewAddPost.reloadData()
    }
    
    
    @IBAction func pickerDateChanged(_ sender: UIDatePicker) {
        
        pickedDate = sender.date
    }
    
    
    func openEditor() {
        
        let image = selectedImage
        
        // Use view controller
        let controller = CropViewController()
        
        controller.delegate = self
        
        controller.image = image
        
        controller.toolbarHidden = true
        
        let navController = UINavigationController(rootViewController: controller)
        
        navController.modalPresentationStyle = .custom
        
        present(navController, animated: true, completion: nil)
        
    }
    
    
    func setCategoryData() {
        
        var dictCat = [String: Any]()
        
        for i in 0..<arrAllCategories.count {
            
            let catName = arrAllCategories[i] as? String
            
            var dict = dictAllCategories[catName!] as? [String: Any]
            
            if dict!["status"] as? String == "1" {
                
                let arrChild = dict!["child"] as? [AnyObject]
                
                var arrSubChild = [AnyObject]()
                
                for a in 0..<(arrChild?.count)!{
                    
                    let dictSub = arrChild![a] as? [String: Any]
                    
                    let strCat = UserDefaults.standard.getSelectedCategory()
                    
                    let arrCat = strCat.components(separatedBy: ",")
                    
                    for k in 0..<(arrCat.count) {
                        
                        let cat = arrCat[k] as? String
                        
                        if dictSub!["subCat"] as? String == cat {
                            
                            let dictChildReg = dictSub as? [String: Any]
                            
                            arrSubChild.append(dictChildReg as AnyObject)
                            
                        }
                        
                        let status = dict!["status"] as? String
                        
                        dict?.removeAll()
                        
                        dict!["child"] = arrSubChild
                        
                        dict!["status"] = status
                        
                        dictCat[catName!] = dict as! [String : Any]
                        
                        dictCat.forEach { (k,v) in dictPostCategories[k] = v }
                        
                        arrPostCategories = [String] (dictPostCategories.keys) as [AnyObject]
                    }
                }
            }
        }
        
    }
    
    
    func setUpView() {
        
        dictPostCategories.removeAll()
        
        arrPostCategories.removeAll()
        
        let arrCategories = AppDataManager.sharedInstance.arrCategories as [AnyObject]
        
        var arrSelectCategory = [String]()
        
        if chooseCat == true {
            
            arrSelectCategory = self.arrSelectedCategory
            
        }
        else if isEditPost == true {
            
            let indexPath = IndexPath(row: 0, section: 1)
            
            let cell = tblViewAddPost.cellForRow(at: indexPath) as? SectionCellChoosecCat
            
            let catId = editDict["category_id"] as? String
            
            let arrCatId = catId?.components(separatedBy: ",")
            
            for i in 0..<(arrCatId?.count)! {
                
                let cat = CommonClass.sharedInstance.getCategoryName(strCategory: arrCatId![i], array: (AppDataManager.sharedInstance.arrCategories  as? [AnyObject])!)
                
                arrSelectCategory.append(cat)
                
            }
            
        }
        else {
            
            let selectedCategory = UserDefaults.standard.getSelectedCategory()
            
            arrSelectCategory = selectedCategory.components(separatedBy: ",")
        }
        
        for i in 0..<arrCategories.count {
            
            var dict = [String: Any]()
            
            var dictCatData = [String: Any]()
            
            var catName = String()
            
            var subCatName = String()
            
            if arrCategories[i]["parent_category"] as? String == "0" {
                
                let catId = arrCategories[i]["id"] as? String
                
                catName = CommonClass.sharedInstance.getCategoryName(strCategory: catId!, array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
                
                dictCatData["status"] = "0"
                
                dictCatData["child"] = []
                
                var arrChild = [AnyObject]()
                
                for a in 0..<arrCategories.count {
                    
                    if arrCategories[a]["parent_category"] as? String == catId {
                        
                        subCatName = (arrCategories[a]["name"] as? String)!
                        
                        let strImg = arrCategories[a]["image_url"] as! String
                        
                        var dictSubCat = [String: Any]()
                        
                        dictSubCat["subCat"] = subCatName
                        
                        dictSubCat["img_url"] = strImg
                        
                        for k in 0..<(arrSelectCategory.count) {
                            
                            if arrSelectCategory[k] == subCatName {
                                
                                dictSubCat["status"] = "1"
                                
                                dictCatData["status"] = "1"
                                
                                break
                            }
                            else{
                                
                                dictSubCat["status"] = "0"
                                
                            }
                            
                        }
                        
                        arrChild.append(dictSubCat as AnyObject)
                        
                        dictCatData["child"] = arrChild
                        
                    }
                }
                
                dict[catName] = dictCatData
                
                if isEditPost == true {
                    
                    editDict.removeAll()
                }
                
                dict.forEach { (k,v) in dictAllCategories[k] = v }
                
                arrAllCategories = [String] (dictAllCategories.keys) as [AnyObject]
                
            }
        }
        
        self.setCategoryData()
    }
    
    
    func validatePost() {
        
        let alert = UIAlertController(title: "",message: "All fields are mandatory",preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARKL Keyboard Notification
    func keyBoardNotify() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //button tapped on header cell
    @objc func sectionHeaderTapped(_ sender: UIButton) {
        
        if isScheduleSelected == true {
            
            isScheduleSelected = false
            
            viewForAllPicker.isHidden = true
            
            pickerSchedule.isHidden = true
            
            datePicker.isHidden = true
        }
        else {
            
            isScheduleSelected = true
        }
        
        toolBar.isHidden = true
        
        self.tblViewAddPost.reloadData()
        
    }
    
    @objc func btnOffersAction() {
        
        boolDateFlashPostPicker = true
        
        pickerSelectedIndex = 0
        
        self.isDatePicker = false
        
        self.strDay = ""
        
        self.selectedDay = ""
        
        self.selectedTime = ""
        
        viewForAllPicker.isHidden = false
        
        self.pickerSchedule.isHidden = false
        
        self.datePicker.isHidden = true
        
        arrPicker = arrOffersPicker
        
        toolBar.isHidden = false
        
        pickerSchedule.dataSource = self
        
        pickerSchedule.delegate = self
    }
    
    @objc func FlashPostActionHeader(sender: UIButton) {
        
        if !boolScheduleCell {
        
        boolScheduleCell = true
    }
        else{
            
            boolScheduleCell = false
        }
        
        tblViewAddPost.reloadData()
    }
    
    
    @objc func btnPersonsAction() {
        
        self.view.endEditing(true)
        
//        tblViewAddPost.reloadData()
        
        boolDateFlashPostPicker = true
        
        pickerSelectedIndex = 0
        
        self.isDatePicker = false
        
        self.strDay = ""
        
        self.selectedDay = ""
        
        self.selectedTime = ""
        
        viewForAllPicker.isHidden = false
        
        self.pickerSchedule.isHidden = false
        
        self.datePicker.isHidden = true
        
        arrPicker = arrPersonsPicker
        
        toolBar.isHidden = false
        
        pickerSchedule.dataSource = self
        
        pickerSchedule.delegate = self
        
//        pickerSchedule.relo
    }
    
    
    @objc func btnExpiryTimeAction() {

        self.view.endEditing(true)

//        tblViewAddPost.reloadData()
        
        boolDateFlashPostPicker = true
        
        viewForAllPicker.isHidden = false
        
        self.pickerSchedule.isHidden = true
        
        self.toolBar.isHidden = false
        
        self.datePicker.isHidden = false
        
        self.datePicker.backgroundColor = UIColor.white
        
        isTime = true
        
        isDatePicker = true
        
        datePicker.datePickerMode = .time
    }
    
    
    @objc func btnExpiryDateAction() {
        
        self.view.endEditing(true)

//        tblViewAddPost.reloadData()
        
        boolDateFlashPostPicker = true
        
        viewForAllPicker.isHidden = false
        
        self.selectedType = "3"
        
        pickerSchedule.isHidden = true
        
        datePicker.backgroundColor = UIColor.white
        
        isDatePicker = true
        
        datePicker.isHidden = false
        
        isTime = false
        
        toolBar.isHidden = false
        
        pickerSchedule.dataSource = self
        
        pickerSchedule.delegate = self
        
        datePicker.datePickerMode = .date
    }
}
