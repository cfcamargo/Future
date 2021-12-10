import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String urlBase = "https://jsonplaceholder.typicode.com";



  Future<List<Post>> _recuperarPostagens() async {
   http.Response response = await http.get(urlBase + "/posts");
   var dadosJson = json.decode(response.body);
   
   List<Post> postagens = [];

   for( var post in dadosJson ) {
     Post p = Post(post["userId"], post["id"],post["title"], post["body"]);
     postagens.add ( p );
     
   }
   
   return postagens;

  }

  _post() async {

    Post post = new Post(120, 1, "Titulo", "Corpo da postagem");

    var corpo = json.encode(
      post.toJson()
    );
    http.Response response = await http.post(
      urlBase + "/posts",
      headers: {
        "Content-type" : "application/json; charser=UTF-8"
      },
      body: corpo
    );

    print(response.statusCode);
    print(response.body);

  }

  _put() async {
    var corpo = json.encode({
      "userId": 120,
      "id": null,
      "title": "Título altarado",
      "body": "Corpo do post alterado"
    });
    http.Response response = await http.put(
        urlBase + "/posts/2",
        headers: {
          "Content-type" : "application/json; charser=UTF-8"
        },
        body: corpo
    );

    print(response.statusCode);
    print(response.body);
  }

  patch() async {
    var corpo = json.encode({
      "body": "Corpo do post alterado"
    });
    http.Response response = await http.patch(
        urlBase + "/posts/2",
        headers: {
          "Content-type" : "application/json; charser=UTF-8"
        },
        body: corpo
    );

    print(response.statusCode);
    print(response.body);
  }

  _delete() async {
    var corpo = json.encode({
      "body": "Corpo do post alterado"
    });
    http.Response response = await http.delete(
        urlBase + "/posts/2",
    );

    print(response.statusCode);
    print(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ) ,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: _post,
                  child: Text("salvar"),
                ),
                RaisedButton(
                  onPressed: _put,
                  child: Text("Atualizar"),
                ),
                RaisedButton(
                  onPressed: _delete,
                  child: Text("Deletar"),
                )
              ],
            ),
            
            Expanded(child: FutureBuilder<List>(
              future: _recuperarPostagens(),
              builder: (context, snapshot){

                switch( snapshot.connectionState ){
                  case ConnectionState.none :
                  case ConnectionState.waiting :
                    return Center(
                        child: CircularProgressIndicator()
                    );
                    break;
                  case ConnectionState.active :
                  case ConnectionState.done :
                    print("conexao done");
                    if( snapshot.hasError ){
                      return Text("deu erro");
                    }else {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,

                          itemBuilder: (context, index){

                            List? lista = snapshot.data;
                            Post post = lista![index];


                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.id.toString()),
                            );
                          }
                      );
                    }
                    break;
                }
              },
            ))
            
          ],
        ),
      ),
    );
  }
}
