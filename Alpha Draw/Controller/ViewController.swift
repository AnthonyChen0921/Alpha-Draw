//
//  ViewController.swift
//  Alpha Draw
//
//  Created by Anthony C on 10/21/22.
//

import UIKit

class ViewController: UIViewController {
    var id: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonClicked(_ sender: Any) {
        // create a bodyRequest
        let bodyRequest = PokemonBodyReuqest(version: "3554d9e699e09693d3fa334a79c58be9a405dd021d3e11281256d53185868912", input: InputParameter(prompt: "A small, blue, flying Pokémon with a long tail.", num_outputs: "1", num_inference_steps: "15", guidance_sclae: "7", seed: nil))
        // fetch pokemon data through api
        fetchPokemonInitialRequest(completion: { pokemon in
            print(pokemon)
            self.id = pokemon.id
        }, bodyRequest: bodyRequest)
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        var output = [String]()
        // fetch pokemon data through api
        fetchPokemonByPredictionId(completion: { pokemon in
            print(pokemon)
            output = pokemon.output!
        }, predictionId: self.id!)

        // add image view if output is not empty
        
    }


}

