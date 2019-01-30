//
//  ResultsViewController.swift
//  Personal Quiz
//
//  Created by Давид on 27/01/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var visualResult: UILabel!
    @IBOutlet weak var textResult: UILabel!
    
    // MARK: - Properties
    
    var answers: [Answer]?
    var animals = [AnimalType]()
    var counts: [AnimalType: Int] = [:]
    var result: AnimalType?
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)      // убираем кнопку back в навигейшн чтобы не сбивать результат
        print(#function, answers!)
        countOfAnimals()
        getResult()
        updateUI()
    }
    
    // MARK: - Methods
    
    func countOfAnimals() {
        for answer in answers! {
            counts[answer.type] = (counts[answer.type] ?? 0) + 1 // добавляем полученные из ответов типы(в качестве ключей) в словарь и считаем количество одинаковых(прибавляя 1 в значения типов)
            //animals.append(answer.type)
        }
        print(counts)
    }
    
    func getResult() {
        let resulti = counts.max{ $0.1 < $1.1 }          // выбираем наибольшее значение
        result = resulti?.key
    }
    
    func updateUI() {
        visualResult.text = String("Вы это - \((result?.rawValue)!)")
        textResult.text = result?.defenition
    }

}
