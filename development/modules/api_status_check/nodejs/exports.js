'use strict';
const HTTPS = require('https');
const fetch = require('node-fetch');
const AWS = require('aws-sdk');
const SSM = new AWS.SSM();
const QUERYSTRING = require('querystring');
const { send } = require('process');
const SLACK_WEBHOOK_HOST = "hooks.slack.com"


exports.handler = async (event) => {
    // 監視対象のURL
    var url = "https://www.example.com";
    var channel = process.env['slack_channel'];
    const webhookUrl = await SSM.getParameter({
        Name: 'slack_alarm_webhook_endpoint',
        WithDecryption: true
    }).promise();
    
    const response = await fetch(url);
    const code = await response.status;
    if (code == 200) {
        console.log("200 OK");
    } else {
        await sendSlack(SLACK_WEBHOOK_HOST, webhookUrl.Parameter.Value.replace("https://"+SLACK_WEBHOOK_HOST, ""), url+" is down at lambda request", channel);
        console.log("Status Error: " + code);
    }
};

async function sendSlack(hostname, path, message, channel) {
    var data = JSON.stringify({"username":"aws_alarm","text": message,"icon_emoji":":ghost:", "channel":channel});

    const options = {
        hostname: hostname,
        port: 443,
        path: path,
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(data)
        }
    };

    let req = await HTTPS.request(options, function(res) {
        res.on('data', function(d) {
            console.log(d + "\n");
        });
    });
    req.on('error', function(e) {
        console.log("Slackにメッセージを送信できませんでした\n" + e.message);
    });
    req.write(data);
    req.end();
}