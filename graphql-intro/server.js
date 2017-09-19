const schema = require('./schema.js');
const bodyParser = require('body-parser')
const express = require('express');
const graphql = require('graphql/graphql').graphql;

let app = express();
let PORT = 3000;

// parse POST body as text

app.use(bodyParser.text({ type: 'application/graphql' }))



app.post('/graphql',(req,res) => {

    //execute graphQL 

    graphql(schema,req.body)
    .then((result) => {

        res.send(JSON.stringify(result,null,2));
    })

})

let server = app.listen(PORT,function(){

    let host = server.address().address;
    let port = server.address().port;


    console.log('GrapQL listening at http://%s:%s',host,port);
})