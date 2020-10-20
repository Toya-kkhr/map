//
//  ViewController.swift
//  MyMap
//
//  Created by 加古原　冬弥 on 2020/05/07.
//  Copyright © 2020 加古原　冬弥. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }


    @IBOutlet weak var inputText: UITextField!
    
    
    @IBOutlet weak var dispMap: MKMapView!
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //キーボードを閉じる（１）
        textField.resignFirstResponder()
        
        //入力された文字を取り消す（２）
        if let searchKey = textField.text {
            
            //入力された文字をでバックエリアに表示（３）
            print(searchKey)
            
            //CLGeocoderインスタンスを取得（５）
            let geocoder = CLGeocoder()
            
            //入力された文字から位置情報を取得（６）
            geocoder.geocodeAddressString(searchKey , completionHandler: { (placemarks, error)in
                
            //位置情報が存在する場合は、unwrapplacrmarks に取り出す（７）
                if let unwrapPlacemarks = placemarks {
                    
                    //1件目の情報を取り出す（８）
                    if let firstPlacemark = unwrapPlacemarks.first {
                        
                        //位置情報を取り出す（９）
                        if let location = firstPlacemark.location {
                            
                            //位置情報から緯度経度をtargetCordinateに取り出す（１０）
                            let targetCoordinate = location.coordinate
                            
                            //緯度経度をでバックエリアに表示（１１）
                            print(targetCoordinate)
                            
                            //MKPointAnnotationインスタンスを取得し、ピンを生成（１２）
                            let pin = MKPointAnnotation()
                            
                            //ピンを置く場所に経度緯度を設定（１３）
                            pin.coordinate = targetCoordinate
                            
                            //ピンのタイトルを設定
                            pin.title = searchKey
                            
                            //ピンを地図に置く（１５）
                            self.dispMap.addAnnotation(pin)
                            
                            //経度緯度を中心にして半径５００mの範囲を表示
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate,latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                            
                        }
                    }
                }
            })
            
            }
        
        //デフォルト動作を行うのでtrueを返す（４）
        return true
    }
    
    
   
    @IBAction func changeMapButton(_ sender: Any) {
    
        //mapType　プロパティー値をトグル
        
        //標準　→　航空写真　→ 航空写真＋標準
        
        //　→交通機関
        
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
            
        }else if dispMap.mapType == .satellite{
            dispMap.mapType = .hybrid
            
        }else if dispMap.mapType == .hybrid{
            dispMap.mapType = .satelliteFlyover
    
        }else if dispMap.mapType == .satelliteFlyover{
            dispMap.mapType = .hybridFlyover
        
        }else if dispMap.mapType == .hybridFlyover{
                dispMap.mapType = .mutedStandard
        
        }else{
            dispMap.mapType = .standard
            
        }

}
}

