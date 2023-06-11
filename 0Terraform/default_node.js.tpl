const http = require('http');
const hostname = 'localhost';
const port = 3000;
const now = new Date();

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.write("Holas DevOps UNIR - 29 de Enero Entregable!\n");
  res.write("Fecha del servidor: " + now.toGMTString());
  res.write("\n");
  res.write("\n");
  res.write("Herramientas DevOps!\n");
  res.write("Actividad 29 de Enero\n");
  res.end(
    "Connection String de MongoDb: " +
      "mongodb://root:${mongodb_password}@${mongo_ip}" +
      "\n"
  );
});

server.listen(port, hostname, () => {
  console.log("Server running at http://" + hostname + ":" + port);
});