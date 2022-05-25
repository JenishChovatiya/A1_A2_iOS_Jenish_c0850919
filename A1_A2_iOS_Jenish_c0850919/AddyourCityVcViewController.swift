//
//  AddyourCityVcViewController.swift
//  A1_A2_iOS_Jenish_c0850919
//
//  Created by user219793 on 5/24/22.
//

import UIKit
import MapKit

protocol resultaftersearch {
    func viewListofCity(item : MKMapItem)
}


class AddyourCityVcViewController: UIViewController {
    
    //Connecing VAriables
    @IBOutlet weak var findcityTF: UITextField!
    
    @IBOutlet weak var resulttableView: UITableView!
    
    var viewofMap : MKMapView?
    
    var itemsMAtched:[MKMapItem] = []
    
    var delegate : resultaftersearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    //when user serch for city than this action will perform
    @IBAction func btnPressed(_ sender: Any)
    {
        let findrequest = MKLocalSearch.Request()
        findrequest.naturalLanguageQuery = findcityTF.text!
        findrequest.region = viewofMap!.region
        let searchofText = MKLocalSearch(request: findrequest)
        searchofText.start { response, _ in
            guard let backOfsearch = response else {
                return
            }
            self.itemsMAtched.removeAll()
            self.itemsMAtched = backOfsearch.mapItems
            self.resulttableView.reloadData()
        }

    }
    
}



//create extension of the class
extension AddyourCityVcViewController : UITableViewDataSource, UITableViewDelegate {
    
    //func "tableview" decide number of raws per secion and return int values
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsMAtched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celleach = tableView.dequeueReusableCell(withIdentifier: "findTeableViewCell") as! findTeableViewCell
        celleach.displayMatchedCities.text = itemsMAtched[indexPath.row].placemark.title ?? ""
        return celleach
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.viewListofCity(item: itemsMAtched[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}


