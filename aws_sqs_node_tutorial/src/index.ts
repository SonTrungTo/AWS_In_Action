import AWS, { SQS, AWSError } from "aws-sdk";

const awsConfig: AWS.ConfigurationOptions = {
    region: 'eu-west-1'
};
AWS.config.update(awsConfig);
const sqs = new SQS({ apiVersion: '2012-11-05' });

interface MessageContent {
    title: string;
    author: string;
    year: number;
}

const messageJSON: MessageContent = {
    title: "Star Wars: The Old Republic",
    author: "Bioware",
    year: 2012,
}

const params: SQS.ListQueuesRequest = {};
const createParams: SQS.CreateQueueRequest = {
    QueueName: 'ExampleQueue',
    Attributes: {
        'DelaySeconds': '60',
        'MessageRetentionPeriod': '86400',
    }
};
const getParams: SQS.GetQueueUrlRequest = {
    QueueName: 'ExampleQueue',
};
const sendParams: SQS.SendMessageRequest = {
    DelaySeconds: 10,
    MessageAttributes: {
        "Title": {
            DataType: "String",
            StringValue: "Revenge of the Sith",
        },
        "Author": {
            DataType: "String",
            StringValue: "George Lucas",
        },
        "Episode": {
            DataType: "Number",
            StringValue: "3"
        },
    },
    MessageBody: JSON.stringify(messageJSON),
    QueueUrl: "",
};
const receiveParams: SQS.ReceiveMessageRequest = {
    AttributeNames: [
        "Title",
        "Author",
        "Episode",
    ],
    MessageAttributeNames: [
        "All"
    ],
    MaxNumberOfMessages: 10,
    QueueUrl: '',
    VisibilityTimeout: 20,
    WaitTimeSeconds: 20,
};

(async () => {
   const createQueue = await new Promise((resolve, reject) => {
    sqs.createQueue(createParams, (err: AWSError, data: SQS.CreateQueueResult) => {
        if (err) {
            reject(err);
        } else {
            resolve(data.QueueUrl);
        }
    });
   });
   console.log(createQueue);

   const listQueue = await new Promise((resolve, reject) => {
    sqs.listQueues(params, (err: AWSError, data: SQS.ListQueuesResult) => {
        if (err) {
            reject(err);
        } else {
            resolve(data.QueueUrls);
        }
    });
   });
   console.log(listQueue);

   const getQueueUrl = await new Promise((resolve, reject) => {
    sqs.getQueueUrl(getParams, (err: AWSError, data: SQS.GetQueueUrlResult) => {
        if (err) {
            reject(err);
        } else {
            resolve(data.QueueUrl);
        }
    });
   });
   console.log(getQueueUrl);

   const messageId = await new Promise((resolve, reject) => {
    sqs.sendMessage({...sendParams, QueueUrl: String(getQueueUrl)}, (err: AWSError, data: SQS.SendMessageResult) => {
        if (err) {
            reject(err);
        } else {
            resolve(data.MessageId);
        }
    });
   });
   console.log(messageId);

   const receiveMessage = await new Promise((resolve, reject) => {
    sqs.receiveMessage({...receiveParams, QueueUrl: String(getQueueUrl)}, (err: AWSError, data: SQS.ReceiveMessageResult) => {
        if (err) {
            reject(err);
        } else {
            resolve(data.Messages);
        }
    });
   });
   console.log(receiveMessage);

   const deleteQueue = await new Promise((resolve, reject) => {
    sqs.deleteQueue({ QueueUrl: String(getQueueUrl) }, (err: AWSError, data) => {
        if (err) {
            reject(err);
        } else {
            resolve(data);
        }
    });
   });
   console.log(deleteQueue);
})();
