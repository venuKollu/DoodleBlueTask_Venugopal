//
//  ViewController.swift
//  DoodleBlueTask_Venugopal
//
//  Created by Venugopal on 22/07/20.
//  Copyright © 2020 Venugopal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellIdentifier = "MyCell"
    let headerIdentifier = "Header"
    var usersData : [MainModel] = []
    var multiSelection = false
    var reloadMultiSelectedItems = false
    var tappedIndexForMultiSelection: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readJSONFileAndStore()
/*
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width/2, height: view.frame.height/5)
       layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
  */
        
        collectionView.register(UsersCollectionViewCell.self, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    func readJSONFileAndStore(){
          self.readJson(jsonFileName: "UserModel") { (response, responseType) in
               if responseType == 0 {
                   let obj = response as! NSArray
                   for (index,dataValue) in obj.enumerated(){
                       let dict = MainModel(responceDict: dataValue as! NSDictionary)
                       self.usersData.append(dict)
                    print(self.usersData)
                   }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }

               }
            
            
           }
       }
       func readJson(jsonFileName : String, completionHandler : @escaping (Any, Int) -> Void) {
           do {
               if let file = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
                   let data = try Data(contentsOf: file)
                   let json = try JSONSerialization.jsonObject(with: data, options: [])
                   if let object = json as? NSDictionary {
                       // json is a dictionary
                       print(object)
                       completionHandler(object, 1)
                   } else if let object = json as? NSArray {
                       // json is a dictionary
                       print(object)
                       completionHandler(object, 0)
                       
                   } else {
                       print("JSON is invalid")
                   }
               } else {
                   print("no file")
               }
           } catch {
               print(error.localizedDescription)
           }
       }
    
    
    @IBAction func didSelectSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            multiSelection = false
            collectionView.reloadData()
        default:
            multiSelection = true
        }
        usersData = []
        readJSONFileAndStore()
        
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return usersData.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (usersData[section].selectionType == 1) {
            return 0
        } else if
            (reloadMultiSelectedItems == true) && (usersData[section].selectionType == 2) {
            if tappedIndexForMultiSelection == section {
                return 0
            }
        }
            
    
        return usersData[section].headerArray?.count ?? 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
        .dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UsersCollectionViewCell
        cell.userNameLabel.text = usersData[indexPath.section].headerArray?[indexPath.item].userName
        cell.userImage.image = UIImage(named: usersData[indexPath.section].headerArray?[indexPath.item].userImage ?? "")
        if usersData[indexPath.section].selectionType == 2 {
            
            cell.checkBoxImage.isHidden = false
            if usersData[indexPath.section].selectedIndex.contains(indexPath.item) {
                cell.checkBoxImage.image = #imageLiteral(resourceName: "checkmark")
            } else {
                
                  cell.checkBoxImage.image = #imageLiteral(resourceName: "uncheck")
            }
            
        } else {
            cell.checkBoxImage.isHidden = true
        }
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    switch kind {

    case UICollectionView.elementKindSectionHeader:

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath as IndexPath)

        headerView.backgroundColor = UIColor.gray
        
        headerView.tag = indexPath.section

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapDetected))
        headerView.addGestureRecognizer(tapGestureRecognizer)
        let label:UILabel = UILabel()
        label.frame = CGRect(x: 10, y: 10, width: 200, height: 21)
        //label.center = CGPoint(x: 160, y: 285)
        //label.textAlignment = .center
        
        label.text = usersData[indexPath.section].headerName
        headerView.addSubview(label)
        var image = #imageLiteral(resourceName: "expand-arrow")
        if (usersData[indexPath.section].selectionType == 1) {
             image = #imageLiteral(resourceName: "collapse-arrow")
        } else if  (reloadMultiSelectedItems == true) && (usersData[indexPath.section].selectionType == 2) {
            if tappedIndexForMultiSelection == indexPath.section {
                image = #imageLiteral(resourceName: "collapse-arrow")
            }} else {
            image = #imageLiteral(resourceName: "expand-arrow")
        }
        
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRect(x: collectionView.frame.width - 40, y: 10, width: 20, height: 20)
        headerView.addSubview(imageView)
        
        return headerView

    default:

        assert(false, "Unexpected element kind")
        }
        
    }
    @objc func tapDetected(tap: UITapGestureRecognizer) {
        
        print("header tapped")
        if usersData[tap.view?.tag ?? 0].selectionType == 1 {
            usersData[tap.view?.tag ?? 0].selectionType = 0
            
                 self.collectionView.reloadData()
           
        } else if usersData[tap.view?.tag ?? 0].selectionType == 2 {
            
            tappedIndexForMultiSelection = tap.view?.tag
            reloadMultiSelectedItems = reloadMultiSelectedItems == true ? false : true
          
            self.collectionView.reloadData()
            
        }
        
        
    }
   
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if !multiSelection {
            usersData[indexPath.section].selectionType = 1
           
        } else {
            reloadMultiSelectedItems = false
            usersData[indexPath.section].selectionType = 2
            if let index = usersData[indexPath.section].selectedIndex.firstIndex(of: indexPath.item) {
                usersData[indexPath.section].selectedIndex.remove(at: index)
            } else {
                usersData[indexPath.section].selectedIndex.append(indexPath.item)
            }
            //self.collectionView.reloadItems(at: [indexPath])
            
        }
          self.collectionView.reloadData()
        
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0 // space between rows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0 // space between columns
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: self.view.frame.width/2, height: view.frame.height/3)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
            return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
 

}
