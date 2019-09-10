//
//  BusinessVC.swift
//  PlacePoint
//
//  Created by Mac on 05/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MMDrawerController
import SVProgressHUD
import CoreLocation
import Kingfisher
import UIImageCropper

class BusinessVC: UIViewController, SelectedCategories {
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var tblBusinessDetails: UITableView!
    
    var isSavedPressed = false
    
    var dropDownViewObj: ViewDropDownList!
    
    var headerView = BusinessTopView()
    
    var arrHours = [AnyObject]()
    
    var arrOpeningTime = [AnyObject]()
    
    var footerView = BusinessFooterView()
    
    var selectedDayToCheckOpen = Int()
    
    var arrDatePick = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    var arrPicker = [String]()
    
    var arrTown = [String]()
    
    var arrCat = [String]()
    
    var selectedItem: String?
    
    var selectedDropIndex: Int?
    
    var selectedImages: [UIImage] = []
    
    var strStartTimeFrom = String()
    
    var strEndTimeTo = String()
    
    var strCloseTimeFrom = String()
    
    var strCloseTimeTo = String()
    
    var selectedDay: Int? = 0
    
    var selectCloseDay = Bool()
    
    var selectCloseHours = Bool()
    
    var packageEndTime = String()
    
    var packageName = String()
    
    private let picker = UIImagePickerController()
    
    private let cropper = UIImageCropper(cropRatio: 2/1)
    
    var isGalleryFirstSelected: Bool = false
    
    var closingHoursString = String()
    
    var pickerTextFld = UITextField()
    
    var latitude = CLLocationDegrees()
    
    var longitude = CLLocationDegrees()
    
    var dictCreatedBusiness = [String: Any]()
    
    var selectedImage = UIImage()
    
    var isFirstTime: Bool = true
    
