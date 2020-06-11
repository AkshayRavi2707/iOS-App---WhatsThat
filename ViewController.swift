// importing the frameworks for the Xcode Project
import UIKit
import CoreML
import Vision


// we add the two delegate protocols UIImagePickerControllerDelegate and UINavigationControllerDelegate
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // outlet for imageView
    @IBOutlet weak var imageView: UIImageView!
    
    // Creating an ImagePickerController object
    let imagePicker = UIImagePickerController()
    let imagePicker1 = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting properties of imagePickerController to certain values
        // Setting the Delegate of the imagePicker to self
        imagePicker.delegate = self
        
        // allows the camera to take pictures
        imagePicker.sourceType = .camera
        
        // Allows the cropping of images and such additonal functionalities
        imagePicker1.delegate = self
        imagePicker1.sourceType = .photoLibrary
        
    }
    
    // Action to be performed after the user picks an image - we add a delegate method coming from UIImagePickerController class
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // If the image being chosen is actually an image then assign the image property to that image
        if   let Image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            
            imageView.image = Image
            // After picking the image, dismiss the viewcontroller
            imagePicker.dismiss(animated: true, completion: nil)
            
            imagePicker1.dismiss(animated: true, completion: nil)
            
            guard let ciimage = try? CIImage(image: Image) else
            {
                fatalError("Ciimage returned Nil")
            }
            
            detect(image: ciimage)
        }
        

    }
    
    
    func detect(image:CIImage)
    {
        // creating an object called model
        // guard statement ensures that if the model returns nil, then the print statement will be executed
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            
            fatalError("Model Returned Nil")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            //VNClassification Observation is the class that holds the different classifications after the model is processed
            guard let results = request.results as? [VNClassificationObservation] else
            {
                fatalError("Model Failed to Process Image")
            }
            /*
             
             var firstResult = results.first
             print(firstResult) */
            print(results[0])
            
            let probability = results[0].confidence * 100.0
            
            let valueClassified = results[0].identifier
            //self.navigationItem.title = String(format: results[0].identifier, probability)
            
            
            self.navigationItem.title = "\(valueClassified) (Confidence = \(probability)%)"
            // self.navigationItem.title = String(format: "Keyboard=%.1f%", probability)
            
            
            
            
            
            
            /* Displaying Results for the various catagories */
            
            /*
             if(results[0].identifier.contains("keyboard"))
             {
             self.navigationItem.title = "Keyboard (Accuracy = \(probability)%)"
             
             }
             
             
             */
            
            //self.navigationItem.title = "Unable to Classify, Consider Retaking Photo"
            // self.navigationItem.title = String(format: "Keyboard=%.1f%", probability)
            
            
            // "Cat probability=%.1f%"
        }
        
        let handler = VNImageRequestHandler(ciImage:image)
        do{
            try handler.perform([request])
        }
            
        catch
        {
            print(error)
        }
        
    }
    
    
    // Action to be performed after tapping the camera button
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        // Dismiss the imagepicker and go back to the ViewController
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    // In order for privacy sensitive data to be included, go to info.plist and add property list keys
    // Converting the image into a CIImage and that enables us to use the CorML and Vision Framework and get an interpretation from it
    
    
    @IBAction func photosTapped(_ sender: Any) {
        
        present(imagePicker1, animated: true, completion: nil)
        
    }
    
    
    
}

