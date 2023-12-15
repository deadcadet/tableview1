//
//  ViewController.swift
//  tableview
//
//  Created by Артур Ганиев on 14.12.2023.
//

import UIKit

class ViewController: UIViewController {
    //аутлет
    @IBOutlet var tableView: UITableView!
    //хранилище контактов - массив типа контактПротокол
    var contacts = [ContactProtocol]()
    //стадия цикла перед отображением вьюшки
    override func viewDidLoad() {
        //загрузка контактов
        loadContact()
        super.viewDidLoad()
    }
    //определение функции загрузки контактов
   private func loadContact() {
       //добавление нового контакта в массив
        contacts.append(Contact(contactName: "Test1", contactPhone: "2-42-20"))
        contacts.append(Contact(contactName: "Test2", contactPhone: "2-22-30"))
        contacts.append(Contact(contactName: "Test3", contactPhone: "2-66-24"))
        //contacts.sort{$0.contactName > $1.contactName}
    }
    //функция конфигурации ячейки
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        //создание дефолтной конфигурации
        var configuration = cell.defaultContentConfiguration()
        //настройка текста конфигурации
        configuration.text = contacts[indexPath.row].contactName
        configuration.secondaryText = contacts[indexPath.row].contactPhone
        //применение конфиги
        cell.contentConfiguration = configuration
    }
    // экщшн по нажатию кнопки добавления контакта
    @IBAction func createContact() {
        //создание контроллера всплывающего окна
        let alertController = UIAlertController(title: "Create a new contact", message: "Enter", preferredStyle: .alert)
        //добавление тектовых полей в контролер
        alertController.addTextField { textField in
            textField.placeholder = "enter the name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "enter the phone number"
        }
        //создание кнопки
        let createButton = UIAlertAction(title: "create", style: .default) { _ in
            //создание переменных
            guard let contactName = alertController.textFields?[0].text,
                  let phoneNumber = alertController.textFields?[1].text else {
                return
            }
            //новый контакт
            let contact = Contact(contactName: contactName, contactPhone: phoneNumber)
            //добавленме его в массив
            self.contacts.append(contact)
            //обновлвение интерфейса таблицы
            self.tableView.reloadData()
        }
        //кнопка отмены
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel)
        //добавление кнопок
        alertController.addAction(createButton)
        alertController.addAction(cancelButton)
        //вывод контроллера на экран
        self.present(alertController, animated: true, completion: nil)
        
    }
}
//расширение которое подписывает ВК на дата соурс
extension ViewController: UITableViewDataSource {
    //определяем количество строк
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //по количеству элементов массива контактов
        return contacts.count
    }
    //создаем строки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ячейка
        var cell: UITableViewCell
        //если ячейа уже есть
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "contactCellIdentifier") {
            print("using existing cell")
            //присваиваем ее
            cell = reuseCell
        } else { //если нет
            print("creating new cell")
            //созздаем новую
            cell = UITableViewCell(style: .value1, reuseIdentifier: "contactCellIdentifier")
        }
        //конфигурируем
        configure(cell: &cell, for: indexPath)
        //возврат ячейка
        return cell
    }
}
//расширение подписывающее на делегат
extension ViewController: UITableViewDelegate {
    //действие по нажатию на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked on row \(indexPath.row)")
    }
    //свайп в лево
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //создаем действие удаления
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            //удаляем контакт из массива
            self.contacts.remove(at: indexPath.row)
            //обновлчем таблицу
            tableView.reloadData()
        }
        //добавляем действие в свайпы
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return actions
    }
}

