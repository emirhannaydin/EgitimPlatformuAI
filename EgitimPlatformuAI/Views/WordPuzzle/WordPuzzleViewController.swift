//
//  WordPuzzleViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 13.06.2025.
//

import UIKit

final class WordPuzzleViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var guessLabel: UILabel!
    @IBOutlet var undoButton: UIButton!
    @IBOutlet var hintButton: UIButton!
    @IBOutlet var backButton: CustomBackButtonView!
    var viewModel: WordPuzzleViewModel!

    let words = [
        "KİTAP", "MASA", "SANDALYE", "BİLGİSAYAR", "TELEFON",
        "KALEM", "SİLGİ", "DEFTER", "PENCERE", "KAPI",
        "PERDE", "ÇİÇEK", "GÜNEŞ", "YILDIZ", "BULUT",
        "DENİZ", "GÖKYÜZÜ", "ORMAN", "DAĞ", "TAŞ",
        "TOPRAK", "SU", "YAĞMUR", "KAR", "RÜZGAR",
        "KİTAPLIK", "ÇANTA", "AYAKKABI", "GÖZLÜK", "ŞAPKA",
        "PANTOLON", "CEKET", "KAZAK", "ELBİSE", "TOKA",
        "SAAT", "KALP", "SEVGİ", "MUTLULUK", "HUZUR",
        "KAHKAHA", "DOSTLUK", "ARKADAŞ", "AİLE", "KARDEŞ",
        "ANNE", "BABA", "ÇOCUK", "BEBEK", "OYUN",
        "OYUNCAK", "SEVDA", "UMUT", "HAYAT", "NEFES",
        "ZAMAN", "MEVSİM", "İLKBAHAR", "YAZ", "SONBAHAR",
        "KIŞ", "SEPET", "MERDİVEN", "BALKON", "FIRIN",
        "TENCERE", "TABAK", "ÇATAL", "KAŞIK", "BIÇAK",
        "SALATA", "ÇORBA", "PİLAV", "KÖFTE", "TATLI",
        "MEYVE", "ELMA", "ARMUT", "ÜZÜM", "KİRAZ",
        "ÇİLEK", "KARPUZ", "KAVUN", "MUZ", "PORTAKAL",
        "LİMON", "VİŞNE", "NAR", "ERİK", "İNCİR",
        "HAYVAN", "KEDİ", "KÖPEK", "KUŞ", "BALIK",
        "AT", "İNEK", "KEÇİ", "TAVUK", "HOROZ"
    ]

    var selectedIndexes: [IndexPath] = []

    var selectedWord = ""
    var shuffledLetters: [String] = []
    var correctGuesses: [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        setCollectionView()
        backButton.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    }
    
    private func setupGame() {
        selectedWord = words.randomElement() ?? "CODE"
        shuffledLetters = selectedWord.map { String($0) }.shuffled()
        correctGuesses = []
        selectedIndexes = []
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LetterCell.self, forCellWithReuseIdentifier: "LetterCell")
        

    }
    @IBAction func handleUndo(_ sender: Any) {
        guard let lastIndex = selectedIndexes.popLast(), !correctGuesses.isEmpty else { return }

        let restoredChar = String(selectedWord[selectedWord.index(selectedWord.startIndex, offsetBy: correctGuesses.count - 1)])
        shuffledLetters[lastIndex.item] = restoredChar
        correctGuesses.removeLast()
        
        guessLabel.text = "Your guess: " + correctGuesses.joined(separator: " ")
        collectionView.reloadItems(at: [lastIndex])
    }
    
    @IBAction func handleHint(_ sender: Any) {
        let currentIndex = correctGuesses.count
        guard currentIndex < selectedWord.count else { return }

        let nextCorrectLetter = String(selectedWord[selectedWord.index(selectedWord.startIndex, offsetBy: currentIndex)])

        if let index = shuffledLetters.firstIndex(of: nextCorrectLetter) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            self.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    @objc func handleBackButton(){
        navigationController?.popViewController(animated: true)
    }
    
}

extension WordPuzzleViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffledLetters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath) as! LetterCell
        let letter = shuffledLetters[indexPath.item]
        cell.configure(with: letter)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLetter = shuffledLetters[indexPath.item]
        let currentIndex = correctGuesses.count
        let correctLetter = String(selectedWord[selectedWord.index(selectedWord.startIndex, offsetBy: currentIndex)])
        
        if selectedLetter == correctLetter {
            selectedIndexes.append(indexPath)
            correctGuesses.append(selectedLetter)
            guessLabel.text = "Your guess: " + correctGuesses.joined(separator: " ")
            shuffledLetters[indexPath.item] = ""
            collectionView.reloadItems(at: [indexPath])
            
            if correctGuesses.joined() == selectedWord {
                self.showAlert(title: "Congratulations!", message: "You guessed the word: \(selectedWord)", lottieName: "success"){
                    self.setupGame()
                    self.guessLabel.text = "Your guess: "
                    self.collectionView.reloadData()
                }
            }
        } else {
            showAlert(title: "Wrong!", message: "That letter is not in the correct order.", lottieName: "error")
        }
    }
}



