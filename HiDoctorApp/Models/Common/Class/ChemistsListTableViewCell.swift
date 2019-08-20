//
//  ChemistsListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 02/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ChemistsListTableViewCell: UITableViewCell
{
    
    
    @IBOutlet weak var chemistsNameLbl: UILabel!
    @IBOutlet weak var chemistsPlaceLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

      
    }

}
