//
//  CoreLocationController.swift
//  DDQP-Swift
//
//  Created by lovefancy on 16/1/6.
//  Copyright © 2016年 老镇. All rights reserved.
//

import UIKit
import CoreLocation

class CoreLocationController: NSObject,CLLocationManagerDelegate{
    var oldLocation:CLLocation = CLLocation(latitude: 0, longitude: 0)
    var newLocation:CLLocation = CLLocation(latitude: 0, longitude: 0)
    let locationManager:CLLocationManager = CLLocationManager()
    typealias OnReturnDistrict = (String) -> Void
    var onReturnDistrict:OnReturnDistrict?
    
    init(onReturnDistrict:OnReturnDistrict) {
        
        super.init()
        self.locationManager.delegate = self
        //        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.onReturnDistrict = onReturnDistrict
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        newLocation = locations.last! as CLLocation
        //        print("经纬度：",newLocation.coordinate.longitude,newLocation.coordinate.latitude)
        let dis = oldLocation.distanceFromLocation(newLocation)
        if dis > 1000 {
            //            print(dis)
            let url = "http://apis.map.qq.com/ws/geocoder/v1/?location=\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)&key=JO4BZ-MRP3J-JDYFT-KEE5V-IPVAF-3XFL6"
            Alamofire.request(Method.GET, url).responseJSON(completionHandler: { (response) -> Void in
                //                print("qq map>>",response.debugDescription)
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    if json["status"].int! == 0 {
                        if let district = json["result"]["ad_info"]["district"].string {
                            self.onReturnDistrict!(district)
                        }
                        
                    }
                }
                
            })
        }
        oldLocation = newLocation
    }
    
}
