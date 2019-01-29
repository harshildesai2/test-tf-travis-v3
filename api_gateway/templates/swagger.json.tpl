{
  "openapi": "3.0.1",
  "info": {
    "title": "consent-management-${env_name}",
    "version": "2019-01-11T23:09:00Z"
  },
  "servers": [
    {
      "url": "*.execute-api.${region}.amazonaws.com/{basePath}",
      "variables": {
        "basePath": {
          "default": "/devenv"
        }
      }
    }
  ],
  "paths": {
    "/getsubscriberinfo": {
      "post": {
        "security": [
          {
            "sigv4": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "uri": "${getSubscriber_invoke_arn}",
          "passthroughBehavior": "when_no_match",
          "httpMethod": "POST",
          "type": "aws_proxy",
          "responses": {
            "default": {
              "statusCode": "200"
            }
          }
        }
      }
    },
    "/getsubscriptionstatus": {
      "post": {
        "security": [
          {
            "sigv4": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "uri": "${getSubscriptionStatus_invoke_arn}",
          "passthroughBehavior": "when_no_match",
          "httpMethod": "POST",
          "type": "aws_proxy",
          "responses": {
            "default": {
              "statusCode": "200"
            }
          }
        }
      }
    },
    "/updatesubscriberinfo": {
      "post": {
        "security": [
          {
            "sigv4": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "uri": "${updateSubscriber_invoke_arn}",
          "passthroughBehavior": "when_no_match",
          "httpMethod": "POST",
          "type": "aws_proxy",
          "responses": {
            "default": {
              "statusCode": "200"
            }
          }
        }
      }
    }
  },
  "components": {
    "securitySchemes": {
      "sigv4": {
        "type": "apiKey",
        "name": "Authorization",
        "in": "header",
        "x-amazon-apigateway-authtype": "awsSigv4"
      }
    }
  },
  "x-amazon-apigateway-policy": {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "${apiexecution_user_arn}"
        },
        "Action": "execute-api:Invoke",
        "Resource": [
          "arn:aws:execute-api:us-east-1:*:*/*/POST/getsubscriberinfo",
          "arn:aws:execute-api:us-east-1:*:*/*/POST/getsubscriptionstatus",
          "arn:aws:execute-api:us-east-1:*:*/*/POST/updatesubscriberinfo"
        ]
      }
    ]
  }
}