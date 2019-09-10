//
//  HomeVC.swift
//  PlacePoint
//
//  Created by MRoot on 06/10/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, OpenLink, ExpandableLabelDelegate{
    
    @IBOutlet weak var viewWelcome: UIView!
    
    var homeTutorialView = HomeTutorialView()
    
    @IBOutlet weak var tblViewFlashposts: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var arrFlashPosts = [AnyObject]()
    
    var states = [Bool]()
    
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpNavigation()
        
        let checkFirstLaunch = UserDefaults.standard.getisFirstlaunch()
        
        if checkFirstLaunch == true {
            
            let window = appDelegate.window
            
            homeTutorialView = Bundle.main.loadNibNamed("HomeTutorialView", owner: nil, options: nil)?[0] as! HomeTutorialView
            
            homeTutorialView.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
            
            window?.addSubview(homeTutorialView)
        }
        
        setUpTableView()
        
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        
        refreshControl.tintColor = UIColor.themeColor()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        CallApiFlashPost()
    }
    
    // MARK:- SetUp tableView
    func setUpTableView() {
        
        let nib = UINib(nibName: "FieldTableViewCell", bundle: nil)
        
        self.tblViewFlashposts.register(nib, forCellReuseIdentifier: "FieldTableViewCell")
        
        self.tblViewFlashposts.dataSource = self
        
        self.tblViewFlashposts.delegate = self
        
        tblViewFlashposts.estimatedRowHeight = 200
        
        tblViewFlashposts.rowHeight = UITableViewAutomaticDimension
        
//        tblViewFlashposts.refreshControl = refreshControl
//
//        tblViewFlashposts.addSubview(refreshControl)
    }
    
    
    
    // MARK: - Set Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Homepage")
    }
   
    
    func CallApiFlashPost() {
        
        let townName = UserDefaults.standard.getTown()
        
        print(townName)
        
        print(AppDataManager.sharedInstance.arrTowns)
        
        let arrTown = UserDefaults.standard.getArrTown()
      
        let strTownId = CommonClass.sharedInstance.getLocationId(strLocation: townName, array: arrTown)
        
        
//        let isKeyExists = CommonClass.sharedInstance.keyAlreadyExists(Key: "selectedCategory")
        
//        if isKeyExists == true {
        
//            let catName = UserDefaults.standard.getSelectedCat()
//             let arrCat = UserDefaults.standard.getArrCategories()
//            let categoryID = CommonClass.sharedInstance.getCategoryArrayId(strCategory: [catName], array: arrCat)
            
            SVProgressHUD.show()
            
            self.view.isUserInteractionEnabled = false
            
            self.view.endEditing(true)
            
            var dictParams = [String: Any]()
            
            dictParams["auth_code"] = UserDefaults.standard.getAuthCode()
            
            dictParams["town_id"] = strTownId
            
            dictParams["category_id"] = ""
        
            dictParams["limit"] = "100"
            
            dictParams["page"] = "0"
            
            print(dictParams)
            
            HomeVCManager.sharedInstance.dictParams = dictParams
        
            HomeVCManager.sharedInstance.getHomeFlashPost(completionHandler: { (response) in
                
                print(response)
                
                let strStatus = response["status"] as? String
                
                if strStatus == "true" {
 
                DispatchQueue.main.async {
                    
                    let arrPostsData = response["data"] as? [AnyObject]
                    
                    if (arrPostsData?.count)! > 0 {
                        
                        self.arrFlashPosts = arrPostsData!
                        
                        self.states = [Bool](repeating: true, count: self.arrFlashPosts.count)
                        
                        self.tblViewFlashposts.reloadData()
                        self.view.isUserInteractionEnabled = true

                    }

                    SVProgressHUD.dismiss()
                }
           }
                
                
                let arrCategory = response["category"] as? [AnyObject]
                UserDefaults.standard.setArrCategories(value: arrCategory!)
                AppDataManager.sharedInstance.arrCategories = arrCategory!
                
                let arrLocation = response["location"] as? [AnyObject]
                UserDefaults.standard.setArrTown(value: arrLocation!)
                AppDataManager.sharedInstance.arrTowns = arrLocation!
                
                
            }, failure: { (strError :String) in
                
                print(strError)
            })
            
//
//        }
//
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrFlashPosts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentSource = preparedSources(index: indexPath)[0]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FieldTableViewCell") as? FieldTableViewCell
        
        cell?.viewClaimButton.isHidden = false
        
        cell?.viewTopFlashOffer.isHidden = false
        
       
        
            cell?.imgViewShare.image = UIImage(named: "flashIcon")

        
        if arrFlashPosts.count > 0 {
            
            let strVideoLink = arrFlashPosts[indexPath.row].value(forKey: "video_link") as? String
            
            if strVideoLink != "" {
                
                cell?.viewYoutube.isHidden = false
                
                cell?.imgYouTubeThumNail.isHidden = false
                
                cell?.btnOpenUrl.tag = indexPath.row
                
                let url = self.createThumbnailUrlVideoFromFileURL(videoURL: strVideoLink!)
                
                cell?.imgYouTubeThumNail.kf.indicatorType = .activity
                
                (cell?.imgYouTubeThumNail.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
                
                cell?.imgYouTubeThumNail.kf.setImage(with: url,
                                                     placeholder:#imageLiteral(resourceName: "placeholder"),
                                                     options: [.transition(ImageTransition.fade(1))],
                                                     progressBlock: { receivedSize, totalSize in
                },
                                                     completionHandler: { image, error, cacheType, imageURL in
                })
                
            }
            else {
                
                cell?.viewYoutube.isHidden = true
                
                cell?.imgYouTubeThumNail.isHidden = true
            }
            
            cell?.btnMore.isHidden = false
            
            cell?.delegate = self
            
            cell?.btnMore.tag = indexPath.row
            
            cell?.lblDescription.setLessLinkWith(lessLink: " ...less", attributes: [.foregroundColor: UIColor.themeColor()], position: currentSource.textAlignment)
            
            cell?.layoutIfNeeded()
            
            cell?.lblDescription.delegate = self
            
            cell?.lblDescription.shouldCollapse = true
            
            cell?.lblDescription.textReplacementType = currentSource.textReplacementType
            
            cell?.lblDescription.numberOfLines = currentSource.numberOfLines
            
            cell?.lblDescription.collapsed = states[indexPath.row]
            
            cell?.lblDescription.text = currentSource.text
            
            cell?.setData(arr: arrFlashPosts, index: indexPath.row)
            
            cell?.selectionStyle = .none
            
            if arrFlashPosts.count > 0 {
                
                cell?.reloadCollectionView(dict: (arrFlashPosts[indexPath.row] as! NSDictionary))
            }
            
        }
        
        return (cell)!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isBusinessDetail == false {
            
            let feedDetailsVC = BuisnessShowFeedVc(nibName: "BuisnessShowFeedVc", bundle: nil)
            
            isBusinessDetail = true
            
            isShowBusinessDetail = true
            
            let dict = arrFlashPosts[indexPath.row] as? NSDictionary
            
            let strBusId =   dict!["bussness_id"] as! String
            
            let strBusinessName = dict!["business_name"] as? String
            
            businessName = strBusinessName!
            
            if isChooseCategoryVc == true {
                
                let category = UserDefaults.standard.getSelectedCat()
                
                selectedCategory = category
                
            }
            
            strBusinessId = strBusId
            
            self.navigationController?.pushViewController(feedDetailsVC, animated: true)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Exapndable Label
    func preparedSources(index: IndexPath) -> [(text: String, textReplacementType: ExpandableLabel.TextReplacementType, numberOfLines: Int, textAlignment: NSTextAlignment)] {
        
        return [(loremIpsumText(index: index), .word, 6, .right)]
    }
    
    
    func loremIpsumText(index: IndexPath) -> String {
        
        if index.row >= arrFlashPosts.count {
            
            return ""
            
        }
        else {
            
            return (arrFlashPosts[index.row]).value(forKey: "description") as! String
        }
    }
    
    
    func btnMore(index: Int) {
        
        let alert = UIAlertController(title: "Alert",message: "You are about to share an image to Facebook. Facebook does not allow us to send the text from the image automatically. We have copied the text from the post to the clipboard for your convenience. If you would like to add the text to the image please paste it into the comment section on the next section when sharing the post.",preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
            
            let indexPath = IndexPath(row: index, section: 0)
            
            let cell = self.tblViewFlashposts.cellForRow(at: indexPath) as? FieldTableViewCell
            
            let textToShare = cell?.lblDescription.text
            
            let dict = self.arrFlashPosts[indexPath.row] as? NSDictionary
            
            let imgUrl = dict!["image_url"] as? String
            
            if let myWebsite = NSURL(string: imgUrl!) {
                
                let objectsToShare = [textToShare, myWebsite] as [Any]
                
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityVC.popoverPresentationController?.sourceView = self.view
                
                self.present(activityVC, animated: true, completion: nil)
            }
            
            let text = dict!["description"] as? String
            
            UIPasteboard.general.string = text
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openUrlLink(videoUrl: String) {
        
        self.openUrl(strVideoUrl: videoUrl)
    }
    
    
    func btnFlash(index: Int) {
        
//        let vc = RedeemVC(nibName: "RedeemVC", bundle: nil)
//
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { ($0.name == "v") })?.value
    }
    
    
    func createThumbnailUrlVideoFromFileURL(videoURL: String) -> URL? {
        
        let videoId = self.getYoutubeId(youtubeUrl: videoURL)
        
        var youtubeLink = String()
        
        if let video_id = videoId {
            
            youtubeLink = "http://img.youtube.com/vi/\(video_id)/0.jpg"
        }
        
        let urlYoutube = URL(string: youtubeLink)
        
        return urlYoutube
        
    }
    
    
    func openUrl(strVideoUrl: String) {
        
        guard let url = URL(string: strVideoUrl) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        else {
            
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func willExpandLabel(_ label: ExpandableLabel) {
        
        tblViewFlashposts.beginUpdates()
    }
    
    
    func didExpandLabel(_ label: ExpandableLabel) {
        
        let point = label.convert(CGPoint.zero, to: tblViewFlashposts)
        
        if let indexPath = tblViewFlashposts.indexPathForRow(at: point) as IndexPath? {
            
            states[indexPath.row] = false
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tblViewFlashposts.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        tblViewFlashposts.endUpdates()
    }
    
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        
        tblViewFlashposts.beginUpdates()
    }
    
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        
        let point = label.convert(CGPoint.zero, to: tblViewFlashposts)
        
        if let indexPath = tblViewFlashposts.indexPathForRow(at: point) as IndexPath? {
            
            states[indexPath.row] = true
            
            DispatchQueue.main.async { [weak self] in
                
                self?.tblViewFlashposts.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        tblViewFlashposts.endUpdates()
    }
}
