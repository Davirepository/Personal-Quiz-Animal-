//
//  QuestionViewController.swift
//  Personal Quiz
//
//  Created by Давид on 27/01/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var questionLabel: UILabel!
    
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!                  // коллекция кнопок выбираем connect как Outlet Colection и соединяем с каждой кнопкой (получается массив кнопок)
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!                // Outlet Colection массив лейблов для 2 типа вопросов
    
    @IBOutlet weak var rangedStackView: UIStackView!        // Outlet Colection массив лейблов для 3 типа вопросов
    @IBOutlet weak var slider: UISlider!
    @IBOutlet var rangedLabels: [UILabel]!
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    // MARK: - Properties
    var questions: [Question] = [
        Question(text: "Что вы предпочитаете?", type: .single, answers: [
            Answer(text: "Мясо", type: .dog),
            Answer(text: "Рыбу", type: .cat),
            Answer(text: "Морковку", type: .rabbit),
            Answer(text: "Капусту", type: .turtle),
            ]),
        Question(text: "Какие виды деятельности любите?", type: .multiple, answers: [
            Answer(text: "Плавать", type: .turtle),
            Answer(text: "Спать", type: .cat),
            Answer(text: "Прыгать", type: .rabbit),
            Answer(text: "Грызть тапки", type: .dog),
            ]),
        Question(text: "Как вы относитесь к поездкам?", type: .ranged, answers: [
            Answer(text: "Ненавижу", type: .cat),
            Answer(text: "Они меня нервируют", type: .rabbit),
            Answer(text: "Не замечаю", type: .turtle),
            Answer(text: "Обожаю", type: .dog),
            ]),
    ]
    
    var questionIndex = 0                                         // индекс нашего текущего вопроса
    
    var answersChosen = [Answer]()                              // массив с выбранными вариантами ответов
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Methods
    func updateUI() {                                            // обновление наших стеквью в окне "вопросы и ответы"
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        navigationItem.title = "Вопрос № \(questionIndex + 1)"   // изменяем заголовок в окне "вопросы и ответы" на номер вопроса
        let question = questions[questionIndex]                 // создаем вопрос
        
        let answers = question.answers
        
        questionLabel.text = question.text                      // текст вопроса над ответами
        
        let progress = Float(questionIndex) / Float(questions.count) // задаем деления(флоат) для шкалы прогресса
        progressView.progress = progress            // в данном виде на последнем вопросе шкала не будет упираться в конец, чтобы это случилось следует questionIndex увеличить на 1
        
        switch question.type {                                  // в зависимости от типа вопроса будет отображаться тот или иной стеквью с вопросом
        case .single:
            updateSingleStack(using: answers)
        case .multiple:
            updateMultipleStack(using: answers)
        case .ranged:
            updateRangedStack(using: answers)
        }
    }
    
    func updateSingleStack(using answers: [Answer]) {
        singleStackView.isHidden = false
        singleButtons.forEach { $0.isHidden = true }            // forEach вызывает замыкание, который в качестве параметра принимает баттон и делает его невидимым (проходится по всем кнопкам) $0 - название элемента замыкания
        for index in 0..<min(singleButtons.count, answers.count) {  // если баттнов меньше то остальные вопросы не выведутся и наоборот
            singleButtons[index].isHidden = false
            singleButtons[index].setTitle(answers[index].text, for: .normal)
        }
    }
    
    func updateMultipleStack(using answers: [Answer]) {
        multipleStackView.isHidden = false
        multipleLabels.forEach { $0.superview!.isHidden = true } // так тут нужно прятать и лейбл и свитч, то прячем их общий стек, а так как у нас нет аутлета их стека, то обратимся к нему через лейбл с помощью superview
        for index in 0..<min(multipleLabels.count, answers.count) {
            multipleLabels[index].superview!.isHidden = false       // открываем родителя вместе с лейблом и свичом, так как мы их закрывали выше
            multipleLabels[index].text =  answers[index].text
        }
    }
    
    func updateRangedStack(using answers: [Answer]) {
        rangedStackView.isHidden = false
        rangedLabels.first!.text = answers.first!.text
        rangedLabels.last!.text = answers.last!.text
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {  // если индекс вопроса совпадает с кол-вом вопросов в массиве, то обновляем стеквью
            updateUI()
        } else {                              // если мы ответили на все вопросы и индекс больше кол-ва вопросов в масиве, то переходим на след. окно
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            let resultsViewController = segue.destination as! ResultsViewController
            
            resultsViewController.answers = answersChosen      // передали результаты ответов в другое окно
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - @IBAction

    @IBAction func singleButtonPressed(_ sender: UIButton) {
        let answers = questions[questionIndex].answers
        let index = singleButtons.lastIndex(of: sender)!     // получаем индекс нажатой кнопки
        answersChosen.append(answers[index])                // получаем ответа по индексу, так как индекс кнопки совпадает с индексом ответа в массиве
        nextQuestion()
    }
    
    @IBAction func multipleButtonPressed(_ sender: Any) {
        let answers = questions[questionIndex].answers                              // массив ответов каждый из которых соответствует определенному свичу
        
        for index in 0..<min(multipleLabels.count, answers.count) {
            let label = multipleLabels[index]                                     // получили 1 лейбл
            let stackView = label.superview!                                     // получили стеквью связанный с лейблом
            let multiSwitch = stackView.subviews.last! as! UISwitch             // получили доступ к свитч(получили тип UIView) и привели к типу UISwitch
            
            if multiSwitch.isOn {                                             // если этот ответ выбран (выбран свитч) то добавляем его в массив выбранных ответов
                answersChosen.append(answers[index])
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedButtonPressed(_ sender: Any) {
        let answers = questions[questionIndex].answers
        let index = Int(round(slider.value * Float(answers.count - 1)))    // индекс от 0 до 3 поэтому создаем деления таким образом Float(answers.count - 1) иначе будет от 0 до 4 (у нас 4 вопроса но считаем с 0)
        answersChosen.append(answers[index])
        nextQuestion()
    }
    
}
