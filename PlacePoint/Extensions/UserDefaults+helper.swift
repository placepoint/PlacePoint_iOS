//
//  UserDefaults+helper.swift
//  Clip the Deal
//
//  "" on 06/12/17.
//  Copyright © 2017 "". All rights reserved.
//

import Foundation

extension UserDefaults{
    
    func setisAppAuthFirst(isFirst:Bool) -> Void {
        
        set(isFirst, forKey:"appAuth")
        synchronize()
    }
    
//    func oneSignalIdsent() -> Bool {
//
//        return bool(forKey: "oneSignalIdsent")
//    }
//
//
//    func setOneSignalId() {
//
//        set(true, forKey: "oneSignalIdsent")
//    }
    
    func getisAppAuthFirst() -> Bool {
        
        return bool(forKey: "appAuth")
    }
    
    
    func setisFirstlaunch(isFirst:Bool) -> Void {
        
        set(isFirst, forKey:"firstlaunch")
        synchronize()
    }
    
    
    func getisFirstlaunch() -> Bool {
        
        return bool(forKey: "firstlaunch")
    }
    
    func setisFirstTutorialBusiness(isFirst:Bool) -> Void {
        
        set(isFirst, forKey:"tutorialBusiness")
        synchronize()
    }
    
    
    func getFirstTutorialBusiness() -> Bool {
        
        return bool(forKey: "tutorialBusiness")
    }
    
    func setisFirstTutorialLive(isFirst:Bool) -> Void {
        
        set(isFirst, forKey:"tutorialLive")
        synchronize()
    }
    
    
    func getFirstTutorialLive() -> Bool {
        
        return bool(forKey: "tutorialLive")
    }
    
    func setisFirstTutorialPost(isFirst:Bool) -> Void {
        
        set(isFirst, forKey:"tutorialPost")
        synchronize()
    }
    
    
    func getFirstTutorialPost() -> Bool {
        
        return bool(forKey: "tutorialPost")
    }
    
    func setupAuthCode(auth:String) -> Void {
        
        set(auth, forKey:"authCode")
        synchronize()
    }
    
    
    func getAuthCode() -> String {
        
        let authCode =  string(forKey:"authCode")
        return authCode!
    }
    
    func setApplyToAll(isApply:Bool) -> Void {
        
        set(isApply, forKey:"applyToAll")
        synchronize()
    }
    
    
    func getApplyToAll() -> Bool {
        
        return bool(forKey: "applyToAll")
    }
    
    func setBusinessUserType(userType:String) -> Void {
        
        set(userType, forKey:"userType")
        synchronize()
    }
    
    
    func getBusinessUserType() -> String{
        
        return string(forKey: "userType")!
    }
    
    func setUpdateBusUserType(userType:String) -> Void {
        
        set(userType, forKey:"updateUserType")
        synchronize()
    }
    
    
    func getUpdateBusUserType() -> String{
        
        return string(forKey: "updateUserType")!
    }
    
    func setTownChanged(boolResgister: Bool) -> Void {

        set(boolResgister, forKey:"townChanged")
        synchronize()
    }
    
    
        func getTownChanged() -> Bool{
    
            return bool(forKey: "townChanged")
        }
    
//    func getOnesignalSentToApi() -> Bool {
//
//        return bool(forKey: "sentToApi")
//    }
//
//    func setOnesignalSentToApi(bool: Bool) -> Void {
//
//        set(bool, forKey: "sentToApi")
//        synchronize()
//    }
   
    
    
    func setIsLoggedIn(value:Bool) -> Void{
        
        set(value, forKey: "IsLoggedIn")
        synchronize()
    }
    
    
    func getIsLoggedIn () -> Bool {
        
        return  bool(forKey: "IsLoggedIn")
    }
    
    
    func setSelectedTownAndCategories(value:Bool) -> Void{
        
        set(value, forKey: "TownAndCategories")
        synchronize()
    }
    
    
    func getSelectedTownAndCategories() -> Bool {
        
        return  bool(forKey: "TownAndCategories")
    }
   
    
    func setSelectedTown(value: String) -> Void {
        
        set(value, forKey: "townName")
        synchronize()
    }
    
    
    func getSelectedTown() -> String {
        
        return  string(forKey: "townName")!
    }
    
    func setAllCatName(value: String) -> Void {
        
        set(value, forKey: "setAllCatName")
        synchronize()
    }
    
    
    func getAllCatName() -> String {
        
        return  string(forKey: "setAllCatName")!
    }
    
    
    func setSelectedCat(value: String) -> Void {
        
        set(value, forKey: "selectedCategory")
        synchronize()
    }
    
    
    func getSelectedCat() -> String {
        
        return  string(forKey: "selectedCategory")!
    }
    
    func kDeviceIdOnesignal(kDeviceId:String) -> Void {
        
        set(kDeviceId, forKey:"kDeviceId")
    }
    
    func getkDeviceId() -> String {
        
        return string(forKey:"kDeviceId")!
    }
    
    func SetoneSignalSentToAPi(kDeviceIdSentToApi:Bool) -> Void {
        
        set(kDeviceIdSentToApi, forKey:"kDeviceIdSentToApi")
    }
    
