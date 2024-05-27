const express = require('express');
const app = express();
const port = 3001;

app.get('/user', (req, res) => {
  res.json({ id: 1, name: 'John Doe' });
});

app.listen(port, () => {
  console.log(`User service listening at http://localhost:${port}`);
});
