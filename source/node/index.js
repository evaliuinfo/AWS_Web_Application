const express = require('express');
const app = express();
app.listen(80, () => console.log('listening at 80'));
app.use(express.static('public'));

var global_request = "test"
// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
// Set the region
AWS.config.update({region: 'us-west-2'});

// Create an SQS service object
var sqs = new AWS.SQS({apiVersion: '2012-11-05'});

app.use(express.json({limit: '1gb'}));
app.post('/api', (request, response) => {
  console.log(request.body);
  global_request = request.body;
  var params = {
   // Remove DelaySeconds parameter and value for FIFO queues
    DelaySeconds: 1,
    MessageAttributes: {
      "Title": {
        DataType: "String",
        StringValue: "DataLog"
      }
    },
    MessageBody: request.body.ip_addr + request.body.geo_loc + request.body.usage_data,
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

