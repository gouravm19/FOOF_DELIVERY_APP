const express = require('express');
const bodyParser = require('body-parser');
const { checkConnection } = require('./db');
const routes = require('./routes');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('../swagger/swagger.json');

const app = express();
app.use(bodyParser.json());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
app.use('/api', routes);

checkConnection().then(() => {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
});
