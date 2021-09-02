//
//  HomepageViewController.swift
//  Expresso
//
//  Created by Jessi Febria on 01/05/21.
//

import UIKit

class HomepageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var emptyText: UILabel!
    var allPerson = PersonService().getAllPerson()
    var keyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setIfNotEmpty()
        // Do any additional setup after loading the view.
    }
    
    func setIfNotEmpty(){
        if allPerson.count != 0 {
            emptyText.isHidden = true
        } else {
            emptyText.isHidden = false
        }
    }
    
    @objc func reloadData(){
        
        DispatchQueue.main.async { [self] in
            if keyword == "" {
                allPerson = PersonService().getAllPerson()
            } else {
                allPerson = PersonService().searchPerson(keyword: keyword)
            }
            collectionView.reloadData()
            setIfNotEmpty()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIEW WILL APPEAR")
        reloadData()
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // jumlah data
        return allPerson.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // setting tiap cell
        
        print("CREATING AT \(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! HompageCollectionViewCell
        
        cell.layer.borderColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        cell.layer.borderWidth = 1
        
        if indexPath.row == 0 {
            cell.isAdd = true
        } else {
            cell.personData = allPerson[indexPath.row-1]
        }
        return cell
    }

    
    // DELEGATE
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // saat cell dipilih
        print("selected")
        if indexPath.row == 0 {
            performSegue(withIdentifier: "HomepageToAdd", sender: nil)
            return
        }
        
        print(allPerson[indexPath.row-1].name)
        print(allPerson[indexPath.row-1].id)
        
        performSegue(withIdentifier: "HomepageToRecording", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomepageToRecording" {
            if let destinationVC = segue.destination as? RecordingViewController, let index = collectionView.indexPathsForSelectedItems?.first {
                destinationVC.person = allPerson[index.row-1]
            }
        }
    }
    
    // unwind segue
    
    @IBAction func unwindToHomepage(_ segue : UIStoryboardSegue){
    }
}


extension HomepageViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchFromKeyword(searchBar: searchBar)
    }
    
    func searchFromKeyword(searchBar : UISearchBar){
        if let key = searchBar.text {
            let searchResult = PersonService().searchPerson(keyword: key)
            keyword = key
            allPerson = searchResult
            reloadData()
        }
        searchBar.searchTextField.resignFirstResponder()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    
}


