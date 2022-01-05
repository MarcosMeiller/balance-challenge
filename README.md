# README

api-rest creada para checkear balance entre parentesis de distintos textos.

Desarrollado a lo largo de una semana fue implementada con ruby on rails

los programas para probar el codigo son:
_ruby
_ruby on rails 
_postgresql

instalacion y ejecucion:

ejecutar en consola:

git clone https://github.com/MarcosMeiller/balance-challenge.git

cd balance-messages

bundle install rails db:create

rails db:migrate 

rails s 
links de heroku:
GET  https://guarded-crag-85942.herokuapp.com/messages para index de mensajes

POST https://guarded-crag-85942.herokuapp.com/messages para carga de nuevos mensajes

link de postman:
https://www.getpostman.com/collections/fb974c0c798087639369

aqui los endpoints ya cargados, se exporta con la url en tu aplicacion de postman
y te carga la coleccion con los 2 endpoints

Mejoras a hacer:
_reconocer emoticonos con (:3 y que tome el :3 y otros tipos de emoticonos, creando una lista.

_mejorar el codigo para que haga todo el proceso en un unico recorrido.

_agregar front con una app de react y que llame a los endpoints para tener una interfaz interactiva.

Creada por Marcos Meiller.
