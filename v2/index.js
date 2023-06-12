// index.js
const express = require('express');
const mongoose = require('mongoose');

const app = express();

// Connect to MongoDB
mongoose.connect('mongodb://mongodb:27017/mydatabase', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch((error) => {
    console.error('Error connecting to MongoDB', error);
  });

app.get('/', (req, res) => {
  res.send('Hello, world!');
});

const port = 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

