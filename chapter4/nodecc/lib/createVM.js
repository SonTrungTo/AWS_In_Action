const AWS = require('aws-sdk');
const ec2 = new AWS.EC2({
    region: 'us-east-1'
});

module.exports = (amiId, subnetId, cb) => {
    ec2.runInstances({
        ImageId: amiId,
        KeyName: 'mykey',
        InstanceType: 't2.micro',
        MinCount: 1,
        MaxCount: 1,
        SubnetId: subnetId
    }, (err) => {
        if (err) {
            cb(err);
        } else {
            cb(null);
        }
    });
};