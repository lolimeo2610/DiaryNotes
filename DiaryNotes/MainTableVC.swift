//
//  MainTableVC.swift
//  DiaryNotes
//
//  Created by Minh Huy Tran on 12/5/17.
//  Copyright © 2017 Minh Huy Tran. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class MainTableVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //test premade diary main module
    /* 
 var myNotesList = [
        ["name": "Name 1", "image": "Pic1", "item": "first Text here \n something again..."],
        ["name": "Something here", "image": "Pic2", "item": "nothing much here to say"],
        ["name": "My name", "image": "PE", "item": "bad things something"],
        ["name": "Want my number?", "image": "Pic1", "item": "Some line..."],

    
    //add more to test if needed...
    
    
    ]
    */
    
    //some outlet for decorating
    @IBOutlet weak var diaryTitle: UITextField!
    
    var eDiaryName = String()
    
    
    //variable for arrays store file
    var noteDiary = [Diary]()
    

    
    
    //essential thing for core data
    var managedObjectContext:NSManagedObjectContext!
    
    
    
    
    //--------
    
    
    var FXplayer = AVAudioPlayer()
    
    //play sound effec on button
    func soundFX(){
    
        do {
            FXplayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Click", ofType: "mp3")!))
            
            FXplayer.prepareToPlay()
            
        } catch {
            print(error)
        }
        
    }
    //play function
    
    func FXplayed() {
        FXplayer.play()
    }
    
    
  //change diary title
    
   
    func changeTitleDiary()
    {
        
        FXplayed()
        
       eDiaryName = diaryTitle.text!
        
        
        let inputAlert = UIAlertController(title: "Change diary name", message: "Have to restart the app to take effect!", preferredStyle: .alert)
        
        inputAlert.addTextField { (textfield: UITextField) in
            textfield.placeholder = "your diary name..."
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            
            let diaryNoteName = inputAlert.textFields?.first
            
            if diaryNoteName?.text != nil {
                
                self.eDiaryName = (diaryNoteName?.text)!
                
                UserDefaults.standard.set(self.eDiaryName, forKey: "myDiaryname")

                self.diaryTitle.text = self.eDiaryName
                
            }
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
        
        
        //finishing the text
        
        //user default standard to save the name
      //  diaryTitle.text = ""
        
          }
    //edit title button
    
    @IBAction func editTitleAction(_ sender: Any) {
        
        changeTitleDiary()
    }
    
    
    //how to load data after we do input function successed
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //prepare sound to play anytime
        soundFX()
        
    //code start
    //we can add icon to our navigaiton title. like this code bellow here.
       // let iconImageView = UIImageView(image: UIImage(named: "Pic1"))
        //self.navigationItem.titleView = iconImageView
    
        //howevee, I want user can edit their old title by words which will be more useful than just an icon.
    
    
        //manager of our notes 
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        loadData()

        //can be use as property of our class
        
        
    }

    
    //view did appear
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let x = UserDefaults.standard.object(forKey: "myDiaryname") as? String {
            self.diaryTitle.text = x
        }
    }
    
    
    
    
    //view will appear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //background image variables
        let backgroundImage = UIImage(named: "background1.jpg")
        //add background for the view controller
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    
        //no lines where there aren't cells to show
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //center and scale background image
        imageView.contentMode = .scaleAspectFill
    }
    
    //extra function for core data user
    
    func loadData() {
        let noteRequest:NSFetchRequest<Diary> = Diary.fetchRequest()
        //we load data all of informatino from database
        
        do {
            noteDiary = try managedObjectContext.fetch(noteRequest)
            self.tableView.reloadData()
            
            //reload data for our table view
            
        } catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
    //table view edting syle
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            managedObjectContext.delete(noteDiary[indexPath.row])
            
            do {
                try self.managedObjectContext.save()
                
                self.loadData()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
    }
    
    
    
    //have to force our height = 150 pixel not less
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noteDiary.count
    }

    
    //edit table view cell here
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainSubModuleTableViewCell
//have to make sure this is declared
        
        // Configure the cell...
        let noteItems = noteDiary[indexPath.row]
        
        //check if our image is available?
      
      if   let ourImage = UIImage(data: noteItems.noteImage! as Data)
        
      {    cell.backgroundImageView.image = ourImage }
        
//loadData()
     
        
        
        cell.nameModuleLabel.text = noteItems.noteName
        cell.subModuleLabel.text = noteItems.subNoteName
        //here we show the first one
     
        //only open the below function loaddata to get in safe mode and reset data. its bug sometimes. i still work on fixing that at the moment.
        
   //  loadData()

        return cell
        


    }
 
    
    //extra function button
    @IBAction func addNotes(_ sender: Any) {
        
        FXplayed()
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        //the photo will get from random in lib atm
        
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
//according to addNotes func
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //so we got the image from library, now we need to add the title and sub text as well
            
            picker.dismiss(animated: true, completion: {
                
                self.createNoteItem(with: image)
                
            })
            
            
        }
    }
    
    //we use entity created in core data to get datae asiyly
    func createNoteItem (with image:UIImage) {
        
        FXplayed()
        
        
        let noteItem = Diary(context: managedObjectContext)
        noteItem.noteImage = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        //create an alert to get data and input, output...
        
        //main controller alert
        let inputAlert = UIAlertController(title: "New Note", message: "Enter a title and sub text.", preferredStyle: .alert)
        
        inputAlert.addTextField { (textfield: UITextField) in
            textfield.placeholder = "noteName"
        }
        
        inputAlert.addTextField { (textfield: UITextField) in
            textfield.placeholder = "subNoteName"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) in
       
        let noteNameTextField = inputAlert.textFields?.first
        let subNoteTextField = inputAlert.textFields?.last
        
        if noteNameTextField?.text != "" && subNoteTextField?.text != "" {
            
            //equality of attribute in diary entity coredata and text field we created here
            noteItem.noteName = noteNameTextField?.text
            noteItem.subNoteName = subNoteTextField?.text
            
            //also
            do {
                try self.managedObjectContext.save()
                
                self.loadData()
                
                
                
            } catch {
                print("Could not save data \(error.localizedDescription)")
            }
            
            }
            
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
            
            //cancel alert button.
        }
    
//bookmark button stand for deleta all the data, will be more function inside there. but now i can do it simple atm
    @IBAction func resetActionButton(_ sender: Any) {
        
        FXplayed()
        
        //alert controller now 
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let resetAction = UIAlertAction(title: "Reset Diary", style: .default) { (action) in
            
            //action of reset data function put here
            self.resetAllData()
        }
        
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        
        //finialize the action of controller
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true,completion: nil)
        
        
    }
    
    func resetAllData() {
        
        FXplayed()
        
        //get entity name in our coredata first indetify stage
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try managedObjectContext.execute(request)
        try managedObjectContext.save()
            
        } catch {
            print ("There was an error")
        }
        
        self.loadData()
    }

    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    var selectedData : Diary?
    var indexRow = Int()
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sendSegue" {

            let detailVC = segue.destination as! DiaryDetailViewController
            detailVC.gotData = (selectedData?.subNoteName)!
            detailVC.cellIndex = indexRow //row number 1,2,3...
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedData = noteDiary[indexPath.row]
        indexRow = Int(indexPath.row)
        
        performSegue(withIdentifier: "sendSegue", sender: self)
    }
    

}
