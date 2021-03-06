//
//  TaskListTableViewController.swift
//  TTTaskList
//
//  Created by Usuário Convidado on 08/03/16.
//  Copyright © 2016 Thiago Nogueira. All rights reserved.
//

import UIKit

import CoreData

class TaskListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext?

    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
   
    @IBAction func newTask(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("segueTask", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupCoreDataStack()
    
        self.getFetchResultController()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let cont = self.fetchedResultController.fetchedObjects?.count {
            return cont
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath)
    
        let task: Task = self.fetchedResultController.objectAtIndexPath(indexPath) as! Task
        cell.textLabel?.text = task.nome!

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {

            let managedObject: NSManagedObject = self.fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        
            self.managedObjectContext?.deleteObject(managedObject)
        
            // Salva a task criada
            do {
                try self.managedObjectContext?.save()
            } catch {
                // Escreve erro se ha
                print("Erro ao remover a task")
            }
    
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let taskController:TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
        
        taskController.managedObjectContext = managedObjectContext
    }

    
    func setupCoreDataStack() {
        // Criacao do modelo

        let modelURL:NSURL? = NSBundle.mainBundle().URLForResource("TaskListModel", withExtension: "momd")
        
        let model = NSManagedObjectModel(contentsOfURL: modelURL!)
        
        // Criacao do coordenador

        // Instancia um coordenador com o modelo criado
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        
        // Recupera o caminho da documents
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath: NSURL = NSURL(fileURLWithPath: paths[0])
        print(docPath.absoluteString)
        
        // Cria o path com o nome do arquivo sqlite
        let sqlitePath = docPath.URLByAppendingPathComponent("TaskListModel.sqlite")
        
        // Associa o arquivo de persistencia ao coordinator, especificando o tipo SQLite e valida possiveis erros
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: sqlitePath, options: nil)
        } catch {
            print("Erro ao associar o coordinator")
        }
        
        // Criacao do contexto
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        
        managedObjectContext!.persistentStoreCoordinator = coordinator
        
    }

    func getFetchResultController() {
        // Primeiro inicilizamos um FetchRequest com dados da tabela Task
        let fetchRequest = NSFetchRequest(entityName: "Task")
    
        // Definimos que o campo usado para ordenação será "nome"
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
    
        // Iniciamos a propriedade fetchedResultController com uma instância de NSFetchedResultsController com o FetchRequest acima definido e sem opções de Cache
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
    
        // A controller será o delegate do fetch
        self.fetchedResultController.delegate = self

        // Executa o Fecth
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            print("Erro ao executar o fetch")
        }
    }
}
