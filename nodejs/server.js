const http = require('http');
const url = require('url');

const server = http.createServer(function(req,res){

    
      const json = [{
		Personnage:"Goku",
		force:100
		
		},{

		Personnage:"vegeta",
		force:80
		}]
            


        res.end("hey");

})

server.listen(3000,function(){
    console.log('le server à bien été lancer ');
})
