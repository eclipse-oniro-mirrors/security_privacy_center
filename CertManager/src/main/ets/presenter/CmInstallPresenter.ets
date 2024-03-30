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

import certManagerModel from '../model/CertMangerModel';
import FileIoModel from '../model/FileIoModel';
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';
import router from '@ohos.router';
import { GlobalContext } from '../common/GlobalContext';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';

const TAG = 'CMInstallPresenter: ';

export default class CmInstallPresenter {
  private static sInstance: CmInstallPresenter;
  private optType: CMModelOptType = CMModelOptType.CM_MODEL_OPT_UNKNOWN;

  public static getInstance(): CmInstallPresenter {
    if (CmInstallPresenter.sInstance == null) {
      CmInstallPresenter.sInstance = new CmInstallPresenter();
    }
    return CmInstallPresenter.sInstance;
  }

  onAboutToAppear(): void {

  }

  aboutToDisappear(): void {
    this.optType = CMModelOptType.CM_MODEL_OPT_UNKNOWN;
  }

  updateCertFileType(suffix: string): void {
    console.info(TAG + 'updateCertFileType suffix: ' + suffix);
    if ((suffix === 'cer') || (suffix === 'pem')) {
      this.optType = CMModelOptType.CM_MODEL_OPT_USER_CA;
    } else if ((suffix === 'p12') || (suffix === 'jks') || (suffix === 'pfx')) {
      this.optType = CMModelOptType.CM_MODEL_OPT_APP_CRED;
    }
  }

  getFileDataFromUri(uri: string, callback: Function): void {
    FileIoModel.getMediaFileData(uri, (data: Uint8Array) => {
      callback(data);
    });
  }

  installCert(uri: string, alias: string, suffix: string): void {
    this.updateCertFileType(suffix);
    this.getFileDataFromUri(uri, (data: Uint8Array) => {
      certManagerModel.installCertOrCred(this.optType, alias, data,
        GlobalContext.getContext().getPwdStore().getCertPwd(), (errCode: CMModelErrorCode) => {
          console.info(TAG + 'installCertOrCred result: ' + JSON.stringify(errCode));
          GlobalContext.getContext().getPwdStore().clearCertPwd();
          if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
            try {
              promptAction.showToast({
                message: this.optType === CMModelOptType.CM_MODEL_OPT_USER_CA ?
                $r('app.string.Install_Cert_Success') : $r('app.string.Install_Cred_Success'),
                duration: 2000,
                bottom: 100
              })
            } catch (err) {
              let e: BusinessError = err as BusinessError;
              console.error(TAG, 'show result failed, message: ' + e.message + ', code: ' + e.code)
            }
          } else if (errCode === CMModelErrorCode.CM_MODEL_ERROR_INCORRECT_FORMAT) {
            AlertDialog.show({
              message: $r('app.string.Install_ERROR_INCORRECT_FORMAT'),
              autoCancel: true,
              alignment: DialogAlignment.Bottom,
              offset: {
                dx: 0, dy: 0
              },
              gridCount: 4,
              primaryButton: {
                value: $r('app.string.OK'),
                action: () => {
                  router.back()
                }
              },
            })
          } else if (errCode === CMModelErrorCode.CM_MODEL_ERROR_MAX_QUANTITY_REACHED) {
            AlertDialog.show({
              message: $r('app.string.Install_Error_MAX_QUANTITY_REACHED'),
              autoCancel: true,
              alignment: DialogAlignment.Bottom,
              offset: {
                dx: 0, dy: 0
              },
              gridCount: 4,
              primaryButton: {
                value: $r('app.string.OK'),
                action: () => {
                  router.back()
                }
              },
            })
          } else {
            try {
              promptAction.showToast({
                message: this.optType === CMModelOptType.CM_MODEL_OPT_USER_CA ?
                $r('app.string.Install_Cert_Failed') : $r('app.string.Install_Cred_Failed'),
                duration: 2000,
                bottom: 100
              })
            } catch (err) {
              let e: BusinessError = err as BusinessError;
              console.error(TAG, 'show result failed, message: ' + e.message + ', code: ' + e.code)
            }
          }
          router.clear();
          router.replaceUrl({
            url: 'pages/certManagerFa'
          });
        });
    });
  }
}