/**
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import picker from '@ohos.file.picker';
import router from '@ohos.router';
import certManagerModel from '../model/CertMangerModel';
import FileIoModel from '../model/FileIoModel';
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';
import { BusinessError } from '@ohos.base';
import { RouterFileVo, RouterAppUidVo } from '../model/CertManagerVo/RouterInfoVo';

const TAG = 'CMFaPresenter: ';
const PAGE_URI_PWD_INPUT = 'pages/certPwdInput';
const PAGE_URI_ALIAS_INPUT = 'pages/certInstallAliasInput';

export default class CmFaPresenter {
  private static sInstance: CmFaPresenter;

  public static getInstance(): CmFaPresenter {
    if (CmFaPresenter.sInstance == null) {
      CmFaPresenter.sInstance = new CmFaPresenter();
    }
    return CmFaPresenter.sInstance;
  }

  onAboutToAppear(): void {

  }

  aboutToDisappear(): void {
  }

  routeToNextInstallCert(fileUri: string): void {
    console.log(TAG, 'routeToNext fileUri ' + fileUri);
    FileIoModel.getMediaFileSuffix(fileUri, (suffix: string | undefined) => {
      if (suffix !== undefined) {
        console.log(TAG, 'suffix = ', suffix);
        let fileInfo = new RouterFileVo(fileUri, suffix);
        if ((suffix === 'cer') || (suffix === 'pem')) {
          router.replaceUrl({
            url: 'pages/certInstallAliasInput',
            params: fileInfo
          })
        } else {
          AlertDialog.show({
            message: $r('app.string.Install_Error_NOT_FOUND'),
            autoCancel: true,
            alignment: DialogAlignment.Bottom,
            offset: {
              dx: 0, dy: 0
            },
            gridCount: 4,
            primaryButton: {
              value: $r('app.string.OK'),
              action: () => {
              }
            },
          })
        }
      }
    })
  }

  routeToNextInstallEvidence(fileUri: string): void {
    console.log(TAG, 'routeToNext fileUri ' + fileUri);
    FileIoModel.getMediaFileSuffix(fileUri, (suffix: string | undefined) => {
      if (suffix !== undefined) {
        console.log(TAG, 'suffix = ', suffix);
        if ((suffix === 'p12') || (suffix === 'pfx')) {
          let fileInfo = new RouterFileVo(fileUri, suffix);
          router.replaceUrl({
            url: 'pages/certPwdInput',
            params: fileInfo
          })
        } else {
          AlertDialog.show({
            message: $r('app.string.Install_Error_NOT_FOUND'),
            autoCancel: true,
            alignment: DialogAlignment.Bottom,
            offset: {
              dx: 0, dy: -20
            },
            gridCount: 4,
            primaryButton: {
              value: $r('app.string.OK'),
              action: () => {
              }
            },
          })
        }
      }
    })
  }

  startInstallCert(): void {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      let documentPicker = new picker.DocumentViewPicker();
      console.info(TAG + 'start documentPicker.select');
      documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
        if (documentSelectResult.length >= 1) {
          this.routeToNextInstallCert(String(documentSelectResult[0]))
        } else {
          console.error(TAG + 'documentPicker.select length invalid:' + documentSelectResult.length);
        }
      }).catch((err: BusinessError) => {
        console.error(TAG + 'documentPicker.select failed with err, message: ' + err.message + ', code: ' + err.code);
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(TAG + 'DocumentViewPicker failed with err, message: ' + e.message + ', code: ' + e.code);
    }
  }

  startInstallEvidence(): void {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      let documentPicker = new picker.DocumentViewPicker();
      console.info(TAG + 'start documentPicker.select');
      documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
        if (documentSelectResult.length >= 1) {
          this.routeToNextInstallEvidence(String(documentSelectResult[0]))
        } else {
          console.error(TAG + 'documentPicker.select length invalid:' + documentSelectResult.length);
        }
      }).catch((err: BusinessError) => {
        console.error(TAG + 'documentPicker.select failed with err, message: ' + err.message + ', code: ' + err.code);
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(TAG + 'DocumentViewPicker failed with err, message: ' + e.message + ', code: ' + e.code);
    }
  }

  startRequestAuth(uri: string): void {
    let appUidInfo = new RouterAppUidVo(uri);
    router.replaceUrl({
      url: 'pages/requestAuth',
      params: appUidInfo
    });
  }

  uninstallAllCert(): void {
    certManagerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, (errCode: CMModelErrorCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_USER_CA success');
      } else {
        console.error(TAG + 'uninstallAllCert CM_MODEL_OPT_USER_CA failed');
      }
    });

    certManagerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, (errCode: CMModelErrorCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_APP_CRED success');
      } else {
        console.error(TAG + 'uninstallAllCert CM_MODEL_OPT_APP_CRED failed');
      }
    });
  }
}