const express = require('express');
const Redis = require('ioredis');
const app = express();
const port = process.env.PORT || 3000;

let redis;
if (process.env.REDIS_ENABLED === 'true') {
  redis = new Redis({
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
  });
  console.log('Redis connection enabled');
}

app.get('/', async (req, res) => {
  if (redis) {
    const visits = await redis.incr('visits');
    res.send(`Hello World! You are visitor number ${visits}`);
  } else {
    res.send('Hello World! (Redis disabled)');
  }
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
