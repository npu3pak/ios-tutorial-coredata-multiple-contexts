//
//  RecordsTableViewController.swift
//  todo-list
//
//  Created by Евгений Сафронов on 24.01.17.
//  Copyright © 2017 Evgeniy Safronov. All rights reserved.
//

import UIKit
import CoreData

class RecordTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultController: NSFetchedResultsController<RecordMO>?
    private var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request: NSFetchRequest<RecordMO> = NSFetchRequest(entityName: "Record")
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        context = AppDelegate.instance.persistentContainer.viewContext
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController?.delegate = self
        
        try! fetchedResultController?.performFetch()
    }
    
    //MARK: Отображение данных
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController!.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let record = fetchedResultController?.object(at: indexPath)
        cell.textLabel?.text = record?.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let record = fetchedResultController?.object(at: indexPath) {
                fetchedResultController?.managedObjectContext.delete(record)
                try! fetchedResultController?.managedObjectContext.save()
            }
        }
    }
    
    //MARK: Отслеживание изменений
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let record = fetchedResultController?.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = record?.text
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK: Создание/Редактирование
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let record = fetchedResultController?.object(at: indexPath) {
            performSegue(withIdentifier: "EditRecord", sender: record)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRecord" {
            let controller = segue.destination as! RecordViewController
            controller.record = sender as? RecordMO
        }
    }
}
