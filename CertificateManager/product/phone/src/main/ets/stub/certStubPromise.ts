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

import { CMResult, BusinessError, CMErrorCode, CMBlob, CMSignatureSpec, CertManagerStore } from './certStubStruct';
import  certStubUtil  from './certStubUtil';
import fileio from '@ohos.fileio';

var certUtil = new certStubUtil();
const TAG = "CertManager Stub: ";
const certNum = 10
const keyNum = 20
const authorListA = ["20010027", "20010026", "10003", "20010013","20010033"]
const authorListB = ["20010033", "10003", "20010027"]
const authorListC = ["20010032", "20010013", "20010026", "10003"]

export class CertStubPromise {
    exceptFlag = 0;
    uriBase = "uri://stub/certFile/"
    type = "CM_URI_TYPE_APP_KEY"
    uriCount = 0;
    systemCertMap = new Map();
    userCertMap = new Map();
    uriToAlias = new Map();
    appCredMap = new Map();
    privateCredMap = new Map();
    uriToAppList = new Map();

    constructor() {
        let newCert;

        console.log(TAG + "getSystemTrustedCertificateList stub constructor start");
        newCert = certUtil.parseCertInfo(this.uriBase + this.uriCount.toString(),
            "SystemRoot_1", true, new Uint8Array([0, 1, 2, 42, 100, 101, 102, 255]));
        this.systemCertMap.set(this.uriBase + this.uriCount.toString(), newCert);
        this.uriCount++;

        newCert = certUtil.parseCertInfo(this.uriBase + this.uriCount.toString(),
            "SystemRoot_2", false, new Uint8Array([64, 1, 2, 42, 100, 123, 321, 255]));
        this.systemCertMap.set(this.uriBase + this.uriCount.toString(), newCert);
        this.uriCount++;

        newCert = certUtil.parseCertInfo(this.uriBase + this.uriCount.toString(),
            "SystemRoot_3", true, new Uint8Array([54, 1, 123, 42, 100, 101, 102, 23]));
        this.systemCertMap.set(this.uriBase + this.uriCount.toString(), newCert);
        this.uriCount++;

        newCert = certUtil.parseCertInfo(this.uriBase + this.uriCount.toString(),
            "UserRoot_1", true, new Uint8Array([0, 1, 2, 42, 100, 101, 102, 255]));
        this.userCertMap.set("UserRoot_1", newCert);
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "UserRoot_1")
        this.uriCount++;

