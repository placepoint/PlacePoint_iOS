

import UIKit

class DropDownTVCell: UITableViewCell {
    
    @IBOutlet var lblListContent: UILabel!
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    
    func setContent(text: String, arrSelectedValue: [String]) -> Void {
        
        if arrSelectedValue.contains(text) {
            
            self.accessoryType = .checkmark
        }
        
        lblListContent.text = text
    }
    
}
