//
//  DiaryDetailViewController.swift
//  DiaryNotes
//
//  Created by Minh Huy Tran on 14/5/17.
//  Copyright © 2017 Minh Huy Tran. All rights reserved.
//

import UIKit
import CoreData

//push back the window




class DiaryDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    //essential thing for core data
    var managedObjectContext:NSManagedObjectContext!
    var noteDiary = [Diary]()
    var dataSelect : Diary?
    //variables 
    let imagePicker = UIImagePickerController()
    var selectedImage : UIImage!
    
    
    //variable for arrays store file
    
    var gotData = String()
    var cellIndex = 0
    //uitextfieldelegate will allow us to do thing with text view here
    @IBOutlet var textViewField: UITextView!
    
    
//home and cancel button action 
    
    @IBAction func homeAction(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        
        performSegueToReturnBack()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //manager of our notes
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        loadData()
        
        textViewField.text  = gotData

        //add done button to our keyboard
        
        let toolBar = UIToolbar()
        //added toolbar to show our bar firstly
        toolBar.sizeToFit() //this will show our toolbar properly and size it well done
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done , target: self, action: #selector(self.doneClicked))
        
        
        toolBar.setItems([doneButton], animated: false)
        
        textViewField.inputAccessoryView = toolBar
        
        
        
        print(cellIndex)
        // Do any additional setup after loading the view.
    }

    @IBAction func saveAction(_ sender: Any) {
        
        getDataSend()
        
        
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    //func close the keyboard here
    func doneClicked() {
        view.endEditing(true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //extra function for add picture
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
        let textView = textViewField
        let attributedString = NSMutableAttributedString(attributedString: (textView?.attributedText)!)
        let textAttachment = NSTextAttachment()
        textAttachment.image = self.selectedImage
        
        
        let oldWidth = textAttachment.image?.size.width
        let scaleFactor = oldWidth! / ((textView?.frame.size.width)! - 10)
        textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage!)!, scale: scaleFactor, orientation: .up)
        
        let attriStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.replaceCharacters(in: NSMakeRange(6, 1), with: attriStringWithImage)
        textView?.attributedText = attributedString
        self.view.addSubview(textView!)
        
        
        
    }

    //core data variable
 
    
    
    
    //essential thing for core data

    
    func getDataSend() {
        
        gotData = textViewField.text
       
         performSegue(withIdentifier: "saveSegue", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "saveSegue" {
            
            if textViewField.text != "" {
           
           let subText = noteDiary[cellIndex]
           
            
            subText.subNoteName = gotData
            
                
                
                
                
                

            //also
            do {
                
                try self.managedObjectContext.save()
               
                self.loadData()
                
                
            } catch {
                print("Could not save data \(error.localizedDescription)")
            }
            
            }
        }
        
        
    
    }
    
    
    func loadData() {
        let noteRequest:NSFetchRequest<Diary> = Diary.fetchRequest()
        //we load data all of informatino from database
        
        do {
            noteDiary = try managedObjectContext.fetch(noteRequest)
            
            //reload data for our table view
            
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    
    
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


