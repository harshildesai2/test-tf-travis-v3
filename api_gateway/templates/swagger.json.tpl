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
      },
      "options": {
        "x-amazon-apigateway-integration": {
          "responses": {
            "default": {
              "statusCode": "200"
            }
          },
          "passthroughBehavior": "when_no_match",
          "requestTemplates": {
            "application/json": "{\"statusCode\": 200}"
          },
          "type": "mock"
        }
      }
    },
    "/getsubscriberinfo": {
      "post": {
        "responses": {
          "200": {
            "description": "200 response",
            "headers": {
              "Access-Control-Allow-Origin": {
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {}
          }
        },
        "security": [
          {
            "sigv4": []
          },
          {
            "api_key": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "uri": "${getSubscriber_invoke_arn}",
          "passthroughBehavior": "when_no_match",
          "httpMethod": "POST",
          "type": "aws_proxy",
          "responses": {
            "default": {
              "statusCode": "200",
              "responseParameters": {
                "method.response.header.Access-Control-Allow-Origin": "'*'"
              }
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
                "method.response.header.Access-Control-Allow-Methods": "'OPTIONS,POST'",
                "method.response.header.Access-Control-Allow-Headers": "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'",
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
        "responses": {
          "200": {
            "description": "200 response",
            "headers": {
              "Access-Control-Allow-Origin": {
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {}
          }
        },
        "security": [
          {
            "sigv4": []
          },
          {
            "api_key": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "uri": "${getSubscriptionStatus_invoke_arn}",
          "passthroughBehavior": "when_no_match",
          "httpMethod": "POST",
          "type": "aws_proxy",
          "responses": {
            "default": {
              "statusCode": "200",
              "responseParameters": {
                "method.response.header.Access-Control-Allow-Origin": "'*'"
              }
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
                "method.response.header.Access-Control-Allow-Methods": "'OPTIONS,POST'",
                "method.response.header.Access-Control-Allow-Headers": "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'",
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
    "/sendsubscriberupdate": {
      "post": {
        "responses": {
          "200": {
            "description": "200 response",
            "headers": {
              "Access-Control-Allow-Origin": {
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {}
          }
        },
        "security": [
          {
            "api_key": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "uri": "${sendSubscriptionUpdate_invoke_arn}",
          "passthroughBehavior": "when_no_match",
          "httpMethod": "POST",
          "type": "aws_proxy",
          "responses": {
            "default": {
              "statusCode": "200",
              "responseParameters": {
                "method.response.header.Access-Control-Allow-Origin": "'*'"
              }
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
                "method.response.header.Access-Control-Allow-Methods": "'OPTIONS,POST'",
                "method.response.header.Access-Control-Allow-Headers": "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'",
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
      "api_key": {
        "type": "apiKey",
        "name": "x-api-key",
        "in": "header"
      },
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
          "arn:aws:execute-api:${region}:*:*/*/POST/getsubscriptionstatus"
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
        "Principal": "*",
        "Action": "execute-api:*",
        "Resource": [
          "arn:aws:execute-api:${region}:*:*/*/OPTIONS/getsubscriberinfo",
          "arn:aws:execute-api:${region}:*:*/*/OPTIONS/getsubscriptionstatus",
          "arn:aws:execute-api:${region}:*:*/*/OPTIONS/sendsubscriberupdate",
          "arn:aws:execute-api:${region}:*:*/*/POST/sendsubscriberupdate"
        ]
      }
    ]
  }
}