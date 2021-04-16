const express = require('express');
const app = express();
app.listen(80, () => console.log('listening at 80'));
app.use(express.static('public'));

// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
// Set the region
AWS.config.update({region: 'us-west-2'});
// Create an SQS service object
var sqs = new AWS.SQS({apiVersion: '2012-11-05'});

app.use(express.json({limit: '1gb'}));
app.post('/api', (request, response) => {
  console.log(request.body);
  var params = {
   // Remove DelaySeconds parameter and value for FIFO queues
    DelaySeconds: 10,
    MessageAttributes: {
      "Title": {
        DataType: "String",
        StringValue: "The Whistler"
      }
    },
    MessageBody: request.body.ip_addr,
    QueueUrl: "https://sqs.us-west-2.amazonaws.com/123456789012/test-aws-web-queue"
  };
  sqs.sendMessage(params, function(err, data) {
    if (err) {
      console.log("Error", err);
    } else {
      console.log("Success", data.MessageId);
    }
  });
});

