//
//  RecordViewController.swift
//  todo-list
//
//  Created by Евгений Сафронов on 24.01.17.
//  Copyright © 2017 Evgeniy Safronov. All rights reserved.
//

import UIKit
import CoreData

class RecordViewController: UIViewController {
    var record: RecordMO?
    
    private var viewContext: NSManagedObjectContext?
    private var backgroundContext: NSManagedObjectContext?
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func cancel(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        save()
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = AppDelegate.instance.persistentContainer.viewContext
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext?.parent = viewContext
        
        if record == nil {
            record = RecordMO(context: backgroundContext!)
        }
        
        textView.text = record?.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    func save() {
        record?.text = textView.text
        backgroundContext?.perform { [unowned self] in
            try! self.backgroundContext?.save()
            self.viewContext?.perform {
                try! self.viewContext?.save()
            }
        }
    }
}
