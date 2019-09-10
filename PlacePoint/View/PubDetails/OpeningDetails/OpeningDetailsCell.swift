//
//  OpeningDetailsCell.swift
//  PlacePoint
//
//  Created by Mac on 29/05/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class OpeningDetailsCell: UITableViewCell {
    
    @IBOutlet weak var viewOpeningTimes: UIView!
    
    @IBOutlet weak var lblOpeningHours: UILabel!
    
    @IBOutlet var tblOpeningHours: UITableView!
    
    var headerView = TimeHeaderView()
    
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        headerView = Bundle.main.loadNibNamed("TimeHeaderView", owner: nil, options: nil)?[0] as! TimeHeaderView
        
        if arrFilterTime.count > 0  {
            
            let cell = UINib(nibName: "TimeTableCell", bundle: nil)
            
            tblOpeningHours.register(cell, forCellReuseIdentifier: "TimeTableCell")
            
            tblOpeningHours.tableHeaderView = headerView
            
            tblOpeningHours.dataSource = self
            
            tblOpeningHours.delegate = self
            
        }
        
    }
    
    func setUpView() {
        
        headerView = Bundle.main.loadNibNamed("TimeHeaderView", owner: nil, options: nil)?[0] as! TimeHeaderView
        
        
        if arrFilterTime.count == 0 {
            
            DispatchQueue.main.async {
                
                self.tblOpeningHours.tableHeaderView = self.headerView
                
                self.tblOpeningHours.tableFooterView = UIView()
                
                self.headerView.lblDay.text = "Not available"
                
                self.headerView.lblHour.isHidden = true
            }
        }
        else {
            
            let cell = UINib(nibName: "TimeTableCell", bundle: nil)
            
            tblOpeningHours.register(cell, forCellReuseIdentifier: "TimeTableCell")
            
            tblOpeningHours.tableHeaderView = headerView
            
            tblOpeningHours.tableFooterView = UIView()
            
            tblOpeningHours.dataSource = self
            
            tblOpeningHours.delegate = self
            
        }
    }
}


//MARK: - UITableView DataSource and Delegate
extension OpeningDetailsCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrFilterTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableCell", for: indexPath) as? TimeTableCell else {
            
            fatalError()
        }

        if arrFilterTime.count > 0 {
            
            let dict = arrFilterTime[indexPath.row]
            
            guard let time = dict["dayTime"] else {
                
                fatalError()
            }
            
            guard let day = dict["dayName"] else {
                
                fatalError()
            }
            
            cell.lblTime.text = "\(time)"
            
            cell.lblDays.text = "\(day)"
            
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
}
