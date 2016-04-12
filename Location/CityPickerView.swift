//
//  CityPickerView.swift
//  
//
//  Created by sam on 11/4/16.
//  Copyright © 2016年 xie. All rights reserved.
//

import UIKit

class CityPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var delegate: CityPickerDelegate?
    var cityPicker: UIPickerView?
    /**城市区域数据*/
    var cityArea:MCity = MCity(areaName: "root")
    
    var city1:[MCity] = []
    var city2:[MCity] = []
    var city3:[MCity] = []
    
    var c1: Int? = 0
    var c2: Int? = 0
    var c3: Int? = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.getData()
        
        
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.getData()
    }
    func onSetCityArea(){
        func onAddChild(city:MCity,allArea:[JSON]){
            for  area in allArea  {
                let mCity = MCity(areaId: area["areaID"].int!, parentId: area["parentID"].int!, areaName: area["areaName"].string!)
                city.addChild(mCity)
                if let child = area["child"].array {
                    onAddChild(mCity, allArea: child)
                }
            }
        }
        let path = NSBundle.mainBundle().pathForResource("AllCityArea.txt", ofType: nil)
        if path != nil {
            
            let fileContents = NSData(contentsOfFile: path!)
            let json = JSON(data: fileContents!)
            
            if MCity.lastTime != json["data"]["lastTime"].int! {
                MCity.lastTime = json["data"]["lastTime"].int!
                if let allArea = json["data"]["allArea"].array {
                    onAddChild(cityArea, allArea: allArea)
                }
            }
        }
    }
    func getData() {
        self.onSetCityArea()
        cityPicker = UIPickerView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, self.frame.height))
        self.addSubview(cityPicker!)
        self.cityPicker?.delegate = self
        self.cityPicker?.dataSource = self
        city1 = cityArea.child
        city2 = city1[0].child
        city3 = city2[0].child
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var row:Int = 0
        switch(component){
        case 0:
            row = city1.count
        case 1:
            row = city2.count
        case 2:
            row = city3.count
        default:
            ""
        }
        return row
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title:String = ""
        switch(component){
        case 0:
            title = city1[row].areaName
            
        case 1:
            title = city2[row].areaName
        default:
            title = city3[row].areaName
        }
        return title
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch(component){
        case 0:
            self.c1 = row
            city2 = city1[row].child
            city3 = city2[0].child
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 1:
            self.c2 = row
            city3 = city2[row].child
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 2:
            self.c3 = row
        default:
            ""
        }
        
        self.onShowCity()
    }
    /**展示城市名*/
    func onShowCity() {
        
        let cityName1:String = city1[cityPicker!.selectedRowInComponent(0)].areaName
        let cityName2:String = city2[cityPicker!.selectedRowInComponent(1)].areaName
        let cityName3:String = city3[cityPicker!.selectedRowInComponent(2)].areaName
        let cityName:String = "\(cityName1) \(cityName2) \(cityName3)"
        self.delegate?.getCityTextAndAreaId(cityName, Id: city3[cityPicker!.selectedRowInComponent(2)].areaId)
//        tfCity.text = cityName
//        areaId = city3[cityPicker.selectedRowInComponent(2)].areaId
    }
    
    func onSetCityPickerData(c1:Int,c2:Int,c3:Int){
        city2 = city1[c1].child
        city3 = city2[c2].child
        
        cityPicker!.selectRow(c1, inComponent: 0, animated: false)
        cityPicker!.selectRow(c2, inComponent: 1, animated: false)
        cityPicker!.selectRow(c3, inComponent: 2, animated: false)
        
//        if EData.getData().profile?.store?.areaID! == 0 {
//            self.delegate?.getCityTextAndAreaId("\(city1[c1].areaName) \(city2[c2].areaName) \(city3[c3].areaName)", Id: city3[cityPicker!.selectedRowInComponent(2)].areaId)
//        }
        cityPicker!.reloadAllComponents()
        
    }
    func onChooseCity(cityName:String = ""){
        for (i,province) in self.city1.enumerate() {
            for (j,city) in province.child.enumerate() {
                for (k,district) in city.child.enumerate() {
                    if cityName == "" {
//                        if district.areaId == EData.getData().profile?.store?.areaID {
//                            self.onSetCityPickerData(i,c2: j,c3:k)
//                            return
//                        }
                    }else{
                        if district.areaName == cityName {
                            self.onSetCityPickerData(i,c2: j,c3:k)
                            return
                        }
                    }
                    
                }
            }
        }
    }
    
}

protocol CityPickerDelegate {
    func getCityTextAndAreaId(text: String, Id: Int)
}