    var popUpPremiumView = PopUpPremium()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if UIScreen.main.bounds.size.height == 812 {
            self.tblBusinessDetails.frame.origin.y = 45
           self.tblBusinessDetails.frame.size.height = (self.tblBusinessDetails.frame.height - 30)
        }
        else {
//            self.tblBusinessDetails.frame.origin.y = 45
//           self.tblBusinessDetails.frame.size.height = self.tblBusinessDetails.frame.height
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUpView), name: NSNotification.Name(rawValue: "setupView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setView), name: Notification.Name("afterUpgarde"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setImageData), name: NSNotification.Name(rawValue: "setImageData"), object: nil)
        
        
        let nib = UINib(nibName: "BusinessContentTableCell", bundle: nil)
        
        self.tblBusinessDetails.register(nib, forCellReuseIdentifier: "BusinessContentTableCell")
        
        headerView = (Bundle.main.loadNibNamed("BusinessTopView", owner: nil, options: nil)?[0] as? BusinessTopView)!
        
        footerView = (Bundle.main.loadNibNamed("BusinessFooterView", owner: nil, options: nil)?[0] as? BusinessFooterView)!
        
        for _ in 1..<8 {
            
            let dict = self.setDefaultTime()
            
            arrHours.append(dict as AnyObject)
            
        }
        
        self.setData()
        
        cropper.delegate = self
        
        self.keyBoardNotify()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.isSavedPressed = false
        
        if UIScreen.main.bounds.size.height == 812 {
            self.tblBusinessDetails.frame.origin.y = 45
          self.tblBusinessDetails.frame.size.height = self.tblBusinessDetails.frame.height - 30
        }
        else {
//            self.tblBusinessDetails.frame.origin.y = 45
            print(self.tblBusinessDetails.frame.size.height)
           self.tblBusinessDetails.frame.size.height = 505
        }
        
        if savedImages.count > 0 {
            
            for i in 0..<savedImages.count {
                
                arrBusinessImages.append(savedImages[i] as AnyObject)
                
            }
            
            savedImages.removeAll()
            
            tblBusinessDetails.dataSource = self
            
            tblBusinessDetails.delegate = self
            
            tblBusinessDetails.reloadData()
            
        }
        else if savedImages.count == 0 {
            
            tblBusinessDetails.dataSource = self
            
            tblBusinessDetails.delegate = self
            
            tblBusinessDetails.reloadData()
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.first != nil{
            
            popUpPremiumView.removeFromSuperview()
            
            tblBusinessDetails.isHidden = false
            
        }
        
    }
    
    
    @objc func setView() {
        
        self.tblBusinessDetails.isHidden = false
        
        self.setUpTableView()
        
        tblBusinessDetails.dataSource = self
        
        tblBusinessDetails.delegate = self
        
        tblBusinessDetails.reloadData()
        
    }
    
    
    @objc func setImageData() {
        
        self.isSavedPressed = false
        
        if savedImages.count > 0 {
            
            for i in 0..<savedImages.count {
                
                arrBusinessImages.append(savedImages[i] as AnyObject)
                
            }
            
            savedImages.removeAll()
            
            tblBusinessDetails.dataSource = self
            
            tblBusinessDetails.delegate = self
            
            tblBusinessDetails.reloadData()
            
        }
            
        else if savedImages.count == 0 {
            
            tblBusinessDetails.dataSource = self
            
            tblBusinessDetails.delegate = self
            
            tblBusinessDetails.reloadData()
            
        }
        
    }
    
    
    @objc func setUpView() {
        
        let arrCategories = AppDataManager.sharedInstance.arrCategories as [AnyObject]
        
        let selectedCategory = footerView.txtFieldCategory.text
        
        let arrSelectedCategory = selectedCategory?.components(separatedBy: ",")
        
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
                        
                        
                        for k in 0..<(arrSelectedCategory?.count)! {
                            
                            if arrSelectedCategory![k] == subCatName {
                                
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
                
                dict.forEach { (k,v) in dictAllCategories[k] = v }
                
                arrAllCategories = [String] (dictAllCategories.keys) as [AnyObject]
            }
        }
    }
    
    
    func getDayFromIndex(index: Int) -> String{
        
        if index == 0 {
            
            return "Monday"
        }
        else if index == 1 {
            
            return "Tuesday"
        }
        else if index == 2 {
            
            return "Wednesday"
        }
        else if index == 3 {
            
            return "Thursday"
        }
        else if index == 4 {
            
            return "Friday"
        }
        else if index == 5 {
            
            return "Saturday"
        }
        else {
            
            return "Sunday"
        }
        
    }
    
    
    func setDefaultTime() -> [String: String] {
        
        var dictWeekDetails = [String: String]()
        
        dictWeekDetails["startFrom"] = "12:00 AM"
        
        dictWeekDetails["startTo"] = "12:00 AM"
        
        dictWeekDetails["closeFrom"] = "12:00 AM"
        
        dictWeekDetails["closeTo"] = "12:00 AM"
        
        dictWeekDetails["status"] = "false"
        
        dictWeekDetails["closeStatus"] = "false"
        
        return dictWeekDetails
    }
    
    
    func setData() {
        
        let businessId =   UserDefaults.standard.getBusinessId()
        
        let businessStatus = UserDefaults.standard.getBusinessStatus()
        
        let businessName = UserDefaults.standard.getBusinessName()
        
        if businessStatus == "true" {
            
            self.apiGetDetails(strBusinessId: businessId)
            
        }
        else {
            
            self.setUpTableView()
            
            self.selectWeekDay(tag: 0)
            
        }
    }
    
    
    func convertToDictionary(text: String) -> [AnyObject]? {
        
        if let data = text.data(using: .utf8) {
            
            do {
                
                return try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    
    // Set PickerView
    func setUpPickerView() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        pickerTextFld.inputView = pickerView
        
        self.addToolBar(textField: pickerTextFld)
        
    }
    
    
    // Add ToolBar
    func addToolBar(textField: UITextField) {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        
        toolBar.isTranslucent = true
        
        toolBar.barTintColor = UIColor.themeColor()
        
        toolBar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePressed))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style:
            UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton,spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        
        toolBar.sizeToFit()
        
        textField.delegate = self
        
        textField.inputAccessoryView = toolBar
    }
    
    
    //MARK: - Setup TableView
    func setUpTableView() {
        
        headerView.delegate = self
        
        headerView.textFieldBusinessName.delegate = self
        
        headerView.textFieldBusinessName.tag = 101
        
        headerView.setData(dict: dictCreatedBusiness)
        
        self.tblBusinessDetails.tableHeaderView = headerView
        
        if dictCreatedBusiness.count != 0 {
            
            footerView.setData(dict: dictCreatedBusiness)
            
            self.latitude =  ((dictCreatedBusiness["lat"] as? NSString)?.doubleValue)!
            
            self.longitude =  ((dictCreatedBusiness["long"] as? NSString)?.doubleValue)!
            
        }
        
        let applyToAll: Bool = UserDefaults.standard.getApplyToAll()
        
        if applyToAll == true {
            
            footerView.btnApplyAll.setImage(#imageLiteral(resourceName: "checkApplyAll"), for:.normal)
            
            footerView.btnApplyAll.tag = 201
            
        }
        else {
            
            footerView.btnApplyAll.setImage(#imageLiteral(resourceName: "checkApplyAll"), for:.normal)
            
            footerView.btnApplyAll.tag = 200
        }
        
//        footerView.txtFldPhoneNumber.delegate = self
        
        let userType = UserDefaults.standard.getBusinessUserType()
        
        if userType == "Free" {
            
            footerView.lblPackageName.text = "Free Package"
            
            footerView.vwChange.isHidden = false
            
        }
        else if userType == "Premium" {
            
            footerView.lblPackageName.text = "Premium Package"
            
            footerView.vwChange.isHidden = true
            
        }
        else if userType == "Standard" {
            
            footerView.lblPackageName.text = "Standard Package"
            
            footerView.vwChange.isHidden = false
            
        }
        else {
            
            footerView.lblPackageName.text = "Admin"
            
            footerView.vwChange.isHidden = true
        }
        
//        footerView.txtFldPhoneNumber.tag = 102
        
        footerView.txtFieldTown.delegate = self
        
        footerView.txtFieldTown.tag = 1
        
        footerView.txtFieldCategory.delegate = self
        
        footerView.txtFieldCategory.tag = 2
        
        footerView.btnSave.addTarget(self, action: #selector(savePressed(button:)), for: .touchUpInside)
        
        footerView.delegate = self
        
        self.tblBusinessDetails.tableFooterView = footerView
        
        tblBusinessDetails.delegate = self
        
        tblBusinessDetails.dataSource = self
        
        tblBusinessDetails.estimatedRowHeight = 50
        
        tblBusinessDetails.rowHeight = UITableViewAutomaticDimension
        
        
        AppDataManager.sharedInstance.getAppData(completionHandler: { (dictResponse) in
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "true" {
                
                if self.arrTown.count == 0 {
                    
                    let arrNotSortedTown = dictResponse["location"] as? NSArray
                    
                    let descriptorTown: NSSortDescriptor = NSSortDescriptor(key: "townname", ascending: true)
                    
                    let sortedTown: NSArray = arrNotSortedTown!.sortedArray(using: [descriptorTown]) as NSArray
                    
                    self.arrTown = (sortedTown.value(forKey: "townname") as? [String])!
                }
            }
            else {
                
                print("No Data")
            }
        }, failure: { (errorCode) in
            
            return
        })
        
        arrCat = CommonClass.sharedInstance.arrCategories(array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
        
    }
    
    
    //MARK: - SetUp Navigation
    func setUpNavigation() {
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.themeColor()
        
        navigationItem.navTitle(title: "Business Profile")
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let leftBarButtonItem = UIBarButtonItem(image:  #imageLiteral(resourceName: "menu"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(menuButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    
    
    // MenuButton Tapped
    @objc func menuButtonTapped() {
        
        self.view.endEditing(true)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate?.centerContainer?.toggle(MMDrawerSide.left ,  animated: true, completion: nil)
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnCancel(_ sender: UIButton) {
        
        pickerView.isHidden = true
        
        toolBar.isHidden = true
    }
    
    
    func checkIfClosed(startTime: String, endTime: String, closeTimeFrom: String, closeTimeTo: String) {
        
        if startTime != "12:00 AM" && endTime != "12:00 AM" && closeTimeFrom != "12:00 AM" && closeTimeTo != "12:00 AM" {
            
            strCloseTimeFrom = closeTimeFrom
            
            strCloseTimeTo = closeTimeTo
            
            strStartTimeFrom = startTime
            
            strEndTimeTo = endTime
            
            self.setHoursData()
            
        }
        else if closeTimeFrom == "" && closeTimeTo == "" {
            
            strCloseTimeFrom = "12:00 AM"
            
            strCloseTimeTo = "12:00 AM"
            
            strStartTimeFrom = startTime
            
            strEndTimeTo = endTime
            
            self.setHoursData()
            
        }
        else if startTime == "" && endTime == "" && closeTimeFrom == "" && closeTimeTo == "" {
            
            strCloseTimeFrom = "12:00 AM"
            
            strCloseTimeTo = "12:00 AM"
            
            strStartTimeFrom = "12:00 AM"
            
            strEndTimeTo = "12:00 AM"
            
            self.setHoursData()
        }
    }
    
    
    // CancelButton Pressed
    @objc func cancelPressed() {
        
        view.endEditing(true)
        
    }
    
    
    // DoneButton Pressed
    @objc func donePressed() {
        
        if selectedDropIndex == 1 {
            
            footerView.txtFieldTown.text = selectedItem
            
            print(UserDefaults.standard.getTown())
            
            print(AppDataManager.sharedInstance.arrTowns)
            
            let strLocationId = CommonClass.sharedInstance.getLocationId(strLocation: footerView.txtFieldTown.text!, array: (AppDataManager.sharedInstance.arrTowns as [AnyObject]))
            
            UserDefaults.standard.setSelectedTown(value: footerView.txtFieldTown.text!)
            
            dictCreatedBusiness["town_id"] = strLocationId
            
        }
        else if selectedDropIndex == 2 {
            
            footerView.txtFieldCategory.text = selectedItem
            
            let strCategoryId = CommonClass.sharedInstance.getCategoryId(strCategory: footerView.txtFieldCategory.text!, array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
            
            dictCreatedBusiness["category_id"] = strCategoryId
            
            UserDefaults.standard.selectedCategory(value: footerView.txtFieldCategory.text!)
            
        }
        
        view.endEditing(true)
    }
    
    
    // MARK: - CheckForClosingHours
    func checkforClosingHours() -> Bool {
        
        for i in 0...6 {
            
            if (arrHours[i]["status"] as? String == "true") {
                
                return true
            }
            else if ((arrHours[i]["closeStatus"] as? String == "false") &&
                (arrHours[i]["status"] as? String == "false") && (arrHours[i]["closeFrom"] as? String == "12:00 AM") && (arrHours[i]["closeTo"] as? String == "12:00 AM")) {
                
                self.selectedDayToCheckOpen = i
                
                return false
                
            }
            else if (arrHours[i]["status"] as? String == "false") &&
                (arrHours[i]["closeStatus"] as? String == "false") && (arrHours[i]["closeFrom"] as? String == arrHours[i]["closeTo"] as? String) {
                
                self.selectedDayToCheckOpen = i
                
                return false
                
            }
        }
        return true
    }
    
    
    // MARK: - CheckForOpeningHours
    func checkforOpeningHours() -> Bool {
        
        for i in 0...6 {
            
            if ((arrHours[i]["status"] as? String == "true") &&  (arrHours[i]["closeStatus"] as? String == "false") && (arrHours[i]["startFrom"] as? String == "12:00 AM") && (arrHours[i]["startTo"] as? String == "12:00 AM")) {
                
                self.selectedDayToCheckOpen = i
                
                return false
            }
            else if (arrHours[i]["status"] as? String == "false") &&
                (arrHours[i]["closeStatus"] as? String == "true") && (arrHours[i]["startFrom"] as? String == arrHours[i]["startTo"] as? String) {
                
                self.selectedDayToCheckOpen = i
                
                return false
                
            }
            else if (arrHours[i]["status"] as? String == "false") &&
                (arrHours[i]["closeStatus"] as? String == "false") && (arrHours[i]["startFrom"] as? String == arrHours[i]["startTo"] as? String) {
                
                self.selectedDayToCheckOpen = i
                
                return false
                
            }
            else if ((arrHours[i]["status"] as? String == "false") &&  (arrHours[i]["closeStatus"] as? String == "false") && (arrHours[i]["startFrom"] as? String == "12:00 AM") && (arrHours[i]["startTo"] as? String == "12:00 AM")) {
                
                self.selectedDayToCheckOpen = i
                
                return false
            }
        }
        
        return true
    }
    
    
    // saveButton Pressed
    @objc func savePressed(button: UIButton) {
        
        arrUrlSavedImages.removeAll()
        
        arrNewSavedImages.removeAll()
        
        for i in 0..<arrBusinessImages.count {
            
            let strHttp = NSString(format: "%@", (arrBusinessImages[i] as! CVarArg))
            
            if strHttp.contains("https://") {
                
                arrUrlSavedImages.append(strHttp)
                
            }
            else {
                
                arrNewSavedImages.append(arrBusinessImages[i] as! UIImage)
                
            }
        }
        
        var strCount: Int? = 0
        
        strCount = arrUrlSavedImages.count + arrNewSavedImages.count
        
        self.apiBusinessDetails()
        
    }
    
    
    func category(selectedCat: [String]) {
        
        footerView.txtFieldCategory.text = selectedCat.joined(separator: ",")
        
        UserDefaults.standard.selectedBusCategory(value: footerView.txtFieldCategory.text!)
        
    }
    
}


//MARK: - TableView Delegate and Data Source
extension BusinessVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessContentTableCell", for: indexPath) as? BusinessContentTableCell else {
            fatalError()
        }
        
        cell.dictCreatedBusinessImages = dictCreatedBusiness
        
        cell.textFieldUrl.delegate = self
        
        cell.textFieldUrl.isHidden = true
        
        cell.textFieldUrl.tag = 1000
        
        cell.delegate = self
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.setData(dict: dictCreatedBusiness)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isCollectionHaveImage == true && isYoutubeBtnSelected == true {
            
            return 230
        }
        else if noImage == true && isYoutubeBtnSelected == true {
            
            return 120
        }
        else if noImage == true {
            
            return 50
        }
        else if isGalleryFirstSelected == true {
            
            return 160
        }
            
        else if isYoutubeBtnSelected == true {
            
            return 120
        }
        else if isCollectionHaveImage == true {
            
            return 200
        }
        else {
            return 50
        }
    }
}


extension BusinessVC {
    
    func showActionSheetForImageCropper(vc: UIViewController) {
        
        cropper.picker = picker
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        cropper.cancelButtonText = "Cancel"
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { _ in
            
            self.picker.sourceType = .camera
            
            self.picker.modalPresentationStyle = .custom
            
            self.present(self.picker, animated: true, completion: nil)
        })
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: .default) { _ in
            
            self.picker.sourceType = .photoLibrary
            
            self.picker.modalPresentationStyle = .custom
            
            self.present(self.picker, animated: true, completion: nil)
            
        })
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
        }))
        
        self.picker.modalPresentationStyle = .custom
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}


// ImageCropperProtocol
extension BusinessVC: UIImageCropperProtocol {
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        
        headerView.businessImage.image = croppedImage
        
        headerView.businessImage.contentMode = .scaleToFill
        
        headerView.businessImage.clipsToBounds = true
        
    }
    
    
    func didCancel() {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}

