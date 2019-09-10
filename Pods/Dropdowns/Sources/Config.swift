import UIKit

public struct Config {

  public static var topLineColor: UIColor = UIColor.darkGray.withAlphaComponent(0.8)

  public struct ArrowButton {

    public struct Text {
      public static var color: UIColor = UIColor.white
   
      public static var selectedColor: UIColor = UIColor.white
        public static var font: UIFont = UIFont(name: "Ubuntu-Regular", size: 18)!
    }
  }

  public struct List {

    public struct DefaultCell {
      
      public struct Text {
        
        public static var color: UIColor = UIColor.white
        
        public static var lblCellColor: UIColor =  UIColor.black
        
        public static var font: UIFont = UIFont(name: "Ubuntu-Regular", size: 18)!
      }

      public static var separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5)
    }

    public struct Cell {
        
      public static var type: UITableViewCell.Type = TableCell.self
      public static var config: (_ cell: UITableViewCell, _ item: String, _ index: Int, _ selected: Bool) -> Void = { cell, item, index, selected in
        guard let cell = cell as? TableCell else { return }

        cell.label.text = item.uppercased()
        cell.checkmark.isHidden = !selected
      }
    }

    public static var backgroundColor: UIColor = UIColor.white
    public static var rowHeight: CGFloat = 50
  }
}
