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

export interface CertInfo {
  uri: string,
  certAlias: string,
  status: boolean,
  issuerName: string,
  subjectName: string,
  serial: string,
  notBefore: string,
  notAfter: string,
  fingerprintSha256: string,
  cert: Uint8Array
}

export interface certAbstract {
  uri: string,
  certAlias: string,
  status: boolean,
  subjectName: string,
}

export interface CMResult {
  certList?: Array<certAbstract>,
  certInfo?: CertInfo,
  credentialList?:Array<CredentialAbstract>,
  credential?: Credential,
  appUidList?: Array<string>
  authUri?: string,
  outData?: Uint8Array,
  isAuth?: boolean
}

export interface CMHandle {
  errorCode: number,
  handle: number;
  token?: Uint8Array;
}

export interface Credential {
  type: string,
  alias: string,
  keyUri: string,
  certNum: number,
  keyNum: number,
  credData: Uint8Array
}

export interface CredentialAbstract {
  type: string,
  alias: string,
  keyUri: string
}

export interface CMContext {
  userId: string,
  uid: string,
  packageName: string
};

export interface CMBlob {
  readonly inData?: Uint8Array,
  readonly alias?: string
};

export interface CMKeyProperties {
  type: string; // Type of the key, must be CM_URI_TYPE_APP_KEY or CM_URI_TYPE_WLAN_KEY
  alg: string;
  size: number;
  padding: string;
  purpose: string;
  digest: string;
  authType: string;
  authTimeout: string;
};

export interface CMSignatureSpec {
  alg: string;
  padding: string;
  digest: string;
  authToken: Uint8Array; // required only for user authentication
};

export enum CertManagerStore {
  CERT_MANAGER_CREDENTIAL_STORE = 0, /* credential certificate store for end entity certificates. */
  CERT_MANAGER_SYSTEM_TRUSTED_STORE = 1, /* read only, updated by system only. */
  CERT_MANAGER_USER_TRUSTED_STORE = 2, /* modifiable by applications and user. */
  CERT_MANAGER_APPLICATION_TRUSTED_STORE = 3, /* application specific trusted certificate store; modifiable by the application only. */
}

export enum CMErrorCode {
  CMR_SUCCESS = 0,
  CMR_FAILURE = -1,
  CMR_ERROR_INSTALL_CERTIFICATE = -2,
  CMR_ERROR_SET_STATUS = -3,
  CMR_ERROR_INVALID_ARGUMENT = -3,
  CMR_ERROR_INVALID_STORE = -4,
  CMR_ERROR_NOT_SUPPORTED = -5,
  CMR_ERROR_UNINSTALL = -6,
  CMR_ERROR_NO_PERMISSION = -7,
  CMR_ERROR_INSUFFICIENT_DATA = -8,
  CMR_ERROR_GET_CERTIRICATE = -9,
  CMR_ERROR_STORAGE_FAILURE = -10,
  CMR_ERROR_HARDWARE_FAILURE = -11,
  CMR_ERROR_ALREADY_EXISTS = -12,
  CMR_ERROR_NOT_EXIST = -13,
  CMR_ERROR_NULL_POINTER = -14,
  CMR_ERROR_FILE_SIZE_FAIL = -15,
  CMR_ERROR_READ_FILE_FAIL = -16,
  CMR_ERROR_INVALID_PUBLIC_KEY = -17,
  CMR_ERROR_INVALID_PRIVATE_KEY = -18,
  CMR_ERROR_INVALID_KEY_INFO = -19,
  CMR_ERROR_REMOVE_CERTIFICATE_FAIL = -20,
  CMR_ERROR_OPEN_FILE_FAIL = -21,
  CMR_ERROR_INVALID_KEY_FILE = -22,
  CMR_ERROR_IPC_MSG_FAIL = -23,
  CMR_ERROR_REQUEST_OVERFLOWS = -24,
  CMR_ERROR_PARAM_NOT_EXIST = -25,
  CMR_ERROR_CRYPTO_ENGINE_ERROR = -26,
  CMR_ERROR_COMMUNICATION_TIMEOUT = -27,
  CMR_ERROR_IPC_INIT_FAIL = -28,
  CMR_ERROR_IPC_DLOPEN_FAIL = -29,
  CMR_ERROR_EFUSE_READ_FAIL = -30,

  CMR_ERROR_CHECK_GET_ALG_FAIL = -100,
  CMR_ERROR_CHECK_GET_KEY_SIZE_FAIL = -101,
  CMR_ERROR_CHECK_GET_PADDING_FAIL = -102,
  CMR_ERROR_INVALID_DIGEST = -117,

  CMR_ERROR_INTERNAL_ERROR = -999,
  CMR_ERROR_UNKNOWN_ERROR = -1000,
}

export interface BusinessError {
  /**
   * Defines the basic error code.
   * @since 6
   */
  code: number;
}

export interface AsyncCallback<T> {
  /**
   * Defines the callback data.
   * @since 6
   */
  (err: BusinessError, data: T): void;
}