//
//  ViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    var id: String?
    var image: UIImage?
    var output = [String]()
    var token: String = "c3a4bed5dc02edbba4d02d9f4b4f91e1011f9b5b"
    let firebase = Firebase()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // declare a user
        let user = User(id: "10086", name: "Anthony", email: "test@email.com", password: "123456", balance: 1000)
        // save user to firebase
        firebase.addUser(user: user)
        print("uploaded user")

        // disable back button
        self.navigationItem.setHidesBackButton(true, animated: true)

        
    }

    @IBAction func buttonClicked(_ sender: Any) {
        // create a bodyRequest
        let bodyRequest = PokemonBodyReuqest(version: "3554d9e699e09693d3fa334a79c58be9a405dd021d3e11281256d53185868912", input: PokemonInput(prompt: "A small, blue, flying Pokémon with a long tail.", num_outputs: "1", num_inference_steps: "15", guidance_sclae: "7", seed: nil))
        // fetch pokemon data through api
        fetchPokemonInitialRequest(completion: { pokemon in
            print(pokemon)
            self.id = pokemon.id
        }, bodyRequest: bodyRequest, token: token)
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        
        // fetch pokemon data through api
        fetchPokemonByPredictionId(completion: { pokemon in
            print(pokemon)
            // assign output to self.output if is not nill
            if let output = pokemon.output {
                self.output = output
            }
        }, predictionId: self.id!, token: token)
        // if output is nill

        // get the image from the url
        if output.count != 0  {
            image = getImageFromUrl(url: output[0])
        }
        
        // add image view if output is not empty
        let imageView = UIImageView(frame: CGRect(x: 200, y: 500, width: 220, height: 220))
        imageView.image = image;
        imageView.center = self.view.center
        self.view.addSubview(imageView)
        
        // if output.count !=0, upload image to firebase
        if output.count != 0 {
            firebase.uploadImageToStorage(image: image!, id: id!, userid: "agFDGedfNFi3nDIADNw3jfD", imageType: "PokemonImage",completion: { url in
                print(url)
            })
            firebase.uploadImageUrl(id: id!, url: output[0], imageType: "PokemonImage", userid: "agFDGedfNFi3nDIADNw3jfD")
            print(firebase.getImageUrlById(id: id!, userid: "agFDGedfNFi3nDIADNw3jfD", imageType: "PokemonImage"))
            
        }

       

    }

    


}

