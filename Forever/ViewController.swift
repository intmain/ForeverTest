//
//  ViewController.swift
//  Forever
//
//  Created by 오진성 on 28/11/2019.
//  Copyright © 2019 오진성. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let button1: UIButton = UIButton(type: .custom)
    let button2: UIButton = UIButton(type: .custom)

    let button3: UIButton = UIButton(type: .custom)
    let button4: UIButton = UIButton(type: .custom)

    let label1: UILabel = UILabel()
    let label2: UILabel = UILabel()

    let segment: UISegmentedControl = UISegmentedControl(items: ["whileConnected", "forever"])

    var intervalDisposeBag1: DisposeBag = DisposeBag()
    var intervalDisposeBag2: DisposeBag = DisposeBag()
    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        view.addSubview(button4)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(segment)

        segment.frame = CGRect(x: 0, y: 100, width: 300, height: 50)
        segment.center.x = view.center.x
        button1.frame = CGRect(x: 100, y: 150, width: 200, height: 50)
        button2.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        button3.frame = CGRect(x: 100, y: 250, width: 200, height: 50)
        button4.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        button1.setTitleColor(.black, for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button4.setTitleColor(.black, for: .normal)

        button1.setTitle("1 연결", for: .normal)
        button2.setTitle("1 끊기", for: .normal)
        button3.setTitle("2 연결", for: .normal)
        button4.setTitle("2 끊기", for: .normal)

        label1.frame = CGRect(x: 100, y: 350, width: 200, height: 50)
        label2.frame = CGRect(x: 100, y: 400, width: 200, height: 50)

        label1.textColor = .black
        label2.textColor = .black

        segment.selectedSegmentIndex = 0

        rxInit()
    }

    func rxInit() {

        let intervalWhileConnected = Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { "\($0)" }
            .share(replay: 1, scope: .whileConnected)

        let intervalForever = Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map { "\($0)" }
            .share(replay: 1, scope: .forever)

        button1.rx.tap
            .subscribe(onNext: { _ in
                switch self.segment.selectedSegmentIndex {
                case 0:
                    intervalWhileConnected.bind(to: self.label1.rx.text).disposed(by: self.intervalDisposeBag1)
                case 1:
                    intervalForever.bind(to: self.label1.rx.text).disposed(by: self.intervalDisposeBag1)
                default:
                    break
                }

            }).disposed(by: disposeBag)

        button2.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.intervalDisposeBag1 = DisposeBag()
                self?.label1.text = ""
            }).disposed(by: disposeBag)

        button3.rx.tap
            .subscribe(onNext: { _ in
                switch self.segment.selectedSegmentIndex {
                case 0:
                    intervalWhileConnected.bind(to: self.label2.rx.text).disposed(by: self.intervalDisposeBag2)
                case 1:
                    intervalForever.bind(to: self.label2.rx.text).disposed(by: self.intervalDisposeBag2)
                default:
                    break
                }
            }).disposed(by: disposeBag)

        button4.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.intervalDisposeBag2 = DisposeBag()
                self?.label2.text = ""
            }).disposed(by: disposeBag)
    }


}

