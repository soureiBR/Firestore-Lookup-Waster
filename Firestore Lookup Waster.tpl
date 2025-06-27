___INFO___

{
  "type": "MACRO",
  "id": "cvt_NS4CZ",
  "version": 1,
  "displayName": "Firestore Lookup Waster",
  "description": "The value is set to the value from a key in a Stape Store document.",
  "containerContexts": [
    "SERVER"
  ],
  "securityGroups": []
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "collection",
    "displayName": "Coleção no Firestore",
    "simpleValueType": true,
    "help": "Name of the collection in Firestore. If not specified, it will automatically be set to the container identifier in Waster."
  },
  {
    "type": "TEXT",
    "name": "documentId",
    "displayName": "Document ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "documentKey",
    "displayName": "Field Name",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "apiToken",
    "displayName": "Api Token",
    "simpleValueType": true,
    "help": "Credential required to perform writes and reads in firestore.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const logToConsole = require('logToConsole');
const sendHttpRequest = require('sendHttpRequest');
const JSON = require('JSON');
const setResponseStatus = require('setResponseStatus');
const setResponseBody = require('setResponseBody');
const getClientName = require('getClientName');

const collection = data.collection;
const documentId = data.documentId;

const dataCollection = collection ? '&collection=' + collection : '';

const firestoreUrl = "https://waster.sourei.com.br/firebase/store?documentId=" + documentId;
const fullUrl = firestoreUrl + dataCollection;

const clientName = getClientName();

if (clientName === 'Data Webhook' || clientName === 'Test Client') {
  const request = sendHttpRequest(fullUrl, {
    headers: {
      'Content-Type': 'application/json',
      'x-api-token': data.apiToken
    },
    method: 'GET',
    timeout: 10000
  });

  return request.then((response) => { 
    if (response.statusCode === 200 && response.body) {
      const body = JSON.parse(response.body);
      if (body) {
        logToConsole('Body', body);
        return body[data.documentKey];
      } else {
        logToConsole('No fields in response');
        return 'NO_FIELDS';
      }
    } else {
      return 'REQUEST_FAILED_' + response.statusCode;
    }
  }).catch((error) => {
    return 'NETWORK_ERROR';
  });
} else {
  return 'undefined';
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 24/01/2024, 14:06:55


