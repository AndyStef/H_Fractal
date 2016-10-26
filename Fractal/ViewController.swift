//
//  ViewController.swift
//  Fractal
//
//  Created by Andy Stef on 10/23/16.
//  Copyright © 2016 Andy Stef. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var mainView: UIScrollView?


    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var handView: UIView!

    @IBOutlet weak var centerXTextField: UITextField!

    @IBOutlet weak var centerYTextField: UITextField!

    @IBOutlet weak var iterationCountTextField: UITextField!

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var iterLabel: UILabel!

    @IBOutlet weak var iterLabel2: UILabel!

    @IBOutlet weak var buildHandButton: UIButton!

    @IBOutlet weak var helpView: UIView!
    var fractalArray: [FractalView] = []

    var iterationCount = 0

    let multiplier = 4
    var currentFractalCount = 0
    var previousFractalCount = 0
    var freeFractalCount = 0
    var centerX = 0
    var centerY = 0

    var lastTemp = 0
    var currentTemp = 0

    var tField: UITextField!

    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Введіть кількість ітерацій"
        tField = textField
    }

    @IBAction func menuButtonPressed(sender: AnyObject) {
        menuButton.hidden = true
        buttonsView.hidden = false
        mainLabel.hidden = false
        mainImage.hidden = false
        handView.hidden = true
        prevButton.hidden = true
        nextButton.hidden = true
        iterLabel.hidden = true
        iterLabel2.hidden = true
        buildHandButton.hidden = true

        iterationCount = 0
        currentFractalCount = 0
        freeFractalCount = 0
        lastTemp = 0
        currentTemp = 0

        for each in fractalArray {
            each.removeFromSuperview()
        }

        fractalArray.removeAll()
    }


    @IBAction func automaticBuild(sender: AnyObject) {
        print("auto")
        let alert = UIAlertController(title: "Побудова", message: "Скільки ітерацій?", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Побудувати", style: .Default) { (action) in

            if self.tField.text == "" {
                UIAlertView.showErrorWithMessage("Введіть число ітерацій", handler: nil)
                return
            }


            let iterCount = Int(self.tField.text!)

            if iterCount < 1 || iterCount > 10 {
                UIAlertView.showErrorWithMessage("Некоректне число ітерацій", handler: nil)
            }

            self.iterationCount = iterCount!

            self.autoBuild()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Відміна", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)

        alert.addTextFieldWithConfigurationHandler(configurationTextField)

        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func buildHand(sender: AnyObject) {
//        centerX = Int(centerXTextField.text!)!
//        centerY = Int(centerYTextField.text!)!
//        iterationCount = Int(iterationCountTextField.text!)!




        if centerXTextField?.text?.isEmpty == true || (centerYTextField?.text?.isEmpty)! || (iterationCountTextField?.text?.isEmpty)! {
            UIAlertView.showWithTitle("Помилка", message: "Заповніть, будь ласка, всі поля", handler: nil)

            return
        }



        guard let centerX = Int((centerXTextField?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))!) else{
            UIAlertView.showWithTitle("Помилка", message: "X не може містити інших знаків, крім цифр ", handler: nil)

            return
        }

        if centerX < 350 || centerX > 650 {
            UIAlertView.showWithTitle("Попередження", message: "Фрактал буде виходити за межі поля зору, рекомендується вибрати X близько 500", handler: nil)

            return
        }

        guard let centerY = Int((centerYTextField?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))!) else{
            UIAlertView.showWithTitle("Помилка", message: "Y не може містити інших знаків, крім цифр ", handler: nil)

            return
        }

        if centerY < 250 || centerY > 450 {
            UIAlertView.showWithTitle("Попередження", message: "Фрактал буде виходити за межі поля зору, рекомендується вибрати Y близько 350", handler: nil)

            return
        }

        guard let iterationCount = Int((iterationCountTextField?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))!) else{
            UIAlertView.showWithTitle("Помилка", message: "Кількість ітерацій не може містити інших знаків, крім цифр ", handler: nil)

            return
        }

        if iterationCount < 0 || iterationCount > 11 {
            UIAlertView.showWithTitle("Попередження", message: "Недопустима кількість ітерацій. Бажано обрати кількість ітерацій < 11", handler: nil)

            return
        }

        self.iterationCount = iterationCount


      //  centerX = Int(centerXTextField.text!)!
       // centerY = Int(centerYTextField.text!)!
       // iterationCount = Int(iterationCountTextField.text!)!



        nextButton.hidden = false
        prevButton.hidden = false
        buildHandButton.hidden = true
        iterLabel.hidden = false
        iterLabel2.hidden = false
        iterLabel2.text = String(iterationCount)

        view.endEditing(true)

        handView.hidden = true
        buttonsView.hidden = true
        mainLabel.hidden = true
        mainImage.hidden = true
        menuButton.hidden = false

        let fractal = FractalView(frame: CGRect(x: 100, y: 100, width: 330, height: 330))
        fractal.backgroundColor = UIColor.clearColor()
        helpView.addSubview(fractal)
        fractal.center.x = CGFloat(centerX)
        fractal.center.y = CGFloat(centerY)
        fractalArray.append(fractal)
        currentFractalCount = 1

        buildNextIteration(fractalArray[0])
        previousFractalCount = 1
        currentFractalCount = 5


        for _ in 1 ..< iterationCount  {
            lastTemp = previousFractalCount
            currentTemp = currentFractalCount
            for i in previousFractalCount..<currentFractalCount {
                print(i)
                buildNextIteration(fractalArray[i])
            }

            let temp = currentFractalCount
            currentFractalCount = currentFractalCount + ((currentFractalCount - previousFractalCount) * multiplier)
            previousFractalCount = temp
        }



    }


    //MARK: - Build

    @IBAction func build(sender: AnyObject) {
        centerX = Int(centerXTextField.text!)!
        centerY = Int(centerYTextField.text!)!
        iterationCount = Int(iterationCountTextField.text!)!

        nextButton.hidden = false
        prevButton.hidden = false

        iterLabel.hidden = false
        iterLabel2.hidden = false
        iterLabel2.text = String(iterationCount)

        view.endEditing(true)

        handView.hidden = true
        buttonsView.hidden = true
        mainLabel.hidden = true
        mainImage.hidden = true
        menuButton.hidden = false

        let fractal = FractalView(frame: CGRect(x: 100, y: 100, width: 330, height: 330))
        fractal.backgroundColor = UIColor.clearColor()
        helpView.addSubview(fractal)
        fractal.center.x = CGFloat(centerX)
        fractal.center.y = CGFloat(centerY)
        fractalArray.append(fractal)
        currentFractalCount = 1



        buildNextIteration(fractalArray[0])
        previousFractalCount = 1
        currentFractalCount = 5


        for _ in 1 ..< iterationCount  {
            lastTemp = previousFractalCount
            currentTemp = currentFractalCount
            for i in previousFractalCount..<currentFractalCount {
                print(i)
                buildNextIteration(fractalArray[i])
            }

            let temp = currentFractalCount
            currentFractalCount = currentFractalCount + ((currentFractalCount - previousFractalCount) * multiplier)
            previousFractalCount = temp
        }


    }


    @IBAction func handBuild(sender: AnyObject) {
        print("hand")
        buttonsView.hidden = true
        menuButton.hidden = false
        handView.hidden = false
        buildHandButton.hidden = false
        helpView!.bringSubviewToFront(containerView)
       // mainView!.bringSubviewToFront(handView)
        handView.layer.zPosition = 1
        buttonsView.layer.zPosition = 2

        UIApplication.sharedApplication().keyWindow!.bringSubviewToFront(containerView)

    }

    @IBAction func buildNext(sender: AnyObject) {
        if iterationCount == 10 {
            UIAlertView.showErrorWithMessage("Більше ітерацій вже не може бути", handler: nil)
            return
        }

        if currentFractalCount == 1 {
            buildNextIteration(fractalArray[0])
            previousFractalCount = 1
            currentFractalCount = 5
        } else {

            lastTemp = previousFractalCount
            currentTemp = currentFractalCount
            for i in previousFractalCount..<currentFractalCount {
                print(i)
                buildNextIteration(fractalArray[i])
            }

            let temp = currentFractalCount
            currentFractalCount = currentFractalCount + ((currentFractalCount - previousFractalCount) * multiplier)
            previousFractalCount = temp
        }

        iterationCount += 1
        iterLabel2.text = String(iterationCount)

    }

    @IBAction func removeLast(sender: AnyObject) {


        if iterationCount == 1 {
            UIAlertView.showErrorWithMessage("Менше ітерацій вже не може бути", handler: nil)
            return
        }

        //var prevCount = calculatePreviousFractalCount(iterationCount)
        let currCount = calculateCurrentFractalCount(Double(iterationCount))
        print(currCount)
        let prevCount = calculateCurrentFractalCount(Double(iterationCount - 1))
      //  return

        for i in Int(prevCount)..<Int(currCount) {
            print(i)
            fractalArray[i].removeFromSuperview()
        }
        fractalArray.removeLast(Int(currCount) - Int(prevCount))

        print("count")
        print(fractalArray.count)

        currentFractalCount = Int(prevCount)
        previousFractalCount = Int(calculateCurrentFractalCount(Double(iterationCount - 2)))

//        if currentFractalCount == 5 {
//            currentFractalCount = 1
//            previousFractalCount = 0
//        }

        iterationCount -= 1
        iterLabel2.text = String(iterationCount)
    }

    func calculateCurrentFractalCount(iteration: Double) -> Double {
        if iteration == 1 {
            return 5
        } else if iteration == 0 {
            return 1
        } else {
            return (pow(Double(multiplier), iteration - 1) * Double(multiplier)) + calculateCurrentFractalCount(iteration - 1)
        }
    }

    func calculatePreviousFractalCount(iteration: Int) -> Int {
        return 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView?.minimumZoomScale = 1.0
        mainView?.maximumZoomScale = 6.0
    }

    func autoBuild() {
        print("autoBuild")
        buttonsView.hidden = true
        mainLabel.hidden = true
        mainImage.hidden = true
        menuButton.hidden = false

        let fractal = FractalView(frame: CGRect(x: 100, y: 100, width: 330, height: 330))
        fractal.backgroundColor = UIColor.clearColor()
        helpView.addSubview(fractal)
        fractal.center.x = helpView.center.x
        fractal.center.y = helpView.center.y
        fractalArray.append(fractal)
        currentFractalCount = 1

        iterLabel2.hidden = false
        iterLabel.hidden = false
        iterLabel2.text = String(iterationCount)

        buildNextIteration(fractalArray[0])
        previousFractalCount = 1
        currentFractalCount = 5


            for _ in 1 ..< iterationCount  {
                lastTemp = previousFractalCount
                currentTemp = currentFractalCount
                for i in previousFractalCount..<currentFractalCount {
                    print(i)
                    buildNextIteration(fractalArray[i])
                }

                let temp = currentFractalCount
                currentFractalCount = currentFractalCount + ((currentFractalCount - previousFractalCount) * multiplier)
                previousFractalCount = temp
            }

    }

    func buildNextIteration(view: FractalView) {
        let halfSide = view.frame.width / 2
        let first = FractalView(frame: CGRect(x: 0, y: 0, width: halfSide, height: halfSide))
        first.backgroundColor = UIColor.clearColor()
        helpView.addSubview(first)
        first.center.x = view.frame.minX
        first.center.y = view.frame.minY
        fractalArray.append(first)

        let second = FractalView(frame: CGRect(x: 0, y: 0, width: halfSide, height: halfSide))
        second.backgroundColor = UIColor.clearColor()
        helpView.addSubview(second)
        second.center.x = view.frame.minX
        second.center.y = view.frame.maxY
        fractalArray.append(second)

        let third = FractalView(frame: CGRect(x: 0, y: 0, width: halfSide, height: halfSide))
        third.backgroundColor = UIColor.clearColor()
        helpView.addSubview(third)
        third.center.x = view.frame.maxX
        third.center.y = view.frame.minY
        fractalArray.append(third)

        let four = FractalView(frame: CGRect(x: 0, y: 0, width: halfSide, height: halfSide))
        four.backgroundColor = UIColor.clearColor()
        helpView.addSubview(four)
        four.center.x = view.frame.maxX
        four.center.y = view.frame.maxY
        fractalArray.append(four)
    }
}

extension ViewController: UIScrollViewDelegate {
    @objc func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return helpView
    }
}




