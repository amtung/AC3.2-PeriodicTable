//
//  ElementCollectionViewController.swift
//  PeriodicTable
//
//  Created by Annie Tung on 12/21/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class ElementCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Element>!
    let endPoint = "https://api.fieldbook.com/v1/5859ad86d53164030048bae2/elements"
    //let data = [("H", 1), ("He", 2), ("Li", 3)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UINib(nibName:"ElementCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        //getDataThenSave()
        initializeFetchResultsController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    
    func getDataThenSave() {
        APIRequestManager.manager.getData(endPoint: endPoint) { (data: Data?) in
            guard let validData = data else { return }
            
            
            if let jsonData = try? JSONSerialization.jsonObject(with: validData, options: []) {
                if let json = jsonData as? [[String:Any]] {
                    
                    let managedObjContext = (UIApplication.shared.delegate as! AppDelegate).dataController.privateContext
                    
                    managedObjContext.performAndWait {
                        for jsonDict in json {
                            // Create object and parse element
                            let element = NSEntityDescription.insertNewObject(forEntityName:
                                "Element", into: managedObjContext) as! Element
                            element.parse(dict: jsonDict)
                            
                            do {
                                try managedObjContext.save()
                                managedObjContext.parent?.performAndWait {
                                    do {
                                        try managedObjContext.parent?.save()
                                    } catch {
                                        print("Error saving to parent: \(error)")
                                    }
                                }
                            } catch {
                                print("Error saving to child: \(error)")
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    func initializeFetchResultsController() {
        let managedObjContext = (UIApplication.shared.delegate as! AppDelegate).dataController.managedObjectContext
        
        let request = NSFetchRequest<Element>(entityName: "Element")
        let groupSort = NSSortDescriptor(key: "group", ascending: true)
        let numberSort = NSSortDescriptor(key: "number", ascending: true)
        request.sortDescriptors = [groupSort, numberSort]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjContext, sectionNameKeyPath: "group", cacheName: nil)
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
//            let els = try managedObjContext.fetch(request)
//            for el in els {
//                print("\(el.group) \(el.number) \(el.symbol!)")
//            }
        }
        catch {
            print("error fetching")
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = fetchResultsController.sections else {
            print("No sections in fetch results controller in num of sections")
            return 0
        }
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchResultsController.sections else {
            print("No sections in fetch results controller in num of items in section")
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ElementCollectionViewCell
        
        let element = fetchResultsController.object(at: indexPath)
        
        cell.elementView.elementSymbol.text = element.symbol
        cell.elementView.elementNumber.text = String(element.number)
        
        return cell
    }
    
      /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
}
