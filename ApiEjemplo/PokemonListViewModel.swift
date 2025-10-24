//
//  Connection.swift
//  ApiEjemplo
//
//  Created by rene on 24/10/25.
//

import Foundation

class PokemonListViewModel : ObservableObject {
    @Published var pokemon: Pokemon
    
    init(){
        self.pokemon = Pokemon(count: -1, siguiente: "" , previous: "" , results: [])
    }
    
    func getPokemonList(){
        let endPoint : String = "https://pokeapi.co/api/v2/pokemon"
        
        guard let apiURL = URL(string: endPoint) else{
            fatalError("Url no válida o no definida")
        }
        
        var urlRequest = URLRequest(url: apiURL)
        
        //Especificar tipo de contenido: XML, JSON, String,etc.
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Mencionar tipo de método GET, POST, PUT, PATCH, DELETE
        urlRequest.httpMethod = "GET"
        
        
        /*Configuración de Cabeceras(Headers) en caso que la petición lo demande:
         urlRequest.addValue("token123", forHTTPHeaderField: "Authorization")
         urlRequest.addValue("ios", forHTTPHeaderField: "User-Agent")
         */
        
        
        /*Ejemplo de inicialización y envío parametros POST
         let parameters: [String: Any] = [
         "id_trainer" : 1,
         "name" : "Ash",
         "champion" : true,
         ]
         
         let jsonData = try? JSONSerialization.data(withJSONObject: params)
         urlRequest.httpBody = jsonData
         */
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error -> Void in
            
            if let error = error {
                print("Error: " + error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Error: Incapaz de conectar o recibir respuesta del servidor")
                return
            }
            
            
            if response.statusCode == 200 {
                
                guard let data = data else {
                    print("Respuesta vacía")
                    return
                }
                
                /*AQUÍ NUESTRA LOGICA para procesar la respuesta
                 */
                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode(Pokemon.self, from: data)
                   
                        self.pokemon = decoded
                    } catch let error {
                        print("Error al decodificar JSON \(error)")
                        return
                    }
                }

                
            }else{
                print("Status diferente a 200. Ejemplos: 500 - Internal server error, 400 - Not found , etc.")
                return
            }
            
        })
        task.resume()
    }
    
    
}
