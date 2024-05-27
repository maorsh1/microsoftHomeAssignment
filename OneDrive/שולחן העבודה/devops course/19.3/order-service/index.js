const express = require('express');
const app = express();
const port = 3002;

app.get('/order', (req, res) => {
  res.json({ id: 101, item: 'Laptop', quantity: 1 });
});

app.listen(port, () => {
  console.log(`Order service listening at http://localhost:${port}`);
});
