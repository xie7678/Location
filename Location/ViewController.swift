//
//  ViewController.swift
//  Location
//
//  Created by sam on 11/4/16.
//  Copyright © 2016年 xie. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CityPickerDelegate {

    var coreLocationController:CoreLocationController?
    @IBOutlet weak var cityPickerView: CityPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPickerView.delegate = self
//        self.coreLocation = CoreLocationController(onReturnDistrict: { (str) -> Void in
//            if str != "" {
//            print("<><>><><><><>",str)
//                self.cityPickerView.onChooseCity(str)
//            } else {
//                self.cityPickerView.onSetCityPickerData(0, c2: 0, c3: 0)
//            }
//            
//        })
        
        self.coreLocationController = CoreLocationController(onReturnDistrict: { (str) -> Void in
            if str != "" {
                self.cityPickerView.onChooseCity(str)
            } else {
                self.cityPickerView.onSetCityPickerData(0, c2: 0, c3: 0)
            }
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getCityTextAndAreaId(text: String, Id: Int) {
        print("<><><><>><>><<>",text,Id)
    }

}

