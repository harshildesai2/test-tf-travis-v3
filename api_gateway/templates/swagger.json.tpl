{
  "openapi": "3.0.1",
  "info": {
    "title": "consent-management-${env_name}",
    "description": "Consent management responsys API"
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
    "/login": {
      "post": {
        "security": [
          {
            "sigv4": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "uri": "${login_invoke_arn}",
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
      },
      "options": {
        "responses": {
          "200": {
            "description": "200 response",
            "headers": {
              "Access-Control-Allow-Origin": {
                "schema": {
                  "type": "string"
                }
              },
              "Access-Control-Allow-Methods": {
                "schema": {
                  "type": "string"
                }
              },
              "Access-Control-Allow-Headers": {
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {}
          }
        },
        "x-amazon-apigateway-integration": {
          "responses": {
            "default": {
              "statusCode": "200",
              "responseParameters": {
                "method.response.header.Access-Control-Allow-Methods": "'*'",
                "method.response.header.Access-Control-Allow-Headers": "'*'",
                "method.response.header.Access-Control-Allow-Origin": "'*'"
              }
            }
          },
          "passthroughBehavior": "when_no_templates",
          "requestTemplates": {
            "application/json": "{\"statusCode\": 200}"
          },
          "type": "mock"
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
      },
      "options": {
        "responses": {
          "200": {
            "description": "200 response",
            "headers": {
              "Access-Control-Allow-Origin": {
                "schema": {
                  "type": "string"
                }
              },
              "Access-Control-Allow-Methods": {
                "schema": {
                  "type": "string"
                }
              },
              "Access-Control-Allow-Headers": {
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {}
          }
        },
        "x-amazon-apigateway-integration": {
          "responses": {
            "default": {
              "statusCode": "200",
              "responseParameters": {
                "method.response.header.Access-Control-Allow-Methods": "'*'",
                "method.response.header.Access-Control-Allow-Headers": "'*'",
                "method.response.header.Access-Control-Allow-Origin": "'*'"
              }
            }
          },
          "passthroughBehavior": "when_no_templates",
          "requestTemplates": {
            "application/json": "{\"statusCode\": 200}"
          },
          "type": "mock"
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
      },
      "options": {
        "responses": {
          "200": {
            "description": "200 response",
            "headers": {
              "Access-Control-Allow-Origin": {
                "schema": {
                  "type": "string"
                }
              },
              "Access-Control-Allow-Methods": {
                "schema": {
                  "type": "string"
                }
              },
              "Access-Control-Allow-Headers": {
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {}
          }
        },
        "x-amazon-apigateway-integration": {
          "responses": {
            "default": {
              "statusCode": "200",
              "responseParameters": {
                "method.response.header.Access-Control-Allow-Methods": "'*'",
                "method.response.header.Access-Control-Allow-Headers": "'*'",
                "method.response.header.Access-Control-Allow-Origin": "'*'"
              }
            }
          },
          "passthroughBehavior": "when_no_templates",
          "requestTemplates": {
            "application/json": "{\"statusCode\": 200}"
          },
          "type": "mock"
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
          "arn:aws:execute-api:${region}:*:*/*/POST/getsubscriberinfo",
          "arn:aws:execute-api:${region}:*:*/*/POST/getsubscriptionstatus",
          "arn:aws:execute-api:${region}:*:*/*/POST/updatesubscriberinfo"
        ]
      },
      {
          "Effect": "Allow",
          "Principal": {
              "AWS": "${apiexecution_user_arn_login}"
          },
          "Action": "execute-api:*",
          "Resource": "arn:aws:execute-api:${region}:*:*/*/POST/login"
      },
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "${apiexecution_user_arn_mobile}"
        },
        "Action": "execute-api:Invoke",
        "Resource": [
          "arn:aws:execute-api:${region}:*:*/*/POST/getsubscriberinfo",
          "arn:aws:execute-api:${region}:*:*/*/POST/getsubscriptionstatus",
          "arn:aws:execute-api:${region}:*:*/*/POST/updatesubscriberinfo"
        ]
      },
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "execute-api:*",
        "Resource": [
          "arn:aws:execute-api:${region}:*:*/*/OPTIONS/getsubscriberinfo",
          "arn:aws:execute-api:${region}:*:*/*/OPTIONS/getsubscriptionstatus",
          "arn:aws:execute-api:${region}:*:*/*/OPTIONS/updatesubscriberinfo"
        ]
      }
    ]
  }
}