    func GetoneSignalSentToAPi() -> Bool {
        
        return bool(forKey: "kDeviceIdSentToApi")
    }
    
    func setCatSelect(value: String) -> Void {
        
        set(value, forKey: "catSelected")
        synchronize()
    }
    
    
    func getCatSelect() -> String {
        
        return  string(forKey: "catSelected")!
    }
    
    
    func setCatOfBusiness(value: String) -> Void {
        
        set(value, forKey: "businessCategory")
        synchronize()
    }
    
    
    func getCatOfBusiness() -> String {
        
        return  string(forKey: "businessCategory")!
    }
    
    
    func selectedCategory(value:String) -> Void{
        
        set(value, forKey: "category")
        synchronize()
    }
    
    
    func getSelectedCategory() -> String {
        
        return  string(forKey: "category")!
    }
    
    func selectedBusCategory(value:String) -> Void{
        
        set(value, forKey: "businessCategory")
        synchronize()
    }
    
    
    func getBusSelectedCategory() -> String {
        
        return  string(forKey: "businessCategory")!
    }
    
    
    
    func setTown(value:String) -> Void{
        
        set(value, forKey: "town")
        synchronize()
    }
    
    
    func getTown() -> String {
        
        return  string(forKey: "town")!
    }
    
    
    func setBusinessLogin(value:Bool) -> Void{
        
        set(value, forKey: "BusinessLogin")
        synchronize()
    }
    
    
    func getBusinessLogin() -> Bool {
        
        return  bool(forKey: "BusinessLogin")
    }
    
    
    func setBusinessProfile(value:Bool) -> Void{
        
        set(value, forKey: "BusinessProfile")
        synchronize()
    }
    
    
    func getBusinessProfile() -> Bool {
        
        return  bool(forKey: "BusinessProfile")
    }
    
    func setArrCategories(value: [AnyObject]) -> Void {
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        set(encodedData, forKey: "arrCat")
        
        synchronize()
        
    }
    
    func getArrCategories() -> [AnyObject]{
        
        let decoded = object(forKey: "arrCat") as! Data
        
        let decodedArr = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [AnyObject]
        
        return decodedArr
        
    }
    
    func setArrTown(value: [AnyObject]) -> Void {
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        set(encodedData, forKey: "arrTown")
        synchronize()
        
    }
    
    func getArrTown() -> [AnyObject]{
        
        let decoded  = object(forKey: "arrTown") as! Data
        
        let decodedArr = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [AnyObject]
        
        return decodedArr
        
    }
    
    
    func setBusinessName(value:String) -> Void{
        
        set(value, forKey: "businessName")
        synchronize()
    }
    
    
    func getBusinessName() -> String {
        
        return  string(forKey: "businessName")!
    }
    
    
    func setBusinessStatus(value:String) -> Void{
        
        set(value, forKey: "businessStatus")
        synchronize()
    }
    
    
    func getBusinessStatus() -> String {
        
        return  string(forKey: "businessStatus")!
    }
    
    
    func setBusinessId(value:String) -> Void{
        
        set(value, forKey: "businessId")
        synchronize()
    }
    
    
    func getBusinessId() -> String {
        
        return  string(forKey: "businessId")!
    }
    
    
    func setPassword(value: String) -> Void {
        
        set(value, forKey: "password")
        synchronize()
    }
    
    
    func getPassword() -> String {
        
        return  string(forKey: "password")!
    }
    
    func setEmail(value: String) -> Void {
        
        set(value, forKey: "email")
        synchronize()
    }
    
    
    func getEmail() -> String {
        
        return string(forKey: "email")!
    }
    
    
    func setfirstTimeLoginPopUp(value:Bool) -> Void{
        
        set(value, forKey: "first_login")
        synchronize()
    }
    
    
    func getfirstTimeLoginPopUp() -> Bool {
        
        return  bool(forKey: "first_login")
    }
    
    func saveArrCatFlashDeals(value: [AnyObject]) -> Void {
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        set(encodedData, forKey: "arrCategorySave")
        synchronize()
        
    }
    
    func fetchArrCatFlashDeals() -> [AnyObject]{
        
        let decoded  = object(forKey: "arrCategorySave") as! Data
        
        let decodedArr = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [AnyObject]
        
        return decodedArr
        
    }
    
    
    func setMultipleTownsForFlashDeal(value: [AnyObject]) -> Void {
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        set(encodedData, forKey: "FTowns")
        synchronize()
        
    }
    
    func getMultipleTownsForFlashDeal() -> [AnyObject]{
        
        let decoded  = object(forKey: "FTowns") as! Data
        
        let decodedArr = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [AnyObject]
        
        return decodedArr
        
    }
    
    
    func setMultipleCatForFlashDeal(value: [AnyObject]) -> Void {
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        set(encodedData, forKey: "FCategories")
        synchronize()
        
    }
    
    func getMultipleCatForFlashDeal() -> [AnyObject]{
        
        let decoded  = object(forKey: "FCategories") as! Data
        
        let decodedArr = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [AnyObject]
        
        return decodedArr
        
    }
    
    
}
