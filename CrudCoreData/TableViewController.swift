//
//  TableViewController.swift
//  CrudCoreData
//
//  Created by Max Alva on 29/05/18.
//  Copyright © 2018 Max Alva. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var personas: [Persona] = []
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.reloadData()
        
        tabla.delegate = self
        tabla.dataSource = self
        
        mostrarData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // num, num, cell
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let persona = personas[indexPath.row]
        
        if persona.estado {
            
            cell.textLabel?.text = "💚 \(persona.nombre!)"
            cell.detailTextLabel?.text = "\(persona.edad)"
            
        } else {
            
            cell.textLabel?.text = "❤️ \(persona.nombre!)"
            cell.detailTextLabel?.text = "\(persona.edad)"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enviarEditar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviarEditar" {
            if let id = tabla.indexPathForSelectedRow {
                let fila = personas[id.row]
                let destino = segue.destination as! EditViewController
                destino.personaEditar = fila
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let contexto = conexion()
        let persona = personas[indexPath.row]
        
        if editingStyle == .delete {
            contexto.delete(persona)
            
            do {
                try contexto.save()
            } catch {
                print("No borró", error)
            }
        }
        
        mostrarData()
        tabla.reloadData()
    }
    
    // funciones
    
    func mostrarData() {
        let contexto = conexion()
        
        let fetchRequest: NSFetchRequest<Persona> = Persona.fetchRequest()
        
        do {
            personas = try contexto.fetch(fetchRequest)
        } catch let error as NSError {
            print("No mostro nada", error)
        }
    }
    

}
