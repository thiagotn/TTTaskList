//
//  TaskDetailViewController.swift
//  TTTaskList
//
//  Created by Usuário Convidado on 08/03/16.
//  Copyright © 2016 Thiago Nogueira. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var txtDesc: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func addTask(sender: AnyObject) {
        // Cria uma variavel para referenciar a tabela task
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.managedObjectContext!)
        
        // Cria uma instancia da task
        let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        // Atribui o valor nome para instancia da task
        task.nome = self.txtDesc.text
        
        // Salva a task criada
        do {
            try self.managedObjectContext!.save()
            
            // Apos adicao com sucesso, retorna a tela de listagem de tasks
            self.navigationController?.popViewControllerAnimated(true)
        } catch {
            // Escreve erro quando ha
            print("Erro sao salvar task")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
