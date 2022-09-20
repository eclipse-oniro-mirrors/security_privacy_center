/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CertInfo, certAbstract, CMResult, CMContext, AsyncCallback, BusinessError, CMHandle,
  Credential, CredentialAbstract, CMErrorCode, CMBlob, CMKeyProperties, CMSignatureSpec } from './certStubStruct'

export default class certStubUtil {
  constructor() {
  }

parseCertInfo(uri: string, certAlias: string, status: boolean, cert: Uint8Array): CertInfo {
  let certInfo: CertInfo;

  certInfo = {
    uri: uri,
    certAlias: certAlias,
    status: status,
    issuerName: "CN=SwissSign Gold CA - G2,OU=,O=SwissSign CA",
    subjectName: "CN=SwissSign Gold CA - G2,OU=,O=SwissSign CA",
    serial: "BB401C43F55E4FB0",
    notBefore: "1979/5/24",
    notAfter: "2030/5/24",
    fingerprintSha256: "D8:C5:38:8A:B7:30:1B:1B:6E:D4:7A:E6:45:25:3A:6F:9F:1A:27:61",
    cert: cert
  }

  return certInfo;
}

parseCertAbstract(uri: string, certAlias: string, status: boolean): certAbstract {
  let result: certAbstract;

  result = {
    uri: uri,
    certAlias: certAlias,
    status: status,
    subjectName: "CN=SwissSign Gold CA - G2,OU=,O=SwissSign",
  }

  return result;
}


parseCMHandle(errorCode: number, handle: number, token: Uint8Array): CMHandle {
  let result: CMHandle;

  result = {
    errorCode: errorCode,
    handle: handle,
    token: token,
  }

  return result;
}

parseCredential(type: string, alias: string, keyUri: string, certNum: number,
                         keyNum: number, credData: Uint8Array): Credential {
  let result: Credential;

  result = {
    type: type,
    alias: alias,
    keyUri: keyUri,
    certNum: certNum,
    keyNum: keyNum,
    credData: credData
  }

  return result;
}

parseCredentialAbstract(type: string, alias: string, keyUri: string): CredentialAbstract {
  let result: CredentialAbstract;

  result = {
    type: type,
    alias: alias,
    keyUri: keyUri
  }

  return result;
}

parseCMContext(userId: string, uid: string, packageName: string): CMContext {
  let result: CMContext;

  result = {
    userId: userId,
    uid: uid,
    packageName: packageName
  }

  return result;
}

parseCMBlob(inData: Uint8Array, alias: string): CMBlob {
  let result: CMBlob;

  result = {
    inData: inData,
    alias: alias
  }

  return result;
}

parseCMKeyProperties(): CMKeyProperties {
  let result: CMKeyProperties;

  result = {
    type: "CM_URI_TYPE_APP_KEY", // Type of the key, must be CM_URI_TYPE_APP_KEY or CM_URI_TYPE_WLAN_KEY
    alg: "alg",
    size: 375,
    padding: "padding purpose",
    purpose: "purpose property",
    digest: "digest property",
    authType: "Sha-256",
    authTimeout: "30"
  }

  return result;
}

parseCMSignatureSpec(alg: string, padding: string, digest: string, authToken: Uint8Array): CMSignatureSpec {
  let result: CMSignatureSpec;

  result = {
    alg: alg,
    padding: padding,
    digest: digest,
    authToken: authToken // required only for user authentication
  }

  return result;
}

}