        newCert = certUtil.parseCertInfo(this.uriBase + this.uriCount.toString(),
            "UserRoot_2", false, new Uint8Array([0, 1, 2, 42, 100, 101, 102, 255]));
        this.userCertMap.set("UserRoot_2", newCert);
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "UserRoot_2")
        this.uriCount++;

        newCert = certUtil.parseCertInfo(this.uriBase + this.uriCount.toString(),
            "UserRoot_3", true, new Uint8Array([0, 1, 2, 42, 100, 101, 102, 255]));
        this.userCertMap.set("UserRoot_3", newCert);
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "UserRoot_3")
        this.uriCount++;

        newCert = certUtil.parseCredential(this.type, "TheEncryptionForCCMPV1", this.uriBase + this.uriCount.toString(), certNum, keyNum,
            new Uint8Array([25, 5, 34, 45, 64, 78, 7, 8]));
        this.appCredMap.set("ApptemRoot_1", newCert);
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "ApptemRoot_1")
        this.uriToAppList.set(this.uriBase + this.uriCount.toString(), authorListA)
        this.uriCount++;

        newCert = certUtil.parseCredential(this.type, "TheEncryptionForCCMPV2", this.uriBase + this.uriCount.toString(), certNum, keyNum,
            new Uint8Array([23, 1, 43, 42, 78, 90, 56, 12]));
        this.appCredMap.set("ApptemRoot_2", newCert);
        this.uriToAppList.set(this.uriBase + this.uriCount.toString(), authorListB)
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "ApptemRoot_2")
        this.uriCount++;

        newCert = certUtil.parseCredential(this.type, "TheEncryptionForCCMPV3", this.uriBase + this.uriCount.toString(), certNum, keyNum,
            new Uint8Array([21, 1, 32, 645, 100, 101, 102, 23]));
        this.appCredMap.set("ApptemRoot_3", newCert);
        this.uriToAppList.set(this.uriBase + this.uriCount.toString(), authorListC)
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "ApptemRoot_3")
        this.uriCount++;

        newCert = certUtil.parseCredential(this.type, "Employee_WPA_EAPIEA", this.uriBase + this.uriCount.toString(), certNum, keyNum,
            new Uint8Array([32, 41, 54, 67, 77, 98, 91, 123]));
        this.privateCredMap.set("PrivatetemRoot_1", newCert);
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "PrivatetemRoot_1")
        this.uriCount++;

        newCert = certUtil.parseCredential(this.type, "Employee_WPA_EAPIEB", this.uriBase + this.uriCount.toString(), certNum, keyNum,
            new Uint8Array([34, 65, 67, 68, 33, 77, 14, 18]));
        this.privateCredMap.set("PrivatetemRoot_2", newCert);
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "PrivatetemRoot_2")
        this.uriCount++;

        newCert = certUtil.parseCredential(this.type, "Employee_WPA_EAPIEC", this.uriBase + this.uriCount.toString(), certNum, keyNum,
            new Uint8Array([12, 3, 54, 76, 8, 123, 43, 55]));
        this.privateCredMap.set("PrivatetemRoot_3", newCert);
        this.uriToAlias.set(this.uriBase + this.uriCount.toString(), "PrivatetemRoot_3")
        this.uriCount++;
    }

    getSystemTrustedCertificateList() {
        return new Promise<CMResult>((resolve, reject) => {
            let error: BusinessError;
            let data: CMResult;
            let certList = new Array();

            if (!this.exceptFlag) {
                console.log(TAG + "getSystemTrustedCertificateList stub start");
                this.systemCertMap.forEach((data, keyUri) => {
                    certList.push(this.systemCertMap.get(keyUri))
                })
                data = {
                    certList: certList
                };
                resolve(data);
            } else {
                error = {
                    code: CMErrorCode.CMR_FAILURE,
                };
                reject(error);
            }
        })
    }

    getSystemTrustedCertificate(certUri: string) {
        return new Promise<CMResult>((resolve, reject) => {
            let data: CMResult;
            let error: BusinessError;

            if (this.systemCertMap.has(certUri)) {
                data = {
                    certInfo: this.systemCertMap.get(certUri)
                };
                resolve(data);
            } else {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }
        })
    }

    setCertificateStatus(certUri: string, store: number, status: boolean) {
        return new Promise<void>((resolve, reject) => {
            let error: BusinessError;
            let alias;

            if ((!this.systemCertMap.has(certUri)) &&
            (!this.uriToAlias.has(certUri))) {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }

            if (store == CertManagerStore.CERT_MANAGER_SYSTEM_TRUSTED_STORE) {
                this.systemCertMap.get(certUri).status = status;
                resolve();
            } else if (store == CertManagerStore.CERT_MANAGER_USER_TRUSTED_STORE) {
                alias = this.uriToAlias.get(certUri);
                this.userCertMap.get(alias).status = status;
                resolve();
            } else {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_SUPPORTED,
                };
                reject(error);
            }
        })
    }

    installUserTrustedCertificate(certificate: CMBlob) {
        return new Promise<void>((resolve, reject) => {
            let newCert = certUtil.parseCertInfo(this.uriBase + this.uriCount.toString(),
                certificate.alias, true, certificate.inData);
            this.userCertMap.set(certificate.alias, newCert);
            this.uriToAlias.set(this.uriBase + this.uriCount.toString(), certificate.alias)
            this.uriCount++;

            resolve();
        })
    }

    uninstallAllUserTrustedCertificate() {
        return new Promise<void>((resolve, reject) => {
            console.log(TAG + "uninstallAllUserTrustedCertificate stub in");
            this.userCertMap.clear();
            this.uriToAlias.clear();
            resolve();
        })
    }

    uninstallUserTrustedCertificate(certUri: string) {
        return new Promise<void>((resolve, reject) => {
            let error: BusinessError;
            let alias;

            if (!this.uriToAlias.has(certUri)) {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }

            alias = this.uriToAlias.get(certUri);
            this.uriToAlias.delete(certUri);
            this.userCertMap.delete(alias);
            resolve();
        })
    }

    getUserTrustedCertificateList() {
        return new Promise<CMResult>((resolve, reject) => {
            let error: BusinessError;
            let data: CMResult;
            let certList = new Array();

            if (!this.exceptFlag) {
                this.userCertMap.forEach((data, keyAlias) => {
                    certList.push(this.userCertMap.get(keyAlias))
                })

                data = {
                    certList: certList
                };
                resolve(data);
            } else {
                error = {
                    code: CMErrorCode.CMR_FAILURE,
                };
                reject(error);
            }
        })
    }

    getUserTrustedCertificate(certUri: string) {
        return new Promise<CMResult>((resolve, reject) => {
            let data: CMResult;
            let error: BusinessError;

            if (this.uriToAlias.has(certUri)) {
                let alias = this.uriToAlias.get(certUri);
                data = {
                    certInfo: this.userCertMap.get(alias)
                };
                resolve(data);
            } else {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }
        })
    }

    installAppCertificate(keystore: Uint8Array, keystorePwd: string, certAlias: string) {
        return new Promise<void>((resolve, reject) => {
            let newCred = certUtil.parseCredential(this.type, certAlias, this.uriBase + this.uriCount.toString(),
                certNum, keyNum, keystore);
            this.appCredMap.set(certAlias, newCred);
            this.uriToAlias.set(this.uriBase + this.uriCount.toString(), certAlias)
            this.uriCount++;

            resolve();
        })
    }

    installPrivateCertificate(keystore: Uint8Array, keystorePwd: string, certAlias: string) {
        return new Promise<void>((resolve, reject) => {
            let newCred = certUtil.parseCredential("privateCred", certAlias, this.uriBase + this.uriCount.toString(),
                1, 1, keystore);
            this.privateCredMap.set(certAlias, newCred);
            this.uriToAlias.set(this.uriBase + this.uriCount.toString(), certAlias);
            this.uriCount++;

            resolve();
        })
    }

    uninstallAllAppCertificate() {
        return new Promise<void>((resolve, reject) => {
            console.log(TAG + "uninstallAllAppCertificate stub in");
            this.appCredMap.clear();
            this.privateCredMap.clear();

            resolve();
        })
    }

    uninstallAppCertificate(keyUri: string) {
        return new Promise<void>((resolve, reject) => {
            let alias;
            let error: BusinessError;

            if (!this.uriToAlias.has(keyUri)) {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }

            alias = this.uriToAlias.get(keyUri);
            this.uriToAlias.delete(keyUri);
            this.appCredMap.delete(alias);

            resolve();
        })
    }

    uninstallPrivateCertificate(keyUri) {
        return new Promise<void>((resolve, reject) => {
            let alias;
            let error: BusinessError;

            if (!this.uriToAlias.has(keyUri)) {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }

            alias = this.uriToAlias.get(keyUri);
            this.uriToAlias.delete(keyUri);
            this.privateCredMap.delete(alias);

            resolve();
        })
    }

    getAppCertificateList() {
        return new Promise<CMResult>((resolve, reject) => {
            let error: BusinessError;
            let data: CMResult;
            let credList = new Array();

            if (!this.exceptFlag) {
                this.appCredMap.forEach((data, keyAlias) => {
                    credList.push(this.appCredMap.get(keyAlias))
                })

                data = {
                    credentialList: credList
                };
                resolve(data);
            } else {
                error = {
                    code: CMErrorCode.CMR_FAILURE,
                };
                reject(error);
            }
        })
    }

    getPrivateCertificateList() {
        return new Promise<CMResult>((resolve, reject) => {
            let error: BusinessError;
            let data: CMResult;
            let credList = new Array();

            if (!this.exceptFlag) {
                this.privateCredMap.forEach((data, keyAlias) => {
                    credList.push(this.privateCredMap.get(keyAlias))
                })

                data = {
                    credentialList: credList
                };
                resolve(data);
            } else {
                error = {
                    code: CMErrorCode.CMR_FAILURE,
                };
                reject(error);
            }
        })
    }

    getAppCertificate(keyUri: string) {
        return new Promise<CMResult>((resolve, reject) => {
            let data: CMResult;
            let error: BusinessError;

            if (this.uriToAlias.has(keyUri)) {
                let alias = this.uriToAlias.get(keyUri);
                data = {
                    credential: this.appCredMap.get(alias)
                };
                resolve(data);
            } else {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }
        })
    }

    getPrivateCertificate(keyUri: string) {
        return new Promise<CMResult>((resolve, reject) => {
            let data: CMResult;
            let error: BusinessError;

            if (this.uriToAlias.has(keyUri)) {
                let alias = this.uriToAlias.get(keyUri);
                data = {
                    credential: this.privateCredMap.get(alias)
                };
                resolve(data);
            } else {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }
        })
    }

    grantAppCertificate(keyUri: string, clientAppUid: string) {
        return new Promise<CMResult>((resolve, reject) => {
            let appList: Array<string>;
            let data: CMResult;
            let error: BusinessError;

            console.log(TAG + "grantAppCertificate stub uri: " + keyUri + " clientAppUid: " + clientAppUid);
            if (!this.uriToAlias.has(keyUri)) {
                error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }

            if (this.uriToAppList.has(keyUri)) {
                appList = this.uriToAppList.get(keyUri);
            } else {
                appList = new Array();
            }

            appList.push(clientAppUid);
            this.uriToAppList.set(keyUri, appList)
            data = {
                authUri: "authUri-value"
            };
            console.log(TAG + "grantAppCertificate stub uriToAppList: " + JSON.stringify(appList));

            resolve(data);
        })
    }

    isAuthorizedApp(keyUri: string) {
        return new Promise<CMResult>((resolve, reject) => {
            let data: CMResult;
            data = {
                isAuth: false
            };
            resolve(data);
        })
    }

    getAuthorizedAppList(keyUri: string) {
        return new Promise<CMResult>((resolve, reject) => {
            let data: CMResult;
            let appList: Array<string>;

            if ((!this.uriToAlias.has(keyUri)) || (!this.uriToAppList.has(keyUri))) {
                data = {
                    appUidList: appList,
                };
                resolve(data);
            }

            appList = this.uriToAppList.get(keyUri);

            data = {
                appUidList: appList
            };
            resolve(data);
        })
    }

    removeGrantedAppCertificate(keyUri: string, clientAppUid: string) {
        return new Promise<void>((resolve, reject) => {
            let appList: Array<string>;

            if ((!this.uriToAlias.has(keyUri)) || (!this.uriToAppList.has(keyUri))) {
                let error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }

            appList = this.uriToAppList.get(keyUri);
            if (appList.indexOf(clientAppUid) != -1) {
                appList = appList.filter(item => item != clientAppUid);
                this.uriToAppList.set(keyUri, appList);
                resolve();
            } else {
                let error = {
                    code: CMErrorCode.CMR_ERROR_NOT_EXIST,
                };
                reject(error);
            }
        })
    }

    init(authUri: string, spec: CMSignatureSpec) {
        return new Promise<void>((resolve, reject) => {
            let errorCode = CMErrorCode.CMR_SUCCESS;
            let data: CMResult;

            resolve();
        })
    }

    update(handle: number, data: Uint8Array, token?: Uint8Array) {
        return new Promise<void>((resolve, reject) => {
            let errorCode = CMErrorCode.CMR_SUCCESS;
            let data: CMResult;

            resolve();
        })
    }

    finish(handle: number, signature?: Uint8Array) {
        return new Promise<void>((resolve, reject) => {
            let errorCode = CMErrorCode.CMR_SUCCESS;
            let data: CMResult;

            resolve();
        })
    }

    abort(handle: number) {
        return new Promise<void>((resolve, reject) => {
            let errorCode = CMErrorCode.CMR_SUCCESS;
            let data: CMResult;

            resolve();
        })
    }

    mapToJson(map) {
        let obj = Object.create(null);
        for (let [k, v] of map) {
            obj[k] = v;
        }

        return JSON.stringify(obj)
    }

    jsonToMap(jsonString) {
        console.log(TAG + "jsonToMap start");
        let map = new Map();
        let obj = JSON.parse(jsonString);

        for (let k of Object.keys(obj)) {
            map.set(k, obj[k])
        }
        return map;
    }

    saveAllMaps() {
        console.log(TAG + "saveAllMaps start");
        let dataList = [
            this.mapToJson(this.systemCertMap),
            this.mapToJson(this.userCertMap),
            this.mapToJson(this.uriToAlias),
            this.mapToJson(this.appCredMap),
            this.mapToJson(this.privateCredMap),
            this.mapToJson(this.uriToAppList)
        ];

        let context = globalThis.certManagerAbilityContext;
        let path = context.cacheDir;
        path += '/certStubData'
        try {
            fileio.unlinkSync(path);
        } catch (err) {
            console.log(TAG + "saveAllMaps unlinkSync err: " + err);
        }

        try {
            let fd = fileio.openSync(path, 0o102, 0o600);
            fileio.writeSync(fd, JSON.stringify(dataList));
            fileio.closeSync(fd);
        } catch (err) {
            console.log(TAG + "saveAllMaps File operation fail, err: " + err);
            return;
        }

        console.log(TAG + "saveAllMaps success");
    }

    uint8ArrayToString(fileData) {
        var dataString = "";
        for (var i = 0; i < fileData.length; i++) {
            dataString += String.fromCharCode(fileData[i]);
        }
        return dataString
    }

    restoreMapsFromJson(json) {
        console.log(TAG + "restoreMapsFromJson start Json: " + json);
        let dataList = JSON.parse(json);
        this.systemCertMap = this.jsonToMap(dataList[0]);
        this.userCertMap = this.jsonToMap(dataList[1]);
        this.uriToAlias = this.jsonToMap(dataList[2]);
        this.appCredMap = this.jsonToMap(dataList[3]);
        this.privateCredMap = this.jsonToMap(dataList[4]);
        this.uriToAppList = this.jsonToMap(dataList[5]);
        console.log(TAG + "restoreMapsFromJson end");
    }

    restoreAllMaps() {
        console.log(TAG + "getAllMaps start");
        let context = globalThis.certManagerAbilityContext;
        let path = context.cacheDir;
        path += '/certStubData'

        try {
            let fd = fileio.openSync(path, 0o002, 0o666);
            console.log(TAG + "getAllMaps fd: " + fd);
            let stat = fileio.fstatSync(fd);
            let size = stat.size;
            let buf = new ArrayBuffer(size);

            fileio.read(fd, buf, (err, data) => {
                if (data) {
                    this.restoreMapsFromJson(this.uint8ArrayToString(new Uint8Array(data.buffer)));
                }
                fileio.closeSync(fd);
            });
        } catch(err) {
            console.log(TAG + "getAllMaps err: " + err);
        }

        console.log(TAG + "getAllMaps end");
    }
}

let certStub = new CertStubPromise();

export default certStub as CertStubPromise;